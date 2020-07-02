import 'package:flutter/material.dart';
import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';
import 'package:flutter_task_planner_app/widgets/gradient_container.dart';

class ScanResult extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Column(
            children: [
              Container(
                child: Text(
                  'Matthew Troost',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 32.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              GradientContainer(
                strokeWidth: 4,
                radius: 20,
                backgroundColor: LightColors.kDarkContrastBlue,
                text: "Student",
                gradient: LinearGradient(
                  colors: [LightColors.kSalmon, LightColors.kPurple],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                child: Text('R25', style: TextStyle(fontSize: 20, color: LightColors.kPurple)),
                onPressed: () => {},
              )
            ],
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: RaisedButton(
            child: const Text("Select Amount (right arrow)",
                style: TextStyle(
                  color: LightColors.kDarkBlue,
                  fontWeight: FontWeight.w700,
                )),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0)),
            padding: EdgeInsets.all(10.0),
            color: LightColors.kLightBlue,
            onPressed: () => {},
          ),
        )
      ],
    );
  }
}
