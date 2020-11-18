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
import 'package:toggle_switch/toggle_switch.dart';

class TripsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TripsPageState();
  }
}

class TripsPageState extends State<TripsPage> {
  int currentTripIndex;

  List<String> tripTypes = ["Saved", "Upcoming", "Past"];

  @override
  void initState() {
    currentTripIndex = 0;
    super.initState();
  }

  void updateState(int index) {
    currentTripIndex = index;
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
            color: Theme.of(context).primaryColor,
          ),
        ),
        title: Text(
          "Trips",
          style: Theme.of(context)
              .textTheme
              .headline4
              .copyWith(color: Theme.of(context).primaryColor),
        ),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Padding(
            padding: EdgeInsets.only(top: 20),
            child: Column(
              children: [
                ToggleSwitch(
                  minWidth: 300.0,
                  cornerRadius: 20.0,
                  activeBgColor: Theme.of(context).primaryColor,
                  activeFgColor: Colors.white,
                  inactiveBgColor: CustomColors.lightGrey,
                  inactiveFgColor: Colors.grey,
                  labels: tripTypes,
                  initialLabelIndex: currentTripIndex,
                  icons: [
                    FontAwesomeIcons.heart,
                    FontAwesomeIcons.ticketAlt,
                    FontAwesomeIcons.solidClock
                  ],
                  onToggle: (index) {
                    setState(() {
                      currentTripIndex = index;
                    });
                  },
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 0),
                    child: Container(
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 0,
                          right: 0,
                        ),
                        child: TripsSection(
                          type: tripTypes[currentTripIndex],
                          key: Key("tripsection" + currentTripIndex.toString())
                        ),
                      ),
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

class TripsSection extends StatefulWidget {
  final String type;
  final Key key;
  TripsSection({this.type, this.key});
  @override
  State<StatefulWidget> createState() {
    return TripsSectionState(type: type);
  }
}

class TripsSectionState extends State<TripsSection> {
  final String type;
  TripsSectionState({this.type});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: currentUser["trips"][type.toLowerCase()].length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: AlwaysScrollableScrollPhysics(),
      itemBuilder: (BuildContext itemContext, int index) {
        bool savedSelected = true;
        return Stack(
          children: [
            TripOption(
              trip: currentUser["trips"][type.toLowerCase()][index],
            ),
            Positioned(
              top: 0,
              right: 20,
              child: AnimatedButton(
                callback: () async {
                  currentUser["trips"][type.toLowerCase()] =
                      await deleteHoliday(
                          currentUser["id"],
                          currentUser["trips"][type.toLowerCase()][index]["id"],
                          type.toLowerCase());
                  setState(() {
                    savedSelected = false;
                  });
                  showSuccessToast(context, "Removed from $type Trips");
                },
                child: SaveTripButton(
                  selected: savedSelected,
                ),
              ),
            ),
          ],
        );
      },
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
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Container(
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
          padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                // width: 170,
                // height: 180,
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
