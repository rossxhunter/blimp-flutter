import 'dart:math';

import 'package:blimp/services/suggestions.dart';
import 'package:blimp/styles/colors.dart';
import 'package:blimp/widgets/xlider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class TravellersSelector extends StatelessWidget {
  final int numTravellers;
  final Function callback;
  TravellersSelector({this.numTravellers, this.callback});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Travellers"),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Row(
            children: <Widget>[
              Incrementor(
                symbol: "-",
                callback: callback,
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  numTravellers.toString(),
                  style: Theme.of(context).textTheme.headline2,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Incrementor(
                  symbol: "+",
                  callback: callback,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class Incrementor extends StatelessWidget {
  final String symbol;
  final Function callback;
  Incrementor({this.symbol, this.callback});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        callback(symbol);
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: CustomColors.redGrey,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            symbol,
            style: Theme.of(context).textTheme.headline2.copyWith(
                  color: Theme.of(context).primaryColor,
                ),
          ),
        ),
      ),
    );
  }
}

class DatesSelector extends StatelessWidget {
  final DateTime outboundDate;
  final DateTime returnDate;
  DatesSelector({this.outboundDate, this.returnDate});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Dates"),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: outboundDate != null
              ? Text(
                  DateFormat('d MMM').format(outboundDate) +
                      " - " +
                      DateFormat('d MMM').format(returnDate),
                  style: Theme.of(context).textTheme.headline2,
                )
              : Text(
                  "Select Dates",
                  style: Theme.of(context).textTheme.headline2,
                ),
        ),
      ],
    );
  }
}

class AccommodationTypeSelector extends StatelessWidget {
  final String initialType;
  final Function callback;
  AccommodationTypeSelector({this.initialType, this.callback});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Accommodation Type"),
        Padding(
          padding: EdgeInsets.only(top: 0),
          child: AccommodationTypeDropdown(
            initialType: initialType,
            callback: callback,
          ),
        ),
      ],
    );
  }
}

class AccommodationTypeDropdown extends StatefulWidget {
  final String initialType;
  final Function callback;
  AccommodationTypeDropdown({this.initialType, this.callback});
  @override
  State<StatefulWidget> createState() {
    return AccommodationTypeDropdownState(dropdownValue: initialType);
  }
}

class AccommodationTypeDropdownState extends State<AccommodationTypeDropdown> {
  String dropdownValue;
  AccommodationTypeDropdownState({this.dropdownValue});
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: Icon(Icons.arrow_drop_down),
      elevation: 16,
      style: Theme.of(context).textTheme.bodyText1,
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
          widget.callback(newValue);
        });
      },
      items: <String>["Hotel", "Hostel", "Apartment"]
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

class AccommodationStarsSelector extends StatelessWidget {
  final double initialRating;
  final Function callback;
  AccommodationStarsSelector({this.initialRating, this.callback});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Minimum Stars"),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: RatingBar(
            initialRating: initialRating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            itemSize: 30,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            ratingWidget: RatingWidget(
              full: Icon(
                FontAwesomeIcons.solidStar,
                color: Colors.amber,
              ),
              half: Icon(
                FontAwesomeIcons.solidStarHalf,
                color: Colors.amber,
              ),
              empty: Icon(
                FontAwesomeIcons.star,
                color: Colors.amber,
              ),
            ),
            onRatingUpdate: (rating) {
              callback(rating);
            },
          ),
        ),
      ],
    );
  }
}

class DoubleSlider extends StatefulWidget {
  final Function(double, double) callback;
  final double lowerValue;
  final double upperValue;
  final double min;
  final bool isLogarithmic;
  final double max;
  final double step;
  final double minDistance;
  DoubleSlider(
      {this.callback,
      this.lowerValue,
      this.upperValue,
      this.max,
      this.min,
      this.isLogarithmic,
      this.minDistance,
      this.step});
  @override
  State<StatefulWidget> createState() {
    return DoubleSliderState(
        initialLowerValue: lowerValue,
        initialUpperValue: upperValue,
        maxVal: max,
        minVal: min,
        isLogarithmic: isLogarithmic,
        minDistance: minDistance,
        step: step);
  }
}

class DoubleSliderState extends State<DoubleSlider> {
  final double initialLowerValue;
  final double initialUpperValue;
  final double minVal;
  final double maxVal;
  final bool isLogarithmic;
  double step;
  double minDistance;
  double _lowerValue;
  double _upperValue;
  DoubleSliderState(
      {this.initialLowerValue,
      this.initialUpperValue,
      this.minVal,
      this.maxVal,
      this.step,
      this.minDistance,
      this.isLogarithmic}) {
    _lowerValue = initialLowerValue;
    _upperValue = initialUpperValue;
  }
  @override
  Widget build(BuildContext context) {
    return FlutterSlider(
      values: [_lowerValue, _upperValue],
      rangeSlider: true,
      min: minVal,
      max: maxVal,
      step: FlutterSliderStep(step: step),
      // minimumDistance: minDistance,
      tooltip: FlutterSliderTooltip(disabled: true),
      selectByTap: false,
      trackBar: FlutterSliderTrackBar(
        inactiveTrackBar: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.black12,
          border: Border.all(width: 3, color: Theme.of(context).primaryColor),
        ),
        activeTrackBar: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Theme.of(context).primaryColor.withOpacity(0.5)),
      ),
      handler: FlutterSliderHandler(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            shape: BoxShape.circle,
          ),
        ),
      ),
      rightHandler: FlutterSliderHandler(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            shape: BoxShape.circle,
          ),
        ),
      ),
      onDragStarted: (handlerIndex, lowerValue, upperValue) {
        _lowerValue = lowerValue;
        _upperValue = upperValue;
        // setState(() {});
        widget.callback(_getRealValue(lowerValue), _getRealValue(upperValue));
      },
      onDragCompleted: (handlerIndex, lowerValue, upperValue) {
        _lowerValue = lowerValue;
        _upperValue = upperValue;
        // setState(() {});
        widget.callback(_getRealValue(lowerValue), _getRealValue(upperValue));
      },
      onDragging: (handlerIndex, lowerValue, upperValue) {
        _lowerValue = lowerValue;
        _upperValue = upperValue;
        // setState(() {});
        widget.callback(_getRealValue(lowerValue), _getRealValue(upperValue));
      },
    );
  }

  double _getRealValue(double value) {
    if (isLogarithmic == true) {
      int steps = (maxVal - minVal) ~/ step;
      double scale = (maxVal - minVal) / steps;
      double realValue = exp(minVal + scale * ((value ~/ step) - 119));
      realValue = 50.0 * (realValue / 50).ceil();
      return min(realValue, exp(maxVal));
    }
    return value;
  }
}

class BudgetCurrencySelector extends StatefulWidget {
  final String initialCurrency;
  final Function callback;

  BudgetCurrencySelector({this.callback, this.initialCurrency});

  @override
  State<StatefulWidget> createState() {
    return BudgetCurrencySelectorState(currency: initialCurrency);
  }
}

class BudgetCurrencySelectorState extends State<BudgetCurrencySelector> {
  String currency;
  BudgetCurrencySelectorState({this.currency});
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: currency,
      icon: Icon(Icons.arrow_drop_down),
      elevation: 16,
      style: Theme.of(context).textTheme.bodyText1,
      onChanged: (String newValue) {
        setState(() {
          currency = newValue;
          widget.callback("budgetCurrency", newValue);
        });
      },
      items: suggestions.getCurrencySuggestions().keys.map((v) {
        return DropdownMenuItem<String>(
          value: v,
          child: Text(v),
        );
      }).toList(),
    );
  }
}

class TravelMethodSelector extends StatefulWidget {
  final String method;
  final Function callback;
  final int journey;
  final Key key;
  TravelMethodSelector({this.method, this.callback, this.journey, this.key});
  @override
  State<StatefulWidget> createState() {
    return TravelMethodSelectorState(method: method, key: key);
  }
}

class TravelMethodSelectorState extends State<TravelMethodSelector> {
  String method;
  Key key;
  TravelMethodSelectorState({this.method, this.key});

  IconData _getTravelMethodIcon(String value) {
    if (value == "drive") {
      return Icons.directions_car;
    } else if (value == "walk") {
      return Icons.directions_walk;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: method,
      icon: Icon(Icons.arrow_drop_down),
      underline: Container(
        height: 0,
        width: 0,
      ),
      style: Theme.of(context).textTheme.bodyText1,
      onChanged: (String newValue) {
        // method = newValue;
        widget.callback(widget.journey, newValue);
      },
      items: ["drive", "walk"].map((v) {
        return DropdownMenuItem<String>(
          value: v,
          child: Icon(
            _getTravelMethodIcon(v),
          ),
        );
      }).toList(),
    );
  }
}
