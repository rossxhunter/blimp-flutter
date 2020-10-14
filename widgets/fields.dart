import 'package:blimp/services/suggestions.dart';
import 'package:blimp/styles/colors.dart';
import 'package:blimp/widgets/icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
// import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_typeahead/cupertino_flutter_typeahead.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OriginDestinationField extends StatefulWidget {
  final String point;
  final int originId;
  final int destId;
  final Function callback;
  final TextEditingController controller;
  OriginDestinationField(
      {this.point, this.destId, this.originId, this.callback, this.controller});
  @override
  State<StatefulWidget> createState() {
    return OriginDestinationFieldState(
        point: point, callback: callback, typeAheadController: controller);
  }
}

class ActivitiesField extends StatefulWidget {
  final Function callback;
  final TextEditingController controller;
  ActivitiesField({this.callback, this.controller});
  @override
  State<StatefulWidget> createState() {
    return ActivitiesFieldState(
        callback: callback, typeAheadController: controller);
  }
}

class OriginDestinationFieldState extends State<OriginDestinationField> {
  final String point;
  final Function callback;
  final TextEditingController typeAheadController;
  EmojiParser parser = EmojiParser();

  OriginDestinationFieldState(
      {this.point, this.callback, this.typeAheadController});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        // border: Border.all(
        //   color: CustomColors.lightGrey,
        //   width: 3,
        // ),
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Padding(
            padding: EdgeInsets.all(0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 20, left: 0),
                  child: IconBox(
                    icon: _getIcon(),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(point),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 60),
                          child: CupertinoTypeAheadField(
                            textFieldConfiguration:
                                CupertinoTextFieldConfiguration(
                              onChanged: (var value) {},
                              maxLines: 2,
                              placeholder: "City or Airport",
                              onTap: () {
                                typeAheadController.clear();
                                callback(point, {});
                              },
                              padding: EdgeInsets.only(
                                  left: 0, right: 6, top: 5, bottom: 6),
                              controller: typeAheadController,
                              autofocus: false,
                              style: Theme.of(context).textTheme.headline2,
                              decoration: BoxDecoration(
                                  // border: Border(
                                  //   bottom: BorderSide(
                                  //     color: CustomColors.lightGrey,
                                  //     width: 2,
                                  //   ),
                                  // ),

                                  ),
                            ),
                            suggestionsCallback: (pattern) {
                              return suggestions
                                  .getDestinationSuggestionsForQuery(pattern,
                                      point, widget.originId, widget.destId);
                            },
                            suggestionsBoxDecoration:
                                CupertinoSuggestionsBoxDecoration(
                              offsetX: -110,
                              borderRadius: BorderRadius.circular(15),
                              constraints: BoxConstraints(
                                  minWidth: MediaQuery.of(context).size.width),
                            ),
                            hideOnLoading: true,
                            hideSuggestionsOnKeyboardHide: true,
                            hideOnEmpty: true,
                            hideOnError: true,
                            getImmediateSuggestions: true,
                            suggestionsBoxController:
                                CupertinoSuggestionsBoxController(),
                            itemBuilder: (context, suggestion) {
                              return Padding(
                                padding: EdgeInsets.all(20),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      parser
                                          .get("flag-" +
                                              suggestion["countryCode"])
                                          .code,
                                      style:
                                          Theme.of(context).textTheme.headline4,
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              suggestion["type"] == "city"
                                                  ? suggestion["cityName"] +
                                                      " - All Aiports"
                                                  : suggestion["airportName"],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1,
                                              // overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              suggestion["type"] == "city"
                                                  ? suggestion["countryName"]
                                                  : suggestion["cityName"],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            onSuggestionSelected: (suggestion) {
                              this.typeAheadController.text =
                                  suggestion["type"] == "city"
                                      ? suggestion["cityName"]
                                      : suggestion["airportName"];
                              callback(point, suggestion);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  IconData _getIcon() {
    if (point == "From") {
      return Icons.flight_takeoff;
    } else if (point == "Destination") {
      return Icons.flight_land;
    }
  }
}

class ActivitiesFieldState extends State<ActivitiesField> {
  final Function callback;
  final TextEditingController typeAheadController;

  ActivitiesFieldState({this.callback, this.typeAheadController});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        // border: Border.all(
        //   color: CustomColors.lightGrey,
        //   width: 3,
        // ),
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Padding(
            padding: EdgeInsets.all(0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 20, left: 0),
                  child: IconBox(
                    icon: FontAwesomeIcons.mapMarkedAlt,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text("Preferred Activities"),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 60),
                          child: CupertinoTypeAheadField(
                            textFieldConfiguration:
                                CupertinoTextFieldConfiguration(
                              onChanged: (var value) {},
                              maxLines: 2,
                              placeholder: "e.g. History Museum",
                              onTap: () {
                                typeAheadController.clear();
                                callback({});
                              },
                              padding: EdgeInsets.only(
                                  left: 0, right: 6, top: 5, bottom: 6),
                              controller: typeAheadController,
                              autofocus: false,
                              style: Theme.of(context).textTheme.headline2,
                              decoration: BoxDecoration(),
                            ),
                            suggestionsCallback: (pattern) {
                              return suggestions
                                  .getActivitySuggestionsForQuery(pattern);
                            },
                            suggestionsBoxDecoration:
                                CupertinoSuggestionsBoxDecoration(
                              offsetX: -110,
                              borderRadius: BorderRadius.circular(15),
                              constraints: BoxConstraints(
                                  minWidth: MediaQuery.of(context).size.width),
                            ),
                            hideOnLoading: true,
                            hideSuggestionsOnKeyboardHide: true,
                            hideOnEmpty: true,
                            hideOnError: true,
                            getImmediateSuggestions: true,
                            suggestionsBoxController:
                                CupertinoSuggestionsBoxController(),
                            itemBuilder: (context, suggestion) {
                              return Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Row(
                                    children: <Widget>[
                                      Image(
                                        image: NetworkImage(
                                            suggestion["icon"] + "64.png"),
                                        color: Colors.black,
                                        width: 32,
                                        height: 32,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 20),
                                          child: Text(
                                            suggestion["name"],
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                            // overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ));
                            },
                            onSuggestionSelected: (suggestion) {
                              this.typeAheadController.text =
                                  suggestion["name"];
                              callback(suggestion);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CustomCheckbox extends StatefulWidget {
  final Function callback;
  CustomCheckbox({this.callback});
  @override
  State<StatefulWidget> createState() {
    return CustomCheckboxState();
  }
}

class CustomCheckboxState extends State<CustomCheckbox> {
  bool checkboxValue = false;
  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: checkboxValue,
      activeColor: Theme.of(context).primaryColor,
      onChanged: (bool newValue) {
        setState(() {
          checkboxValue = newValue;
          widget.callback(newValue);
        });
        Text('Remember me');
      },
    );
  }
}

class CustomTextFormField extends StatelessWidget {
  String initialValue;
  String labelText;
  IconData prefixIcon;
  Function onSaved;
  Function validator;
  CustomTextFormField({
    this.initialValue,
    this.labelText,
    this.prefixIcon,
    this.onSaved,
    this.validator,
  });
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(
          prefixIcon,
          size: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
          borderSide: BorderSide(
            width: 1,
            style: BorderStyle.solid,
            color: Colors.grey,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
          borderSide: BorderSide(
            width: 1,
            style: BorderStyle.solid,
            color: Colors.grey,
          ),
        ),
        fillColor: Colors.white,
        filled: true,
      ),
      onSaved: onSaved,
      validator: validator,
    );
  }
}

class CustomDropdownButtonFormField extends StatelessWidget {
  String initialValue;
  String labelText;
  IconData prefixIcon;
  Function onSaved;
  List items;
  CustomDropdownButtonFormField({
    this.initialValue,
    this.labelText,
    this.prefixIcon,
    this.onSaved,
    this.items,
  });
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      isExpanded: true,
      value: initialValue,
      onSaved: onSaved,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(
          prefixIcon,
          size: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
          borderSide: BorderSide(
            width: 1,
            style: BorderStyle.solid,
            color: Colors.grey,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
          borderSide: BorderSide(
            width: 1,
            style: BorderStyle.solid,
            color: Colors.grey,
          ),
        ),
        fillColor: Colors.white,
        filled: true,
      ),
      onChanged: (value) {},
      items: _getItems(context),
    );
  }

  List<DropdownMenuItem> _getItems(BuildContext context) {
    var parser = EmojiParser();
    List<DropdownMenuItem> dropdownItems = [];
    for (Map item in items) {
      dropdownItems.add(
        DropdownMenuItem(
          value: item["name"],
          child: IntrinsicWidth(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  parser.get("flag-" + item["code"].toLowerCase()).code,
                  style: Theme.of(context).textTheme.headline3,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      item["name"],
                      maxLines: 2,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return dropdownItems;
  }
}

class CustomField {
  final CustomFieldType type;
  final String field;
  final String initialValue;
  final String labelText;
  final IconData prefixIcon;
  final List items;
  final Function validator;

  CustomField({
    @required this.type,
    @required this.field,
    @required this.initialValue,
    @required this.labelText,
    @required this.prefixIcon,
    this.items,
    this.validator,
  });
}

enum CustomFieldType { text, dropdown }
