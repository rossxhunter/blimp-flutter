import 'package:auto_size_text/auto_size_text.dart';
import 'package:blimp/services/http.dart';
import 'package:blimp/services/user.dart';
import 'package:blimp/styles/colors.dart';
import 'package:blimp/widgets/alerts.dart';
import 'package:blimp/widgets/buttons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class TripsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TripsPageState();
  }
}

class TripsPageState extends State<TripsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Trips",
          style: Theme.of(context)
              .textTheme
              .headline3
              .copyWith(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SingleChildScrollView(
            // physics: AlwaysScrollableScrollPhysics(),
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 0,
                  right: 0,
                ),
                child: TripsSection(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TripsSection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TripsSectionState();
  }
}

class TripsSectionState extends State<TripsSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 30),
          child: Container(
            width: double.infinity,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 30,
                    // bottom: 30,
                  ),
                  child: Text(
                      currentUser["trips"]["saved"].length == 0
                          ? "No Saved Trips"
                          : "Saved Trips",
                      style: Theme.of(context).textTheme.headline3),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: currentUser["trips"]["saved"].length == 0
                      ? Container(
                          height: 0,
                          width: 0,
                        )
                      : Container(
                          height: 300,
                          child: ListView.builder(
                            itemCount: currentUser["trips"]["saved"].length,
                            scrollDirection: Axis.horizontal,
                            physics: AlwaysScrollableScrollPhysics(),
                            itemBuilder: (BuildContext itemContext, int index) {
                              bool savedSelected = true;
                              return Stack(
                                children: [
                                  TripOption(
                                    trip: currentUser["trips"]["saved"][index],
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: AnimatedButton(
                                      callback: () async {
                                        currentUser["trips"]["saved"] =
                                            await deleteHoliday(
                                                currentUser["id"],
                                                currentUser["trips"]["saved"]
                                                    [index]["id"],
                                                "saved");
                                        setState(() {
                                          savedSelected = false;
                                        });
                                        showSuccessToast(context,
                                            "Removed from Saved Trips");
                                      },
                                      child: SaveTripButton(
                                        selected: savedSelected,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 30),
          child: Container(
            width: double.infinity,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 0,
                    // bottom: 30,
                  ),
                  child: Text(
                      currentUser["trips"]["upcoming"].length == 0
                          ? "No Upcoming Trips"
                          : "Upcoming Trips",
                      style: Theme.of(context).textTheme.headline3),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: currentUser["trips"]["upcoming"].length == 0
                      ? Container(
                          height: 0,
                          width: 0,
                        )
                      : Container(
                          height: 300,
                          child: ListView.builder(
                            itemCount: currentUser["trips"]["upcoming"].length,
                            scrollDirection: Axis.horizontal,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return TripOption();
                            },
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
        Container(
          width: double.infinity,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 0,
                  // bottom: 30,
                ),
                child: Text(
                    currentUser["trips"]["past"].length == 0
                        ? "No Past Trips"
                        : "Past Trips",
                    style: Theme.of(context).textTheme.headline3),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: currentUser["trips"]["past"].length == 0
                    ? Container(
                        height: 0,
                        width: 0,
                      )
                    : Container(
                        height: 300,
                        child: ListView.builder(
                          itemCount: currentUser["trips"]["past"].length,
                          scrollDirection: Axis.horizontal,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return TripOption();
                          },
                        ),
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SaveTripButton extends StatelessWidget {
  final bool selected;
  SaveTripButton({this.selected});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: CustomColors.lightGrey,
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Icon(
          selected ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,
          size: 20,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}

class TripOption extends StatelessWidget {
  final Map trip;
  TripOption({this.trip});
  @override
  Widget build(BuildContext context) {
    var parser = EmojiParser();
    return Padding(
      padding: EdgeInsets.only(left: 20, bottom: 20),
      child: Container(
        width: 240,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              blurRadius: 10.0,
              offset: Offset(0, 5),
            )
          ],
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                // width: 170,
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CachedNetworkImage(
                    imageUrl: trip["photo"],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      trip["name"] +
                          " " +
                          parser
                              .get("flag-" + trip["countryCode"].toLowerCase())
                              .code,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: Colors.grey,
                            size: 20,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              DateFormat("d MMM").format(
                                    DateTime.parse(trip["departureDate"]),
                                  ) +
                                  " - " +
                                  DateFormat("d MMM").format(
                                    DateTime.parse(trip["returnDate"]),
                                  ),
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
        ),
      ),
    );
  }
}
