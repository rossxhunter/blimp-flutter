import 'package:blimp/widgets/icons.dart';
import 'package:blimp/widgets/selectors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FilterFlights extends StatefulWidget {
  final Function callback;
  final List<double> outboundTimes;
  final List<double> returnTimes;
  FilterFlights({this.callback, this.outboundTimes, this.returnTimes});
  @override
  State<StatefulWidget> createState() {
    return FilterFlightsState(
        callback: callback,
        outboundTimes: outboundTimes,
        returnTimes: returnTimes);
  }
}

class FilterFlightsState extends State<FilterFlights> {
  final Function callback;
  List<double> outboundTimes;
  List<double> returnTimes;

  FilterFlightsState({this.callback, this.outboundTimes, this.returnTimes});

  void updateOutboundSlider(double lowerValue, upperValue) {
    setState(() {
      outboundTimes[0] = lowerValue;
      outboundTimes[1] = upperValue;
    });
  }

  void updateReturnSlider(double lowerValue, upperValue) {
    setState(() {
      returnTimes[0] = lowerValue;
      returnTimes[1] = upperValue;
    });
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
                        IconBox(
                          icon: Icons.arrow_forward,
                        ),
                        Expanded(
                          child: DoubleSlider(
                            callback: updateOutboundSlider,
                            isLogarithmic: false,
                            min: 0,
                            max: 24,
                            lowerValue: outboundTimes[0],
                            upperValue: outboundTimes[1],
                            step: 1,
                            minDistance: 1,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        "Outbound Departure Time: " +
                            DateFormat('ha').format(DateTime.utc(
                                2020, 2, 2, outboundTimes[0].toInt())) +
                            " - " +
                            DateFormat('ha').format(DateTime.utc(
                                2020, 2, 2, outboundTimes[1].toInt())),
                        style: Theme.of(context).textTheme.headline1,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconBox(
                            icon: Icons.arrow_back,
                          ),
                          Expanded(
                            child: DoubleSlider(
                              callback: updateReturnSlider,
                              isLogarithmic: false,
                              min: 0,
                              max: 24,
                              lowerValue: returnTimes[0],
                              upperValue: returnTimes[1],
                              step: 1,
                              minDistance: 1,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          "Return Departure Time: " +
                              DateFormat('ha').format(DateTime.utc(
                                  2020, 2, 2, returnTimes[0].toInt())) +
                              " - " +
                              DateFormat('ha').format(DateTime.utc(
                                  2020, 2, 2, returnTimes[1].toInt())),
                          style: Theme.of(context).textTheme.headline1,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: GestureDetector(
                    onTap: () {
                      callback(outboundTimes, returnTimes);
                      Navigator.pop(context);
                    },
                    child: DoneButton(),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}

class DoneButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Text(
            "Filter",
            style: Theme.of(context)
                .textTheme
                .headline2
                .copyWith(color: Colors.white),
          ),
          //   Icon(
          // Icons.check,
          // color: Colors.white,
        ),
      ),
    );
  }
}
