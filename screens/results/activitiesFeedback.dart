import 'package:blimp/model/preferences.dart';
import 'package:blimp/screens/results/feedback.dart';
import 'package:blimp/services/suggestions.dart';
import 'package:blimp/widgets/buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ActivitiesFeedbackScreen extends StatefulWidget {
  final Preferences preferences;
  final int destId;
  final List categoryIds;
  final Function callback;

  ActivitiesFeedbackScreen(
      {this.preferences, this.categoryIds, this.destId, this.callback});

  @override
  State<StatefulWidget> createState() {
    return ActivitiesFeedbackScreenState(
        preferences: preferences,
        categoryIds: categoryIds,
        destId: destId,
        callback: callback);
  }
}

class ActivitiesFeedbackScreenState extends State<ActivitiesFeedbackScreen> {
  final Preferences preferences;
  final int destId;
  final List categoryIds;
  final Function callback;

  List preferredActivities;

  ActivitiesFeedbackScreenState(
      {this.preferences, this.destId, this.categoryIds, this.callback}) {
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
          padding: EdgeInsets.only(bottom: 60, top: 60),
          child: SizedBox(
            child: MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: preferredActivities.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 20, left: 10, right: 10),
                    child: AnimatedButton(
                      callback: () =>
                          fetchFeedbackHoliday(context, preferences, {
                        "type": "more_activity",
                        "activity_id": preferredActivities[index],
                        "previous_dest_id": destId,
                        "previous_num": categoryIds
                            .where((c) => c == preferredActivities[index])
                            .length
                      }),
                      child: FeedbackOption(
                        text: "More " +
                            getActivityFromId(preferredActivities[index]),
                        icon: Image(
                          image: NetworkImage(
                            getActivityIconFromId(preferredActivities[index]) +
                                "32.png",
                          ),
                        ),
                        color: Colors.green,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          child: AnimatedButton(
            callback: callback,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(1000),
              ),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
