import 'package:blimp/widgets/buttons.dart';
import 'package:blimp/widgets/fields.dart';
import 'package:blimp/widgets/icons.dart';
import 'package:blimp/widgets/selectors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ActivitiesOptions extends StatefulWidget {
  final List<double> windowTimes;
  final Function callback;
  ActivitiesOptions({this.windowTimes, this.callback});
  @override
  State<StatefulWidget> createState() {
    return ActivitiesOptionsState(windowTimes: windowTimes, callback: callback);
  }
}

class ActivitiesOptionsState extends State<ActivitiesOptions> {
  List<double> windowTimes;
  final Function callback;
  bool allDays = false;
  ActivitiesOptionsState({this.windowTimes, this.callback});
  void updateActivitiesWindow(double lowerValue, upperValue) {
    setState(() {
      windowTimes[0] = lowerValue;
      windowTimes[1] = upperValue;
    });
  }

  void updateAllDays(bool value) {
    allDays = value;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        IconBox(icon: Icons.timer),
                        Expanded(
                          child: DoubleSlider(
                            callback: updateActivitiesWindow,
                            isLogarithmic: false,
                            min: 6,
                            max: 24,
                            lowerValue: windowTimes[0],
                            upperValue: windowTimes[1],
                            step: 1 / 100,
                            minDistance: 1,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        "Activities Window: " +
                            DateFormat('ha').format(DateTime.utc(
                                2020, 2, 2, windowTimes[0].toInt())) +
                            " - " +
                            DateFormat('ha').format(DateTime.utc(
                                2020, 2, 2, windowTimes[1].toInt())),
                        style: Theme.of(context).textTheme.headline1,
                      ),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.only(top: 10),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       Text("Apply to all Days"),
                    //       CustomCheckbox(
                    //         callback: updateAllDays,
                    //       )
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: GestureDetector(
                    onTap: () {
                      callback(windowTimes);
                      Navigator.pop(context);
                    },
                    child: ConfirmButton(),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
