import 'package:blimp/model/preferences.dart';
import 'package:blimp/model/properties.dart';
import 'package:blimp/screens/results.dart';
import 'package:blimp/services/http.dart';
import 'package:blimp/services/suggestions.dart';
import 'package:blimp/styles/colors.dart';
import 'package:blimp/widgets/alerts.dart';
import 'package:blimp/widgets/buttons.dart';
import 'package:blimp/widgets/fields.dart';
import 'package:blimp/widgets/icons.dart';
import 'package:blimp/widgets/loading.dart';
import 'package:blimp/widgets/selectors.dart';
import 'package:blimp/widgets/text_displays.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SearchPageState();
  }
}

const INITIAL_TRIP_TYPE = "Return";
const INITIAL_NUM_TRAVELLERS = 2;
const INITIAL_BUDGET_GEQ = 300;
const INITIAL_BUDGET_LEQ = 600;
const INITIAL_ACCOMMODATION_TYPE = "Hotel";
const INITIAL_ACCOMMODATION_STARS = 3.0;
const INITIAL_BUDGET_CURRENCY = "GBP";
DateTime initialOutboundDate = DateTime.utc(2020, 4, 27);
DateTime initialReturnDate = DateTime.utc(2020, 4, 30);

class SearchPageState extends State<SearchPage> {
  Map searchFields = {
    "tripType": INITIAL_TRIP_TYPE,
    "origin": {},
    "destination": {},
    "travellers": INITIAL_NUM_TRAVELLERS,
    "outboundDate": initialOutboundDate,
    "returnDate": initialReturnDate,
    "accommodationType": INITIAL_ACCOMMODATION_TYPE,
    "accommodationStars": INITIAL_ACCOMMODATION_STARS,
    "accommodationAmenities": [],
    "preferredActivities": [],
    "essentialActivities": [],
    "budgetGEQ": INITIAL_BUDGET_GEQ,
    "budgetLEQ": INITIAL_BUDGET_LEQ,
    "budgetCurrency": INITIAL_BUDGET_CURRENCY,
  };

  //CALLBACK
  void updateSearchFields(String field, var value) {
    setState(() {
      searchFields[field] = value;
    });
    print(searchFields);
  }

  void switchOriginDest() {
    var origin = searchFields["origin"];
    searchFields["origin"] = searchFields["destination"];
    searchFields["destination"] = origin;
    print(searchFields);
  }

  bool searchFieldsValid() {
    if (searchFields["origin"].length == 0) {
      return false;
    }
    return true;
  }

  void searchButtonPressed() {
    if (searchFieldsValid()) {
      showDialog(
        context: context,
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
            "preferred_activities", searchFields["preferredActivities"])
      ];
      PreferenceScores prefScores =
          PreferenceScores(culture: 5, learn: 5, relax: 5);
      Preferences preferences =
          Preferences(constraints, softPreferences, prefScores);

      getHoliday(preferences).then((holiday) {
        print(holiday);
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultsPage(
              name: holiday["name"],
              wiki: holiday["wiki"],
              itinerary: holiday["itinerary"],
              flights: holiday["travel"],
              accommodation: holiday["accommodation"],
            ),
          ),
        );
      }).catchError((e) {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (BuildContext context) => CustomDialog(
            title: "Error",
            description: "Unable to fetch holiday - " + e.toString(),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SafeArea(
          child: Container(
            child: Stack(
              children: <Widget>[
                Padding(
                  padding:
                      EdgeInsets.only(left: 0, right: 0, bottom: 20, top: 20),
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 35, right: 35, top: 0, bottom: 20),
                            child: Column(
                              children: <Widget>[
                                TripType(
                                  callback: updateSearchFields,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 30),
                                  child: OriginDestFields(
                                    callback: updateSearchFields,
                                    switchCallback: switchOriginDest,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 30),
                                  child: TravellersRow(
                                    callback: updateSearchFields,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 30),
                                  child: Dates(
                                    callback: updateSearchFields,
                                  ),
                                ),
                              ],
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
                                padding: EdgeInsets.only(top: 20, bottom: 20),
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
            SearchField(
              point: "Preferred Activities",
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
                        key: Key(activitiesList[index]["heading"]),
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
                                  text: activitiesList[index]["heading"]),
                            ),
                            Flexible(
                              flex: 2,
                              child: CustomCheckbox(
                                value: activitiesList[index],
                                callback: changeCheckboxValue,
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
        BudgetSelector(
          callback: getUpdatedValues,
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
          icon: "Minimum Stars",
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
          icon: "Accommodation Type",
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
  Dates({this.callback});
  @override
  State<StatefulWidget> createState() {
    return DatesState();
  }
}

class DatesState extends State<Dates> {
  DateTime outboundDate = initialOutboundDate;
  DateTime returnDate = initialReturnDate;
  var formatter = new DateFormat('d MMMM');
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final List<DateTime> picked = await DateRagePicker.showDatePicker(
            context: context,
            initialFirstDate: outboundDate,
            initialLastDate: returnDate,
            firstDate: new DateTime(2020),
            lastDate: new DateTime(2021));
        if (picked != null && picked.length == 2) {
          setState(() {
            outboundDate = picked[0];
            returnDate = picked[1];
            widget.callback("outboundDate", outboundDate);
            widget.callback("returnDate", returnDate);
          });
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
              icon: "Dates",
            ),
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: DatesSelector(
                outboundDate: formatter.format(outboundDate),
                returnDate: formatter.format(returnDate),
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
  TravellersRow({this.callback});
  @override
  State<StatefulWidget> createState() {
    return TravellersRowState();
  }
}

class TravellersRowState extends State<TravellersRow> {
  int numTravellers = INITIAL_NUM_TRAVELLERS;

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
          icon: "Travellers",
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
  OriginDestFields({this.callback, this.switchCallback});
  @override
  State<StatefulWidget> createState() {
    return OriginDestFieldsState();
  }
}

class OriginDestFieldsState extends State<OriginDestFields> {
  TextEditingController originController = TextEditingController();
  TextEditingController destinationController = TextEditingController();

  void updateSearchFields(String point, Map value) {
    Map state;
    if (value.length == 0) {
      state = {};
    } else {
      state = {"type": value["type"], "id": value["id"]};
    }
    if (point == "From") {
      widget.callback("origin", state);
    } else if (point == "Destination") {
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
            SearchField(
              point: "From",
              callback: updateSearchFields,
              controller: originController,
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: SearchField(
                point: "Destination",
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
    return GestureDetector(
      onTap: () => callback(),
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(20),
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
