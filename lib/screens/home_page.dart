import 'package:flutter/material.dart';
import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'dart:async';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';
import 'package:flutter_task_planner_app/widgets/scan_result.dart';

import '../theme/colors/light_colors.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();

  static CircleAvatar calendarIcon() {
    return CircleAvatar(
      radius: 25.0,
      backgroundColor: LightColors.kDarkBlue,
      child: Icon(
        Icons.calendar_today,
        size: 20.0,
        color: Colors.white,
      ),
    );
  }
}

class _HomePageState extends State<HomePage> {
  StreamSubscription<NDEFMessage> _stream;
  PanelController _panelController = new PanelController();

  Text subheading(String title) {
    return Text(
      title,
      style: TextStyle(
          color: LightColors.kDarkBlue,
          fontSize: 20.0,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2),
    );
  }

  void _startScanning() {
    setState(() {
      _stream = NFC
          .readNDEF(alertMessage: "Custom message with readNDEF#alertMessage")
          .listen((NDEFMessage message) {
        if (message.isEmpty) {
          print("Read empty NDEF message");
          return;
        }
        print("Read NDEF message with ${message.records.length} records");
        for (NDEFRecord record in message.records) {
          print(
              "Record '${record.id ?? "[NO ID]"}' with TNF '${record.tnf}', type '${record.type}', payload '${record.payload}' and data '${record.data}' and language code '${record.languageCode}'");
        }
      }, onError: (error) {
        setState(() {
          _stream = null;
        });
        if (error is NFCUserCanceledSessionException) {
          print("user canceled");
        } else if (error is NFCSessionTimeoutException) {
          print("session timed out");
        } else {
          print("error: $error");
        }
      }, onDone: () {
        setState(() {
          _stream = null;
        });
      });
    });
  }

  void _stopScanning() {
    _stream?.cancel();
    setState(() {
      _stream = null;
    });
  }

  void _toggleScan() {
    if (_stream == null) {
      _startScanning();
    } else {
      _stopScanning();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _stopScanning();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: LightColors.kDarkBlue,
        body: SlidingUpPanel(
          minHeight: 0,
          controller: _panelController,
          backdropEnabled: true,
          backdropOpacity: 0.9,
          renderPanelSheet: false,
          parallaxEnabled: true,
          color: LightColors.kDarkBlue,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          ),
          panel: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: LightColors.kDarkBlue,
                borderRadius: BorderRadius.all(Radius.circular(24.0))),
            margin: const EdgeInsets.all(15.0),
            child: ScanResult(),
          ),
          body: SafeArea(
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      color: LightColors.kDarkBlue,
                      height: 200,
                      width: width,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Icon(Icons.menu,
                                    color: Colors.white, size: 30.0),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 0.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        child: Text(
                                          'Nymbit',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontSize: 32.0,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: Text(
                                          'Meerendal MTB',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontSize: 32.0,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        child: Text(
                                          'So we can show you what you like. Come back and change this whenever.',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontSize: 10.0,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ]),
                    ),
                    Expanded(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: RaisedButton(
                                child: const Text("Scan Bit",
                                    style: TextStyle(
                                      color: LightColors.kDarkBlue,
                                      fontWeight: FontWeight.w700,
                                    )),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0)),
                                padding: EdgeInsets.all(10.0),
                                color: LightColors.kLightBlue,
                                // onPressed: _toggleScan,
                                onPressed: () => _panelController.open(),
                              ),
                            )
                          ]),
                    ),
                  ],
                )),
          ),
        ));
  }
}
