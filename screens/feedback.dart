import 'dart:ui';

import 'package:blimp/model/preferences.dart';
import 'package:blimp/routes.dart';
import 'package:blimp/screens/activitiesFeedback.dart';
import 'package:blimp/screens/results.dart';
import 'package:blimp/services/http.dart';
import 'package:blimp/styles/colors.dart';
import 'package:blimp/widgets/alerts.dart';
import 'package:blimp/widgets/buttons.dart';
import 'package:blimp/widgets/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class FeedbackScreen extends StatefulWidget {
  final Preferences preferences;
  final int destId;
  final List categoryIds;
  final int duration;
  final double price;
  final Map weather;

  FeedbackScreen(
      {this.preferences,
      this.duration,
      this.categoryIds,
      this.destId,
      this.price,
      this.weather});

  @override
  State<StatefulWidget> createState() {
    preferences.constraints.removeWhere((c) => c.property == "destination");

    return FeedbackScreenState(
      preferences: preferences,
      duration: duration,
      categoryIds: categoryIds,
      destId: destId,
      price: price,
      weather: weather,
    );
  }
}

class FeedbackScreenState extends State<FeedbackScreen> {
  final Preferences preferences;
  final int destId;
  final List categoryIds;
  final int duration;
  final double price;
  final Map weather;

  bool _shouldShowBackButton = false;

  Widget _currentFeedbackWidget;

  FeedbackScreenState(
      {this.preferences,
      this.categoryIds,
      this.duration,
      this.destId,
      this.price,
      this.weather}) {
    _currentFeedbackWidget = FeedbackMainScreen(
      preferences: preferences,
      destId: destId,
      duration: duration,
      callback: furtherOptionsButtonPressed,
      price: price,
      weather: weather,
    );
  }

  void backButtonPressed() {
    setState(() {
      _currentFeedbackWidget = FeedbackMainScreen(
          preferences: preferences,
          destId: destId,
          callback: furtherOptionsButtonPressed,
          price: price,
          weather: weather);
      _shouldShowBackButton = false;
    });
  }

  void furtherOptionsButtonPressed(String option) {
    if (option == "activities") {
      setState(() {
        _currentFeedbackWidget = ActivitiesFeedbackScreen(
            preferences: preferences,
            destId: destId,
            categoryIds: categoryIds,
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
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(20),
            ),
            child: AnimatedSwitcher(
              duration: Duration(microseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(
                  child: child,
                  scale: animation,
                );
              },
              child: _currentFeedbackWidget,
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
  final int duration;
  final Function callback;
  final double price;
  final Map weather;

  FeedbackMainScreen(
      {this.preferences,
      this.destId,
      this.duration,
      this.callback,
      this.price,
      this.weather});

  @override
  State<StatefulWidget> createState() {
    return FeedbackMainScreenState(
        preferences: preferences,
        destId: destId,
        duration: duration,
        callback: callback,
        price: price,
        weather: weather);
  }
}

class FeedbackMainScreenState extends State<FeedbackMainScreen> {
  final Preferences preferences;
  final int destId;
  final int duration;
  final Function callback;
  final double price;
  final Map weather;

  FeedbackMainScreenState(
      {this.preferences,
      this.destId,
      this.duration,
      this.callback,
      this.price,
      this.weather});

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
              AnimatedButton(
                callback: () => fetchFeedbackHoliday(context, preferences, {
                  "type": "cheaper",
                  "previous_dest_id": destId,
                  "previous_price": price
                }),
                child: FeedbackOption(
                  text: "Cheaper",
                  icon: Icon(
                    Icons.attach_money,
                    color: Colors.white,
                  ),
                  color: Colors.purple,
                  preferences: preferences,
                  destId: destId,
                ),
              ),
              AnimatedButton(
                callback: () => fetchFeedbackHoliday(context, preferences, {
                  "type": "closer",
                  "previous_dest_id": destId,
                  "previous_travel_duration": duration,
                }),
                child: FeedbackOption(
                  text: "Closer",
                  icon: Icon(
                    Icons.flight,
                    color: Colors.white,
                  ),
                  color: Colors.blue,
                  preferences: preferences,
                  destId: destId,
                ),
              ),
              AnimatedButton(
                callback: () => fetchFeedbackHoliday(context, preferences, {
                  "type": "better_weather",
                  "previous_dest_id": destId,
                  "previous_av_temp": weather["temp"]
                }),
                child: FeedbackOption(
                  text: "Better Weather",
                  icon: Icon(
                    Icons.wb_sunny,
                    color: Colors.white,
                  ),
                  color: Colors.orange,
                  preferences: preferences,
                  destId: destId,
                ),
              ),
              AnimatedButton(
                callback: () => callback("activities"),
                child: FeedbackOption(
                  text: "Different Activities",
                  icon: Icon(
                    Icons.beach_access,
                    color: Colors.white,
                  ),
                  color: Colors.green,
                ),
              ),
              AnimatedButton(
                callback: () => fetchFeedbackHoliday(context, preferences, {
                  "type": "different",
                  "previous_dest_id": destId,
                }),
                child: FeedbackOption(
                  text: "Just Different",
                  icon: Icon(
                    CupertinoIcons.shuffle_thick,
                    color: Colors.white,
                  ),
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
          builder: (context) => ResultsPageRoute(holiday, preferences).page(),
        ),
      );
      registerClick(feedback["type"], "standard", {
        "previous_dest_id": feedback["previous_dest_id"],
        "new_dest_id": holiday["destId"]
      });
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
    registerClick(feedback["type"], "standard", {
      "previous_dest_id": feedback["previous_dest_id"],
      "error": e.toString()
    });
  });
}

class FeedbackOption extends StatelessWidget {
  final String text;
  final Widget icon;
  final Color color;
  final Preferences preferences;
  final int destId;

  FeedbackOption(
      {this.text, this.icon, this.color, this.preferences, this.destId});
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
            icon,
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
