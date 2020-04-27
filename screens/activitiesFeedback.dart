import 'package:blimp/model/preferences.dart';
import 'package:blimp/screens/feedback.dart';
import 'package:blimp/services/suggestions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ActivitiesFeedbackScreen extends StatefulWidget {
  final Preferences preferences;
  final int destId;
  final Function callback;

  ActivitiesFeedbackScreen({this.preferences, this.destId, this.callback});

  @override
  State<StatefulWidget> createState() {
    return ActivitiesFeedbackScreenState(
        preferences: preferences, destId: destId, callback: callback);
  }
}

class ActivitiesFeedbackScreenState extends State<ActivitiesFeedbackScreen> {
  final Preferences preferences;
  final int destId;
  final Function callback;

  List preferredActivities;

  ActivitiesFeedbackScreenState(
      {this.preferences, this.destId, this.callback}) {
    preferredActivities = preferences.softPreferences
        .where((sp) => sp.property == "preferred_activities")
        .toList()[0]
        .value;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 140),
          child: ListView.builder(
            itemCount: preferredActivities.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return FeedbackOption(
                text: "More " + getActivityFromId(preferredActivities[index]),
                iconData: Icons.beach_access,
                color: Colors.green,
              );
            },
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: FeedbackOption(
            text: "Change Activity Preferences",
            iconData: Icons.shuffle,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }
}
