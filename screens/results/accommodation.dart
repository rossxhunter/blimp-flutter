import 'package:blimp/screens/results/accommodationDetails.dart';
import 'package:blimp/styles/colors.dart';
import 'package:blimp/widgets/alerts.dart';
import 'package:blimp/widgets/buttons.dart';
import 'package:blimp/widgets/flight_ticket.dart';
import 'package:blimp/widgets/hotel_option.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class AccommodationScreen extends StatefulWidget {
  final List allAccommodation;
  final String selectedAccommodation;
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
  String selectedAccommodation;
  final Function callback;
  List shownAccommodation;

  AccommodationScreenState(
      {this.allAccommodation, this.selectedAccommodation, this.callback}) {
    shownAccommodation = List.from(allAccommodation);
    shownAccommodation
        .removeWhere((a) => a["hotelId"] == selectedAccommodation);
    shownAccommodation.insert(
        0,
        allAccommodation
            .where((a) => a["hotelId"] == selectedAccommodation)
            .toList()[0]);
  }

  void updateOffer(int index, Map newOffer) {
    setState(() {
      shownAccommodation[index]["selectedOffer"] = newOffer;
    });
  }

  void updateState(String hotelId) {
    setState(() {
      selectedAccommodation = hotelId;
    });
  }

  @override
  Widget build(BuildContext context) {
    ItemScrollController _scrollController = ItemScrollController();
    return Scaffold(
      backgroundColor: Colors.white,
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
              color: CustomColors.greyBackground,
              child: ScrollablePositionedList.builder(
                itemScrollController: _scrollController,
                itemCount: allAccommodation.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Container(
                      color: Colors.white,
                      child: Stack(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                top: 10, left: 10, right: 10, bottom: 10),
                            child: Column(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                        type: PageTransitionType.downToUp,
                                        child: AccommodationDetails(
                                          details: shownAccommodation[index],
                                          index: index,
                                          callback: updateOffer,
                                        ),
                                      ),
                                    );
                                  },
                                  child: HotelOption(
                                    key: Key(
                                        shownAccommodation[index]["hotelId"]),
                                    hotelDetails: shownAccommodation[index],
                                    isSelected: selectedAccommodation ==
                                        shownAccommodation[index]["hotelId"],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: GestureDetector(
                              key: ValueKey(
                                shownAccommodation[index]["hotelId"].toString(),
                              ),
                              onTap: () {
                                setState(() {
                                  selectedAccommodation =
                                      shownAccommodation[index]["hotelId"];
                                });

                                _scrollController.scrollTo(
                                    index: index,
                                    duration: Duration(milliseconds: 500));
                              },
                              child: SelectedIcon(
                                  key: ValueKey(
                                    shownAccommodation[index]["hotelId"]
                                        .toString(),
                                  ),
                                  isSelected: selectedAccommodation ==
                                      shownAccommodation[index]["hotelId"]),
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
  final bool isSelected;
  SelectedIcon({this.isSelected, ValueKey<String> key});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected
            ? Theme.of(context).primaryColor
            : CustomColors.lightGrey,
        borderRadius: BorderRadius.circular(300),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Icon(
          Icons.check,
          color: isSelected ? Colors.white : Colors.grey,
        ),
      ),
    );
  }
}
