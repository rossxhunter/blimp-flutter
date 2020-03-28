import 'package:blimp/services/suggestions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_typeahead/cupertino_flutter_typeahead.dart';

class SearchField extends StatefulWidget {
  final String point;
  final Function callback;
  final TextEditingController controller;
  SearchField({this.point, this.callback, this.controller});
  @override
  State<StatefulWidget> createState() {
    return SearchFieldState(
        point: point, callback: callback, typeAheadController: controller);
  }
}

class SearchFieldState extends State<SearchField> {
  final String point;
  final Function callback;
  final TextEditingController typeAheadController;

  SearchFieldState({this.point, this.callback, this.typeAheadController});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Color.fromRGBO(230, 230, 230, 0.8),
          width: 2,
        ),
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 20, left: 10),
                  child: Icon(
                    _getIcon(),
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(point),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: getRightPadding()),
                        child: CupertinoTypeAheadField(
                          textFieldConfiguration:
                              CupertinoTextFieldConfiguration(
                            onChanged: (var value) {
                              // if (point != "From" && point != "Destination") {
                              //   callback(value);
                              // } else {
                              //   callback(point, value);
                              // }
                            },
                            maxLines: 2,
                            onTap: () {
                              typeAheadController.clear();
                              if (point != "From" && point != "Destination") {
                                callback({});
                              } else {
                                callback(point, {});
                              }
                            },
                            padding: EdgeInsets.only(
                                left: 0, right: 6, top: 6, bottom: 6),
                            controller: typeAheadController,
                            autofocus: false,
                            style: Theme.of(context).textTheme.headline2,
                            decoration: BoxDecoration(),
                          ),
                          suggestionsCallback: (pattern) {
                            if (point != "From" && point != "Destination") {
                              return getActivitySuggestionsForQuery(pattern);
                            }
                            return getDestinationSuggestionsForQuery(pattern);
                          },
                          suggestionsBoxDecoration:
                              CupertinoSuggestionsBoxDecoration(
                            offsetX: -65,
                            borderRadius: BorderRadius.circular(15),
                            constraints:
                                BoxConstraints(minWidth: constraints.maxWidth),
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
                                    Icon(Icons.local_airport),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              suggestion["heading"],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1,
                                              // overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              suggestion["subheading"],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ));
                          },
                          onSuggestionSelected: (suggestion) {
                            this.typeAheadController.text =
                                suggestion["heading"];
                            if (point != "From" && point != "Destination") {
                              callback(suggestion);
                            } else {
                              callback(point, suggestion);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  double getRightPadding() {
    if (point == "Preferred Activities") {
      return 60;
    }
    return 60;
  }

  IconData _getIcon() {
    if (point == "From") {
      return Icons.flight_takeoff;
    } else if (point == "Destination") {
      return Icons.flight_land;
    } else if (point == "Preferred Activities") {
      return Icons.beach_access;
    }
  }
}

class CustomCheckbox extends StatefulWidget {
  final Function callback;
  final Map value;
  CustomCheckbox({this.callback, this.value});
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
          widget.callback(widget.value, newValue);
        });
        Text('Remember me');
      },
    );
  }
}
