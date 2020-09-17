import 'dart:math';

import 'package:blimp/model/preferences.dart';
import 'package:blimp/model/properties.dart';
import 'package:blimp/routes.dart';
import 'package:blimp/screens/results/results.dart';
import 'package:blimp/services/http.dart';
import 'package:blimp/services/suggestions.dart';
import 'package:blimp/services/util.dart';
import 'package:blimp/styles/colors.dart';
import 'package:blimp/widgets/alerts.dart';
import 'package:blimp/widgets/buttons.dart';
import 'package:blimp/widgets/fields.dart';
import 'package:blimp/widgets/icons.dart';
import 'package:blimp/widgets/loading.dart';
import 'package:blimp/widgets/selectors.dart';
import 'package:blimp/widgets/text_displays.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:blimp/widgets/date_range_picker.dart' as DateRangePicker;

class SearchPage extends StatefulWidget {
  final Preferences preferences;
  SearchPage({this.preferences});
  @override
  State<StatefulWidget> createState() {
    return SearchPageState(preferences: preferences);
  }
}

const INITIAL_TRIP_TYPE = "Return";
const INITIAL_NUM_TRAVELLERS = 2;
const INITIAL_BUDGET_GEQ = 300;
const INITIAL_BUDGET_LEQ = 600;
const INITIAL_ACCOMMODATION_TYPE = "Hotel";
const INITIAL_ACCOMMODATION_STARS = 3.0;
const INITIAL_BUDGET_CURRENCY = "GBP";
DateTime initialOutboundDate = DateTime.now();
DateTime initialReturnDate = DateTime.now().add(Duration(days: 1));

class SearchPageState extends State<SearchPage> {
  Preferences preferences;
  Map searchFields;
  List<Map<String, DateTime>> validDates = [];
  int originId;
  int destId;
  bool blankDates = true;

  SearchPageState({this.preferences}) {
    searchFields = {
      "tripType": preferences != null
          ? preferences.constraints
              .firstWhere(
                (c) => c.property == "trip_type",
              )
              .value
          : INITIAL_TRIP_TYPE,
      "origin": preferences != null
          ? preferences.constraints
              .firstWhere((c) => c.property == "origin")
              .value
          : {},
      "destination": preferences != null
          ? preferences.constraints
              .firstWhere((c) => c.property == "destination")
              .value
          : {},
      "travellers": INITIAL_NUM_TRAVELLERS,
      "outboundDate": preferences != null
          ? preferences.constraints
              .firstWhere((c) => c.property == "departure_date")
          : null,
      "returnDate": preferences != null
          ? preferences.constraints
              .firstWhere((c) => c.property == "return_date")
          : null,
      "accommodationType": INITIAL_ACCOMMODATION_TYPE,
      "accommodationStars": INITIAL_ACCOMMODATION_STARS,
      "accommodationAmenities": [],
      "preferredActivities": [],
      "essentialActivities": [],
      "budgetGEQ": INITIAL_BUDGET_GEQ,
      "budgetLEQ": INITIAL_BUDGET_LEQ,
      "budgetCurrency": INITIAL_BUDGET_CURRENCY,
      "preferenceScores": PreferenceScores(
        culture: 3,
        active: 3,
        nature: 3,
        shopping: 3,
        food: 3,
        nightlife: 3,
      ),
    };
  }

  //CALLBACK
  void updateSearchFields(String field, var value) {
    setState(() {
      blankDates = true;
      searchFields[field] = value;
      if (field == "origin") {
        originId = value["originId"];
        updateValidDates();
      } else if (field == "destination") {
        destId = value["destId"];
        updateValidDates();
      } else {
        blankDates = false;
      }
    });
    print(searchFields);
  }

  void switchOriginDest() {
    var origin = searchFields["origin"];
    searchFields["origin"] = searchFields["destination"];
    searchFields["destination"] = origin;
    updateValidDates();
    print(searchFields);
  }

  void updateValidDates() {
    setState(() {
      validDates = [];
      List availableFlights = getAvailableFlights();
      for (Map flight in availableFlights) {
        if ((originId == null || originId == flight["origin"]) &&
            (destId == null || destId == flight["destination"])) {
          validDates.add({
            "departureDate": DateTime.parse(flight["departureDate"]),
            "returnDate": DateTime.parse(flight["returnDate"])
          });
        }
      }
    });
  }

  bool searchFieldsValid() {
    if (searchFields["origin"]["originId"] == null ||
        searchFields["destination"]["destId"] == null ||
        searchFields["outboundDate"] == null ||
        searchFields["returnDate"] == null) {
      return false;
    }
    return true;
  }

  void searchButtonPressed() {
    if (searchFieldsValid()) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return LoadingIndicator();
        },
      );
      var formatter = DateFormat('yyyy-MM-dd');
      List<Constraint> constraints = [
        Constraint("trip_type", searchFields["tripType"]),
        Constraint("origin", searchFields["origin"]),
        Constraint(
            "travellers", Travellers(adults: searchFields["travellers"])),
        Constraint("budget_leq", searchFields["budgetLEQ"]),
        Constraint("budget_geq", searchFields["budgetGEQ"]),
        Constraint(
            "departure_date", formatter.format(searchFields["outboundDate"])),
        Constraint("return_date", formatter.format(searchFields["returnDate"])),
        Constraint("accommodation_type", searchFields["accommodationType"]),
        Constraint(
            "accommodation_stars", searchFields["accommodationStars"].round()),
        Constraint("essential_activities", searchFields["essentialActivities"]),
        Constraint("budget_currency", searchFields["budgetCurrency"]),
        Constraint(
            "accommodation_amenities", searchFields["accommodationAmenities"])
      ];
      if (searchFields["destination"].length > 0) {
        constraints.add(Constraint("destination", searchFields["destination"]));
      }
      List<SoftPreference> softPreferences = [
        SoftPreference(
            "preferred_activities",
            searchFields["preferredActivities"] +
                searchFields["essentialActivities"])
      ];
      PreferenceScores prefScores = searchFields["preferenceScores"];
      Preferences preferences =
          Preferences(constraints, softPreferences, prefScores);

      getHoliday(preferences).then((holiday) {
        print(holiday);
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultsPageRoute(holiday, preferences).page(),
          ),
        );
      }).catchError((e) {
        Navigator.pop(context);
        showErrorToast(context, "Unable to fetch holiday - " + e.toString());
      });
    }
  }

  @override
  void initState() {
    List availableFlights = getAvailableFlights();
    for (Map flight in availableFlights) {
      validDates.add({
        "departureDate": DateTime.parse(flight["departureDate"]),
        "returnDate": DateTime.parse(flight["returnDate"])
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      left: true,
      top: false,
      right: true,
      bottom: true,
      child: Scaffold(
        backgroundColor: Colors.white,
        // appBar: AppBar(
        //   backgroundColor: Theme.of(context).primaryColor,
        //   title: Text(
        //     "Design your Dream Trip",
        //     style: Theme.of(context)
        //         .textTheme
        //         .headline4
        //         .copyWith(color: Colors.white),
        //   ),
        // ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Container(
            child: Stack(
              children: <Widget>[
                Padding(
                  padding:
                      EdgeInsets.only(left: 0, right: 0, bottom: 0, top: 0),
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 0, right: 0, top: 0),
                          child: Container(
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 35, right: 35, top: 0, bottom: 20),
                              child: Column(
                                children: <Widget>[
                                  // TripType(
                                  //   callback: updateSearchFields,
                                  // ),
                                  SearchTitle(),
                                  Padding(
                                    padding: EdgeInsets.only(top: 30),
                                    child: OriginDestFields(
                                      callback: updateSearchFields,
                                      switchCallback: switchOriginDest,
                                      origin: searchFields["origin"],
                                      destination: searchFields["destination"],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 30),
                                    child: TravellersRow(
                                      numTravellers: searchFields["travellers"],
                                      callback: updateSearchFields,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 30),
                                    child: Dates(
                                      validDates: validDates,
                                      blankDates: blankDates,
                                      callback: updateSearchFields,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          color: CustomColors.greyBackground,
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: 20),
                                child: Container(
                                  color: Colors.white,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 35,
                                        right: 35,
                                        top: 20,
                                        bottom: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(top: 20),
                                          child: SearchSectionTitle(
                                            title: "Accommodation",
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 30),
                                          child: AccommodationType(
                                            callback: updateSearchFields,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 30),
                                          child: AccommodationStars(
                                            callback: updateSearchFields,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 20),
                                child: Container(
                                  color: Colors.white,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 35,
                                        right: 35,
                                        top: 10,
                                        bottom: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(top: 30),
                                          child: SearchSectionTitle(
                                            title: "Activities",
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 30),
                                          child: Activities(
                                            callback: updateSearchFields,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 20),
                                child: Container(
                                  color: Colors.white,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 35,
                                        right: 35,
                                        top: 10,
                                        bottom: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(top: 30),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              SearchSectionTitle(
                                                title: "Budget",
                                              ),
                                              BudgetCurrencySelector(
                                                callback: updateSearchFields,
                                                initialCurrency:
                                                    INITIAL_BUDGET_CURRENCY,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 30),
                                          child: Budget(
                                            callback: updateSearchFields,
                                            currency:
                                                searchFields["budgetCurrency"],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 20, bottom: 20),
                                child: Container(
                                  color: Colors.white,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 35,
                                        right: 35,
                                        top: 10,
                                        bottom: 20),
                                    child: Stack(
                                      // crossAxisAlignment:
                                      //     CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(top: 30),
                                          child: SearchSectionTitle(
                                            title: "Preferences",
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 25),
                                          child: PreferenceScoresSection(
                                              callback: updateSearchFields,
                                              initialPrefScores: searchFields[
                                                  "preferenceScores"]),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 60,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned.fill(
                  top: null,
                  bottom: 0,
                  child: Container(
                    color: Colors.transparent,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                      child: SearchButton(callback: searchButtonPressed),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SearchTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            // decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: Padding(
              padding: EdgeInsets.only(left: 0, top: 70, right: 30, bottom: 0),
              child: Text(
                "Design your trip",
                // textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    .copyWith(color: Theme.of(context).primaryColor),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class PreferenceScoresSection extends StatefulWidget {
  final Function callback;
  final PreferenceScores initialPrefScores;
  PreferenceScoresSection({this.callback, this.initialPrefScores});
  @override
  State<StatefulWidget> createState() {
    return PreferenceScoresSectionState(
        callback: callback, initialPrefScores: initialPrefScores);
  }
}

class PreferenceScoresSectionState extends State<PreferenceScoresSection> {
  final Function callback;
  final PreferenceScores initialPrefScores;
  Map prefScores;
  PreferenceScoresSectionState({this.callback, this.initialPrefScores}) {
    prefScores = {
      "culture": {
        "score": initialPrefScores.culture.toDouble(),
        "title": "Cultural",
        "icon": Icons.location_city
      },
      "active": {
        "score": initialPrefScores.active.toDouble(),
        "title": "Active",
        "icon": Icons.directions_run
      },
      "nature": {
        "score": initialPrefScores.nature.toDouble(),
        "title": "Nature",
        "icon": Icons.nature
      },
      "shopping": {
        "score": initialPrefScores.shopping.toDouble(),
        "title": "Shopping",
        "icon": Icons.shopping_basket
      },
      "food": {
        "score": initialPrefScores.food.toDouble(),
        "title": "Foody",
        "icon": Icons.restaurant
      },
      "nightlife": {
        "score": initialPrefScores.nightlife.toDouble(),
        "title": "Nightlife",
        "icon": Icons.local_bar
      },
    };
  }
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: SearchSectionTitle(
        title: "",
      ),
      children: [
        ListView.builder(
          itemCount: prefScores.keys.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            String pref = prefScores.keys.toList()[index];
            return Padding(
              padding: EdgeInsets.only(top: 10),
              child: Row(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  IconBox(icon: prefScores[pref]["icon"]),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            prefScores[pref]["title"],
                            style: Theme.of(context).textTheme.headline2,
                            textAlign: TextAlign.center,
                          ),
                          CupertinoSlider(
                            value: prefScores[pref]["score"],
                            min: 1.0,
                            max: 5.0,
                            activeColor: Theme.of(context).primaryColor,
                            onChanged: (value) {
                              setState(() {
                                prefScores[pref]["score"] = value;
                                PreferenceScores newPrefScores =
                                    PreferenceScores(
                                  culture:
                                      prefScores["culture"]["score"].toInt(),
                                  active: prefScores["active"]["score"].toInt(),
                                  nightlife:
                                      prefScores["nightlife"]["score"].toInt(),
                                );
                                callback("preferenceScores", newPrefScores);
                              });
                            },
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
      ],
    );
  }
}

class Activities extends StatefulWidget {
  final Function(String, dynamic) callback;
  Activities({this.callback});
  @override
  State<StatefulWidget> createState() {
    return ActivitiesState();
  }
}

class ActivitiesState extends State<Activities> {
  Map<Map, bool> activities = {};
  TextEditingController _controller = TextEditingController();

  ActivitiesState();
  Map newActivity = {};

  void addNewActivity() {
    setState(() {
      if (newActivity.length > 0) {
        activities[newActivity] = false;
      }
      newActivity = {};
      _controller.text = "";
      callCallback();
    });
  }

  void typeNewActivity(Map activity) {
    newActivity = activity;
  }

  void changeCheckboxValue(Map activity, bool value) {
    activities[activity] = value;
    callCallback();
  }

  void callCallback() {
    List preferredActivities = activities.keys
        .where((a) => activities[a] == false)
        .map((a) => a["id"])
        .toList();
    List essentialActivities = activities.keys
        .where((a) => activities[a] == true)
        .map((a) => a["id"])
        .toList();
    widget.callback("preferredActivities", preferredActivities);
    widget.callback("essentialActivities", essentialActivities);
  }

  @override
  Widget build(BuildContext context) {
    List<Map> activitiesList = activities.entries.map((e) => e.key).toList();
    return Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            ActivitiesField(
              callback: typeNewActivity,
              controller: _controller,
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: AddButton(
                    callback: addNewActivity,
                  ),
                ),
              ),
            ),
          ],
        ),
        Visibility(
          visible: activities.length > 0,
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: Column(
              children: <Widget>[
                Padding(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Activity",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Text(
                        "Essential?",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return Padding(
                      padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                      child: Dismissible(
                        direction: DismissDirection.endToStart,
                        background: Container(color: Colors.red),
                        key: Key(activitiesList[index]["name"]),
                        onDismissed: (direction) {
                          // Scaffold.of(context).showSnackBar(SnackBar(
                          //     content: Text("${activities[index]} removed")));
                          setState(() {
                            activities.remove(activitiesList[index]);
                            callCallback();
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                              flex: 4,
                              child: ActivityText(
                                  text: activitiesList[index]["name"]),
                            ),
                            Flexible(
                              flex: 2,
                              child: CustomCheckbox(
                                callback: (value) => changeCheckboxValue(
                                    activitiesList[index], value),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: activities.length,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class Budget extends StatefulWidget {
  final Function callback;
  final String currency;
  Budget({this.callback, this.currency});
  @override
  State<StatefulWidget> createState() {
    return BudgetState();
  }
}

class BudgetState extends State<Budget> {
  double _lowerValue = 300;
  double _upperValue = 600;

  void getUpdatedValues(double lower, double upper) {
    setState(() {
      _lowerValue = lower;
      _upperValue = upper;
      widget.callback("budgetGEQ", lower);
      widget.callback("budgetLEQ", upper);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        DoubleSlider(
          callback: getUpdatedValues,
          isLogarithmic: true,
          min: log(150),
          max: log(10000),
          step: (log(10000) - log(150)) / 100,
          minDistance: log(150),
          lowerValue: log(300),
          upperValue: log(600),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            NumberFormat.currency(
                        name: widget.currency,
                        symbol: getCurrencySuggestions()[widget.currency]
                            ["symbol"])
                    .format(_lowerValue) +
                " - " +
                NumberFormat.currency(
                        name: widget.currency,
                        symbol: getCurrencySuggestions()[widget.currency]
                            ["symbol"])
                    .format(_upperValue),
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
      ],
    );
  }
}

class AccommodationStars extends StatelessWidget {
  final Function callback;
  AccommodationStars({this.callback});

  void updateState(double stars) {
    callback("accommodationStars", stars);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconBox(
          icon: Icons.star,
        ),
        Padding(
          padding: EdgeInsets.only(left: 20),
          child: AccommodationStarsSelector(
              initialRating: INITIAL_ACCOMMODATION_STARS,
              callback: updateState),
        ),
      ],
    );
  }
}

class AccommodationType extends StatelessWidget {
  final Function callback;
  AccommodationType({this.callback});

  void updateState(String type) {
    callback("accommodationType", type);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconBox(
          icon: Icons.hotel,
        ),
        Padding(
          padding: EdgeInsets.only(left: 20),
          child: AccommodationTypeSelector(
            initialType: INITIAL_ACCOMMODATION_TYPE,
            callback: updateState,
          ),
        ),
      ],
    );
  }
}

class SearchSectionTitle extends StatelessWidget {
  final String title;
  SearchSectionTitle({this.title});
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headline4,
    );
  }
}

class Dates extends StatefulWidget {
  final Function callback;
  final List<Map<String, DateTime>> validDates;
  final bool blankDates;
  Dates({this.callback, this.validDates, this.blankDates}) {
    createState();
  }
  @override
  State<StatefulWidget> createState() {
    return DatesState();
  }
}

class DatesState extends State<Dates> {
  DateTime outboundDate;
  DateTime returnDate;
  bool isValid;
  // @override
  // void initState() {
  //   outboundDate = widget.validDates[0]["departureDate"];
  //   returnDate = widget.validDates[0]["returnDate"];
  //   super.initState();
  // }

  var formatter = new DateFormat('d MMMM');
  @override
  Widget build(BuildContext context) {
    if (widget.validDates.length == 0) {
      isValid = false;
    } else {
      isValid = true;
    }
    if (widget.blankDates) {
      outboundDate = null;
      returnDate = null;
    }
    return GestureDetector(
      onTap: () async {
        if (isValid) {
          final List<DateTime> picked = await DateRangePicker.showDatePicker(
            context: context,
            initialFirstDate:
                outboundDate ?? widget.validDates[0]["departureDate"],
            initialLastDate: returnDate ?? widget.validDates[0]["returnDate"],
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(Duration(days: 90)),
            selectableDayPredicate: (day, firstDay, lastDay) {
              if (firstDay == null) {
                return isDateAllowed(
                    day,
                    widget.validDates
                        .map((vd) => vd["departureDate"])
                        .toList());
              } else if (lastDay == null) {
                return isDateAllowed(
                    day,
                    widget.validDates
                        .where((vd) =>
                            areDatesEqual(vd["departureDate"], firstDay))
                        .map((vd) => vd["returnDate"])
                        .toList());
              } else {
                return isDateAllowed(
                    day,
                    widget.validDates
                        .map((vd) => vd["departureDate"])
                        .toList());
              }
            },
          );
          if (picked != null && picked.length == 2) {
            setState(() {
              outboundDate = picked[0];
              returnDate = picked[1];
              widget.callback("outboundDate", outboundDate);
              widget.callback("returnDate", returnDate);
            });
          }
        }
      },
      child: Container(
        decoration: BoxDecoration(
          // color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: <Widget>[
            IconBox(
              icon: Icons.calendar_today,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: DatesSelector(
                outboundDate: outboundDate,
                returnDate: returnDate,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TravellersRow extends StatefulWidget {
  final Function callback;
  final int numTravellers;
  TravellersRow({this.callback, this.numTravellers});
  @override
  State<StatefulWidget> createState() {
    return TravellersRowState(numTravellers: numTravellers);
  }
}

class TravellersRowState extends State<TravellersRow> {
  int numTravellers;

  TravellersRowState({this.numTravellers});

  void updateNumTravellers(String direction) {
    if (direction == "+") {
      if (numTravellers < 10) {
        setState(() {
          numTravellers += 1;
        });
      }
    } else if (direction == "-") {
      if (numTravellers > 1) {
        setState(() {
          numTravellers -= 1;
        });
      }
    }
    widget.callback("travellers", numTravellers);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconBox(
          icon: Icons.people,
        ),
        Padding(
          padding: EdgeInsets.only(left: 20),
          child: TravellersSelector(
            numTravellers: numTravellers,
            callback: updateNumTravellers,
          ),
        ),
      ],
    );
  }
}

class OriginDestFields extends StatefulWidget {
  final Function callback;
  final Function switchCallback;
  final Map origin;
  final Map destination;
  OriginDestFields(
      {this.callback, this.switchCallback, this.origin, this.destination});
  @override
  State<StatefulWidget> createState() {
    return OriginDestFieldsState(origin: origin, destination: destination);
  }
}

class OriginDestFieldsState extends State<OriginDestFields> {
  TextEditingController originController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  Map origin;
  Map destination;
  int originId;
  int destId;

  OriginDestFieldsState({this.origin, this.destination}) {
    if (origin.keys.length != 0) {
      Map o = getDestinationSuggestions().firstWhere(
          (s) => s["id"] == origin["id"] && s["type"] == origin["type"]);

      if (o["type"] == "airport") {
        originController.text = o["airportName"];
      } else {
        originController.text = o["cityName"];
      }
    }
    if (destination.keys.length != 0) {
      Map d = getDestinationSuggestions().firstWhere((s) =>
          s["id"] == destination["id"] && s["type"] == destination["type"]);
      if (d["type"] == "airport") {
        destinationController.text = d["airportName"];
      } else {
        destinationController.text = d["cityName"];
      }
    }
  }

  void updateSearchFields(String point, Map value) {
    Map state;
    if (value.length == 0) {
      state = {};
    } else {
      state = {"type": value["type"], "id": value["id"]};
    }
    if (point == "From") {
      setState(() {
        if (value["type"] == "airport") {
          originId = value["cityId"];
        } else {
          originId = value["id"];
        }
        state["originId"] = originId;
      });
      widget.callback("origin", state);
    } else if (point == "Destination") {
      setState(() {
        if (value["type"] == "airport") {
          destId = value["cityId"];
        } else {
          destId = value["id"];
        }
        state["destId"] = destId;
      });
      widget.callback("destination", state);
    }
  }

  void switchFields() {
    setState(() {
      String originText = originController.text;
      originController.text = destinationController.text;
      destinationController.text = originText;
      widget.switchCallback();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            Row(
              children: [
                // IconBox(
                //   icon: Icons.flight_takeoff,
                // ),
                Expanded(
                  child: OriginDestinationField(
                    point: "From",
                    destId: destId,
                    callback: updateSearchFields,
                    controller: originController,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: OriginDestinationField(
                point: "Destination",
                originId: originId,
                callback: updateSearchFields,
                controller: destinationController,
              ),
            ),
          ],
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(right: 20),
              child: SwitchButton(callback: switchFields),
            ),
          ),
        ),
      ],
    );
  }
}

class TripType extends StatefulWidget {
  final Function callback;
  TripType({this.callback});
  @override
  State<StatefulWidget> createState() {
    return TripTypeState();
  }
}

class TripTypeState extends State<TripType> {
  int activeOption = 1;

  void updateStates(int newActive) {
    setState(() {
      activeOption = newActive;
      widget.callback("tripType", options[newActive]);
    });
  }

  List<String> options = ["One Way", "Return", "Multi Trip"];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        CircularCheckbox(
          text: options[0],
          optionIndex: 0,
          activeOption: activeOption,
          onChanged: updateStates,
        ),
        CircularCheckbox(
          text: options[1],
          optionIndex: 1,
          activeOption: activeOption,
          onChanged: updateStates,
        ),
        CircularCheckbox(
          text: options[2],
          optionIndex: 2,
          activeOption: activeOption,
          onChanged: updateStates,
        ),
      ],
    );
  }
}

class SearchButton extends StatelessWidget {
  final Function callback;
  SearchButton({this.callback});
  @override
  Widget build(BuildContext context) {
    return AnimatedButton(
      callback: () => callback(),
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(20),
          // boxShadow: [
          //   BoxShadow(
          //     color: Color.fromRGBO(
          //         (Theme.of(context).primaryColor.red * 0.8).round(),
          //         (Theme.of(context).primaryColor.green * 0.8).round(),
          //         (Theme.of(context).primaryColor.blue * 0.8).round(),
          //         1),
          //     blurRadius: 0.0,
          //     spreadRadius: 0,
          //     offset: Offset(0, 5),
          //   )
          // ],
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(0.2),
              blurRadius: 10.0,
              offset: Offset(0, 10),
            )
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Text(
              "SEARCH",
              style: Theme.of(context)
                  .textTheme
                  .button
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}
