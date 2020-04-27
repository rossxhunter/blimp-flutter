import 'dart:ui';

import 'package:blimp/model/preferences.dart';
import 'package:blimp/screens/activitiesFeedback.dart';
import 'package:blimp/screens/results.dart';
import 'package:blimp/services/http.dart';
import 'package:blimp/styles/colors.dart';
import 'package:blimp/widgets/alerts.dart';
import 'package:blimp/widgets/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class FeedbackScreen extends StatefulWidget {
  final Preferences preferences;
  final int destId;
  final double price;

  FeedbackScreen({this.preferences, this.destId, this.price});

  @override
  State<StatefulWidget> createState() {
    return FeedbackScreenState(
        preferences: preferences, destId: destId, price: price);
  }
}

class FeedbackScreenState extends State<FeedbackScreen> {
  final Preferences preferences;
  final int destId;
  final double price;

  bool _shouldShowBackButton = false;

  Widget _currentFeedbackWidget;

  FeedbackScreenState({this.preferences, this.destId, this.price}) {
    _currentFeedbackWidget = FeedbackMainScreen(
      preferences: preferences,
      destId: destId,
      callback: furtherOptionsButtonPressed,
      price: price,
    );
  }

  void backButtonPressed() {
    setState(() {
      _currentFeedbackWidget = FeedbackMainScreen(
        preferences: preferences,
        destId: destId,
        callback: furtherOptionsButtonPressed,
        price: price,
      );
      _shouldShowBackButton = false;
    });
  }

  void furtherOptionsButtonPressed(String option) {
    if (option == "activities") {
      setState(() {
        _currentFeedbackWidget = ActivitiesFeedbackScreen(
            preferences: preferences,
            destId: destId,
            callback: backButtonPressed);
        _shouldShowBackButton = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: new BoxDecoration(
              // color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(20),
              // border: Border.all(
              //   color: CustomColors.lightGrey,
              //   width: 0,
              // ),
            ),
            child: AnimatedSwitcher(
              duration: Duration(microseconds: 300),
              //Enable this for ScaleTransition
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(
                  child: child,
                  scale: animation,
                );
              },
              //Enable this for RotationTransition
              // transitionBuilder: (Widget child, Animation<double> animation) {
              //   return RotationTransition(
              //     child: child,
              //     turns: animation,
              //   );
              // },
              child: _currentFeedbackWidget,
            ),
          ),
        ),
        // Positioned(
        //   right: 30,
        //   top: 20,
        //   child: Material(
        //     color: Colors.transparent,
        //     child: IconButton(
        //       onPressed: () {
        //         Navigator.pop(context);
        //       },
        //       icon: Icon(
        //         Icons.close,
        //         color: Theme.of(context).primaryColor,
        //         size: 40,
        //       ),
        //     ),
        //   ),
        // ),
        Positioned(
          left: 30,
          top: 20,
          child: Visibility(
            visible: _shouldShowBackButton,
            child: Material(
              color: Colors.transparent,
              child: IconButton(
                onPressed: () {
                  backButtonPressed();
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).primaryColor,
                  size: 40,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class FeedbackMainScreen extends StatefulWidget {
  final Preferences preferences;
  final int destId;
  final Function callback;
  final double price;

  FeedbackMainScreen(
      {this.preferences, this.destId, this.callback, this.price});

  @override
  State<StatefulWidget> createState() {
    return FeedbackMainScreenState(
        preferences: preferences,
        destId: destId,
        callback: callback,
        price: price);
  }
}

class FeedbackMainScreenState extends State<FeedbackMainScreen> {
  final Preferences preferences;
  final int destId;
  final Function callback;
  final double price;

  FeedbackMainScreenState(
      {this.preferences, this.destId, this.callback, this.price});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 0),
          child: GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            children: <Widget>[
              GestureDetector(
                onTap: () => fetchFeedbackHoliday(context, preferences, {
                  "type": "cheaper",
                  "previous_dest_id": destId,
                  "previous_price": price
                }),
                child: FeedbackOption(
                  text: "Cheaper",
                  iconData: Icons.attach_money,
                  color: Colors.purple,
                  preferences: preferences,
                  destId: destId,
                ),
              ),
              GestureDetector(
                onTap: () => fetchFeedbackHoliday(context, preferences, {
                  "type": "closer",
                  "previous_dest_id": destId,
                }),
                child: FeedbackOption(
                  text: "Closer",
                  iconData: Icons.flight,
                  color: Colors.blue,
                  preferences: preferences,
                  destId: destId,
                ),
              ),
              GestureDetector(
                onTap: () => fetchFeedbackHoliday(context, preferences, {
                  "type": "better_weather",
                  "previous_dest_id": destId,
                }),
                child: FeedbackOption(
                  text: "Better Weather",
                  iconData: Icons.wb_sunny,
                  color: Colors.orange,
                  preferences: preferences,
                  destId: destId,
                ),
              ),
              GestureDetector(
                onTap: () => callback("activities"),
                child: FeedbackOption(
                  text: "Different Activities",
                  iconData: Icons.beach_access,
                  color: Colors.green,
                ),
              ),
              GestureDetector(
                onTap: () => fetchFeedbackHoliday(context, preferences, {
                  "type": "different",
                  "previous_dest_id": destId,
                }),
                child: FeedbackOption(
                  text: "Just Different",
                  iconData: CupertinoIcons.shuffle_thick,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [],
          ),
        ),
      ],
    );
  }
}

void fetchFeedbackHoliday(
    BuildContext context, Preferences preferences, Map feedback) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return LoadingIndicator();
    },
  );
  getHolidayWithFeedback(preferences, feedback).then(
    (holiday) {
      print(holiday);
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultsPage(
            destId: holiday["destId"],
            name: holiday["name"],
            wiki: holiday["wiki"],
            imageURL: holiday["imageURL"],
            itinerary: holiday["itinerary"],
            flights: holiday["travel"],
            accommodation: holiday["accommodation"],
            allFlights: holiday["all_travel"],
            allAccommodation: holiday["all_accommodation"],
            allActivities: holiday["all_activities"],
            preferences: preferences,
          ),
        ),
      );
    },
  ).catchError((e) {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (BuildContext context) => CustomDialog(
        title: "Error",
        description: "Unable to fetch holiday - " + e.toString(),
      ),
    );
  });
}

class FeedbackOption extends StatelessWidget {
  final String text;
  final IconData iconData;
  final Color color;
  final Preferences preferences;
  final int destId;

  FeedbackOption(
      {this.text, this.iconData, this.color, this.preferences, this.destId});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              iconData,
              color: Colors.white,
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: AutoSizeText(
                text,
                maxLines: 2,
                wrapWords: false,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline3
                    .copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
