import 'package:blimp/screens/holidayItineraryEvaluation.dart';
import 'package:blimp/services/clicks.dart';
import 'package:blimp/services/http.dart';
import 'package:blimp/services/suggestions.dart';
import 'package:blimp/styles/colors.dart';
import 'package:blimp/widgets/alerts.dart';
import 'package:blimp/widgets/buttons.dart';
import 'package:blimp/widgets/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TestingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TestingPageState();
  }
}

class TestingPageState extends State<TestingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          child: Padding(
            padding: EdgeInsets.only(left: 30, top: 30, right: 30),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Testing",
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    CupertinoSwitch(
                      value: testingSwitchOn,
                      onChanged: (value) {
                        setState(() {
                          testingSwitchOn = value;
                        });
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: ListView.builder(
                      itemCount: getTestingSuggestions().length,
                      itemExtent: 100,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: TestOption(
                            city: getTestingSuggestions()[index],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TestOption extends StatelessWidget {
  final Map city;

  TestOption({this.city});

  @override
  Widget build(BuildContext context) {
    return AnimatedButton(
      callback: () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return LoadingIndicator();
          },
        );
        getItinerariesForEvaluation(city["id"]).then((result) {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HolidayItineraryEvaluation(
                city: city,
                itineraries: result["itineraries"],
                allActivities: result["all_activities"],
              ),
            ),
          );
        }).catchError((e) {
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (BuildContext context) => CustomDialog(
              title: "Error",
              description: "Unable to get itineraries - " + e.toString(),
            ),
          );
        });
      },
      child: SizedBox.expand(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: CustomColors.lightGrey,
              width: 3,
            ),
          ),
          child: Center(
            child: Text(
              city["name"] + " Itineraries",
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(color: Theme.of(context).primaryColor),
            ),
          ),
        ),
      ),
    );
  }
}
