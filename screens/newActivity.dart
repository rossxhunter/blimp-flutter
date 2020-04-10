import 'package:blimp/widgets/buttons.dart';
import 'package:blimp/widgets/fields.dart';
import 'package:flutter/material.dart';

class NewActivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: new BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: SearchField(
                    callback: typeNewActivity,
                    point: "New Activity",
                    controller: TextEditingController(),
                  ),
                ),
                // Padding(
                //   padding: EdgeInsets.only(left: 20),
                //   child: AddActivityButton(),
                // ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: AddActivityButton(),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                "OR",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: BrowseActivitiesButton(),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: AddRandomActivityButton(),
            ),
          ],
        ),
      ),
    );
  }

  void typeNewActivity(Map activity) {
    // newActivity = activity;
  }
}

class BrowseActivitiesButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          "Browse",
          style: Theme.of(context).textTheme.button,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class AddRandomActivityButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          "Add Random",
          style: Theme.of(context).textTheme.button,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class AddActivityButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            "Add",
            style: Theme.of(context).textTheme.button,
            textAlign: TextAlign.center,
          )),
    );
  }
}
