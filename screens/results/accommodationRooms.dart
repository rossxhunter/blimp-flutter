import 'package:blimp/screens/results/accommodation.dart';
import 'package:blimp/services/suggestions.dart';
import 'package:blimp/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:recase/recase.dart';

class AccommodationRooms extends StatefulWidget {
  final List offers;
  final String selectedOption;
  final Function callback;
  AccommodationRooms({this.offers, this.selectedOption, this.callback});
  @override
  State<StatefulWidget> createState() {
    return AccommodationRoomsState(
        offers: offers, selectedOption: selectedOption);
  }
}

class AccommodationRoomsState extends State<AccommodationRooms> {
  List offers;
  String selectedOption;
  AccommodationRoomsState({this.offers, this.selectedOption}) {
    Map itemToMove = offers.firstWhere((o) => o["id"] == selectedOption);
    offers.remove(itemToMove);
    offers.insert(0, itemToMove);
  }

  void roomSelected(String optionId) {
    setState(() {
      selectedOption = optionId;
    });
    widget.callback(offers.firstWhere((o) => o["id"] == optionId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        centerTitle: false,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            FontAwesomeIcons.arrowLeft,
          ),
        ),
        title: Text(
          "Rooms",
          style: Theme.of(context)
              .textTheme
              .headline4
              .copyWith(color: Theme.of(context).primaryColor),
        ),
      ),
      body: Container(
        color: CustomColors.greyBackground,
        child: MediaQuery.removePadding(
          removeBottom: true,
          removeTop: true,
          context: context,
          child: ListView.builder(
            itemCount: offers.length,
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: RoomOption(
                  option: offers[index],
                  isSelected: selectedOption == offers[index]["id"],
                  callback: roomSelected,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class RoomOption extends StatefulWidget {
  final Map option;
  final bool isSelected;
  final Function callback;
  RoomOption({this.isSelected, this.option, this.callback});
  @override
  State<StatefulWidget> createState() {
    return RoomOptionState(option: option, callback: callback);
  }
}

class RoomOptionState extends State<RoomOption> {
  final Map option;
  final Function callback;
  RoomOptionState({this.option, this.callback});

  String _getBeds() {
    if (option["roomType"].containsKey("numBeds") &&
        option["roomType"]["numBeds"] != null) {
      return " (" + option["roomType"]["numBeds"].toString() + " beds)";
    }
    return "";
  }

  String _getEstimatedBedType() {
    if (option["roomType"].containsKey("estimatedBedType") &&
        option["roomType"]["estimatedBedType"] != null) {
      return " (" +
          ReCase(option["roomType"]["estimatedBedType"].toString()).titleCase +
          ")";
    }
    return "";
  }

  IconData _getRoomIcon() {
    if (option["roomType"]["bedType"] == "King") {
      return FontAwesomeIcons.chessKing;
    } else if (option["roomType"]["bedType"] == "Queen") {
      return FontAwesomeIcons.chessQueen;
    } else if (option["roomType"]["bedType"] == "Unknown") {
      return FontAwesomeIcons.dice;
    }
    return FontAwesomeIcons.bed;
  }

  String _formatDescription(String description) {
    String desc = "";
    List<String> lines = description.split("\n");
    for (String line in lines) {
      if (desc != "") {
        desc += "\n";
      }
      desc += ReCase(line.toLowerCase()).sentenceCase;
    }
    return desc;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                      color: CustomColors.lightGrey,
                      borderRadius: BorderRadius.circular(15)),
                  child: Icon(
                    _getRoomIcon(),
                    size: 30,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, top: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ReCase(option["roomType"]["category"] ??
                                    "Standard Room")
                                .titleCase +
                            _getEstimatedBedType(),
                        style: Theme.of(context).textTheme.headline2,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Row(
                          children: [
                            Icon(
                              FontAwesomeIcons.bed,
                              color: Colors.grey,
                              size: 15,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                option["roomType"]["bedType"] + _getBeds(),
                                style: Theme.of(context).textTheme.headline1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Row(
                          children: [
                            Icon(
                              FontAwesomeIcons.utensils,
                              color: Colors.grey,
                              size: 15,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                option["boardType"],
                                style: Theme.of(context).textTheme.headline1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Padding(
            //   padding: EdgeInsets.only(top: 10),
            //   child: Text(
            //     _formatDescription(option["description"]["text"]),
            //     style: Theme.of(context).textTheme.headline1,
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    NumberFormat.currency(
                            name: option["price"]["currency"],
                            symbol: suggestions.getCurrencySuggestions()[
                                option["price"]["currency"]]["symbol"],
                            decimalDigits: 0)
                        .format(option["price"]["amount"]),
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  GestureDetector(
                    onTap: () {
                      callback(option["id"]);
                    },
                    child: SelectedIcon(
                      isSelected: widget.isSelected,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
