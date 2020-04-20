import 'package:auto_size_text/auto_size_text.dart';
import 'package:blimp/model/preferences.dart';
import 'package:blimp/screens/feedback.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class VibeFeedbackScreen extends StatelessWidget {
  final Preferences preferences;
  final int destId;
  final Function callback;

  VibeFeedbackScreen({this.preferences, this.destId, this.callback});

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
            GestureDetector(
              onTap: () => fetchFeedbackHoliday(context, preferences, {
                "type": "cultural",
                "previous_dest_id": destId,
              }),
              child: FeedbackOption(
                text: "Cultural",
                iconData: Icons.map,
                color: Colors.purple,
                preferences: preferences,
                destId: destId,
              ),
            ),
            GestureDetector(
              onTap: () => fetchFeedbackHoliday(context, preferences, {
                "type": "educational",
                "previous_dest_id": destId,
              }),
              child: FeedbackOption(
                text: "Educational",
                iconData: Icons.book,
                color: Colors.blue,
                preferences: preferences,
                destId: destId,
              ),
            ),
            GestureDetector(
              onTap: () => fetchFeedbackHoliday(context, preferences, {
                "type": "adventurous",
                "previous_dest_id": destId,
              }),
              child: FeedbackOption(
                text: "Adventurous",
                iconData: Icons.directions_run,
                color: Colors.orange,
                preferences: preferences,
                destId: destId,
              ),
            ),
            GestureDetector(
              onTap: () => fetchFeedbackHoliday(context, preferences, {
                "type": "sporty",
                "previous_dest_id": destId,
              }),
              child: FeedbackOption(
                text: "Sporty",
                iconData: Icons.directions_bike,
                color: Colors.green,
                preferences: preferences,
                destId: destId,
              ),
            ),
            GestureDetector(
              onTap: () => fetchFeedbackHoliday(context, preferences, {
                "type": "foody",
                "previous_dest_id": destId,
              }),
              child: FeedbackOption(
                text: "Foody",
                iconData: Icons.local_dining,
                color: Colors.lightBlue,
              ),
            ),
            GestureDetector(
              onTap: () => fetchFeedbackHoliday(context, preferences, {
                "type": "relaxing",
                "previous_dest_id": destId,
              }),
              child: FeedbackOption(
                text: "Relaxing",
                iconData: Icons.spa,
                color: Theme.of(context).primaryColor,
              ),
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

class BackOption extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Theme.of(context).primaryColor,
          width: 4,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: AutoSizeText(
                "Back",
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
