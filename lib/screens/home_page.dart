import 'package:flutter/material.dart';
import 'package:flutter_task_planner_app/screens/calendar_page.dart';
import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_task_planner_app/widgets/task_column.dart';
import 'package:flutter_task_planner_app/widgets/active_project_card.dart';
import 'package:flutter_task_planner_app/widgets/gradient_container.dart';

import 'dart:async';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';

import '../theme/colors/light_colors.dart';
import '../theme/colors/light_colors.dart';
import '../theme/colors/light_colors.dart';
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
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              color: LightColors.kDarkBlue,
              height: 200,
              width: width,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(Icons.menu, color: Colors.white, size: 30.0),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                child: Text(
                                  'Tell us',
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
                                  'what you love',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 32.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
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
              child: ShaderMask(
                shaderCallback: (Rect rect) {
                  return LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[Colors.transparent, LightColors.kDarkBlue],
                  ).createShader(Rect.fromLTRB(
                      0, 0, rect.width, rect.height - (0.9 * rect.height)));
                },
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        color: Colors.transparent,
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 15.0),
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
                                onPressed: _toggleScan,
                              ),
                            ),
                            GradientContainer(
                              strokeWidth: 4,
                              radius: 20,
                              backgroundColor: LightColors.kDarkContrastBlue,
                              gradient: LinearGradient(
                                colors: [LightColors.kSalmon, LightColors.kPurple],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              child:
                                  Text('Wow', style: TextStyle(fontSize: 16)),
                              onPressed: () {},
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            
                          ],
                        ),
                      ),
                     
                    ],
                  ),
                ),
                blendMode: BlendMode.dstATop,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
