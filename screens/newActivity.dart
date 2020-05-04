import 'package:blimp/services/suggestions.dart';
import 'package:blimp/widgets/buttons.dart';
import 'package:blimp/widgets/fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/cupertino_flutter_typeahead.dart';

class NewActivity extends StatefulWidget {
  final List allActivities;
  final Function callback;
  NewActivity({this.allActivities, this.callback});
  @override
  State<StatefulWidget> createState() {
    return NewActivityState(allActivities: allActivities, callback: callback);
  }
}

class NewActivityState extends State<NewActivity> {
  final List allActivities;
  final Function callback;

  NewActivityState({this.allActivities, this.callback});

  Map newActivity = {};

  void addNewActivity() {
    setState(() {
      if (newActivity.length > 0) {
        Navigator.pop(context);
        callback(newActivity);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(30),
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
                    child: NewActivityField(
                      callback: typeNewActivity,
                      allActivities: allActivities,
                      typeAheadController: TextEditingController(),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: GestureDetector(
                  onTap: () {
                    addNewActivity();
                  },
                  child: AddActivityButton(),
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
      ),
    );
  }

  void typeNewActivity(Map activity) {
    newActivity = activity;
  }
}

class NewActivityField extends StatefulWidget {
  final Function callback;
  final TextEditingController typeAheadController;
  final List allActivities;

  NewActivityField(
      {this.allActivities, this.callback, this.typeAheadController});

  @override
  State<StatefulWidget> createState() {
    return NewActivityFieldState(
        allActivities: allActivities,
        callback: callback,
        typeAheadController: typeAheadController);
  }
}

class NewActivityFieldState extends State<NewActivityField> {
  final Function callback;
  final TextEditingController typeAheadController;
  final List allActivities;

  NewActivityFieldState(
      {this.callback, this.typeAheadController, this.allActivities});
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Padding(
        padding: EdgeInsets.only(left: 10),
        child: CupertinoTypeAheadField(
          textFieldConfiguration: CupertinoTextFieldConfiguration(
            placeholder: "Type activity here",
            maxLines: 2,
            onTap: () {
              typeAheadController.clear();
              callback({});
            },
            padding: EdgeInsets.only(left: 0, right: 6, top: 6, bottom: 6),
            controller: typeAheadController,
            autofocus: false,
            style: Theme.of(context).textTheme.headline2,
            decoration: BoxDecoration(),
          ),
          suggestionsCallback: (pattern) {
            return getSpecificActivitySuggestionsForQuery(
                allActivities, pattern);
          },
          suggestionsBoxDecoration: CupertinoSuggestionsBoxDecoration(
            offsetX: -10,
            borderRadius: BorderRadius.circular(15),
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
          ),
          hideOnLoading: true,
          hideSuggestionsOnKeyboardHide: true,
          hideOnEmpty: true,
          hideOnError: true,
          getImmediateSuggestions: true,
          suggestionsBoxController: CupertinoSuggestionsBoxController(),
          itemBuilder: (context, suggestion) {
            return Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: <Widget>[
                    Image(
                      image:
                          NetworkImage(suggestion["categoryIcon"] + "64.png"),
                      color: Colors.black,
                      width: 32,
                      height: 32,
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              suggestion["name"],
                              style: Theme.of(context).textTheme.bodyText1,
                              // overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              suggestion["category"],
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ));
          },
          onSuggestionSelected: (suggestion) {
            this.typeAheadController.text = suggestion["name"];

            callback(suggestion);
          },
        ),
      );
    });
  }
}

class BrowseActivitiesButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Color.fromRGBO(220, 220, 220, 1),
          width: 2,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          "Browse",
          style: Theme.of(context)
              .textTheme
              .button
              .copyWith(color: Theme.of(context).primaryColor),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Color.fromRGBO(220, 220, 220, 1),
          width: 2,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          "Add Random",
          style: Theme.of(context)
              .textTheme
              .button
              .copyWith(color: Theme.of(context).primaryColor),
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
