import 'package:blimp/styles/colors.dart';
import 'package:blimp/widgets/alerts.dart';
import 'package:blimp/widgets/buttons.dart';
import 'package:blimp/widgets/flight_ticket.dart';
import 'package:blimp/widgets/hotel_option.dart';
import 'package:flutter/material.dart';

class AccommodationScreen extends StatefulWidget {
  final List allAccommodation;
  final int selectedAccommodation;
  final Function callback;

  AccommodationScreen(
      {this.allAccommodation, this.selectedAccommodation, this.callback});
  @override
  State<StatefulWidget> createState() {
    return AccommodationScreenState(
        allAccommodation: allAccommodation,
        selectedAccommodation: selectedAccommodation,
        callback: callback);
  }
}

class AccommodationScreenState extends State<AccommodationScreen> {
  final List allAccommodation;
  int selectedAccommodation;
  final Function callback;
  List shownAccommodation;
  int _selectedAccommodation = 0;

  AccommodationScreenState(
      {this.allAccommodation, this.selectedAccommodation, this.callback}) {
    shownAccommodation = List.from(allAccommodation);
    shownAccommodation.removeWhere((a) => a["id"] == selectedAccommodation);
    shownAccommodation.insert(
        0,
        allAccommodation
            .where((a) => a["id"] == selectedAccommodation)
            .toList()[0]);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        shape: ContinuousRectangleBorder(
          side: BorderSide(
            color: CustomColors.lightGrey,
            width: 4,
          ),
        ),
        title: Column(
          children: [
            Text(
              'Accommodation',
              style: Theme.of(context).textTheme.headline3,
            ),
            Padding(
              padding: EdgeInsets.only(top: 5, bottom: 5),
              child: Text(
                shownAccommodation.length.toString() + " options",
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
          ],
        ),
        leading: Padding(
          padding: EdgeInsets.only(left: 10),
          child: IconButton(
            icon: Icon(Icons.close),
            color: Theme.of(context).primaryColor,
            iconSize: 30,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        // actions: <Widget>[
        //   Padding(
        //     padding: EdgeInsets.only(right: 10),
        //     child: IconButton(
        //       icon: Icon(Icons.sort),
        //       color: Theme.of(context).primaryColor,
        //       iconSize: 30,
        //       onPressed: () {},
        //     ),
        //   ),
        // ],
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 80),
            child: Container(
              color: Colors.white,
              child: ListView.builder(
                itemCount: allAccommodation.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Container(
                      color: Colors.white,
                      child: Stack(
                        children: <Widget>[
                          AnimatedButton(
                            callback: () {
                              setState(() {
                                _selectedAccommodation = index;
                                selectedAccommodation =
                                    shownAccommodation[index]["id"];
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 20, left: 20, right: 20, bottom: 20),
                              child: Column(
                                children: <Widget>[
                                  HotelOption(
                                    hotelDetails: shownAccommodation[index],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: Visibility(
                              visible: selectedAccommodation ==
                                  shownAccommodation[index]["id"],
                              child: SelectedIcon(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned.fill(
            top: null,
            bottom: 0,
            child: Container(
              color: Colors.transparent,
              child: Padding(
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 30),
                child: AnimatedButton(
                  callback: () {
                    callback(selectedAccommodation);
                    Navigator.pop(context);
                    showSuccessToast(context, "Accommodation Changed");
                  },
                  child: ConfirmButton(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SelectedIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(300),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Icon(
          Icons.check,
          color: Colors.white,
        ),
      ),
    );
  }
}