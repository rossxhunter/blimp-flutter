import 'package:blimp/model/preferences.dart';
import 'package:blimp/screens/feedback.dart';
import 'package:blimp/screens/vibeFeedback.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ActivitiesFeedbackScreen extends StatelessWidget {
  final Preferences preferences;
  final int destId;
  final Function callback;

  ActivitiesFeedbackScreen({this.preferences, this.destId, this.callback});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          children: <Widget>[
            FeedbackOption(
              text: "More of",
              iconData: Icons.add,
              color: Colors.purple,
              preferences: preferences,
              destId: destId,
            ),
            FeedbackOption(
              text: "Less of",
              iconData: Icons.score,
              color: Colors.blue,
              preferences: preferences,
              destId: destId,
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: 20),
          child: GestureDetector(
            onTap: () => callback(),
            child: BackOption(),
          ),
        ),
      ],
    );
  }
}
