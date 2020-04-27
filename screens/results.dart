import 'dart:ui';

import 'package:blimp/model/preferences.dart';
import 'package:blimp/screens/accommodation.dart';
import 'package:blimp/screens/activityDetails.dart';
import 'package:blimp/screens/changeActivities.dart';
import 'package:blimp/screens/feedback.dart';
import 'package:blimp/screens/flights.dart';
import 'package:blimp/services/http.dart';
import 'package:blimp/services/images.dart';
import 'package:blimp/services/suggestions.dart';
import 'package:blimp/styles/colors.dart';
import 'package:blimp/widgets/buttons.dart';
import 'package:blimp/widgets/flight_ticket.dart';
import 'package:blimp/widgets/hotel_option.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_carousel/carousel.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:stretchy_header/stretchy_header.dart';
import 'package:http/http.dart';

List<String> imgList = ["assets/images/paris.jpg", "assets/images/paris.jpg"];

class ResultsPage extends StatefulWidget {
  final int destId;
  final Map flights;
  final Map accommodation;
  final Map itinerary;
  final String imageURL;
  final String wiki;
  final String name;
  final List allFlights;
  final List allAccommodation;
  final List allActivities;
  final Preferences preferences;

  ResultsPage(
      {this.destId,
      this.flights,
      this.accommodation,
      this.itinerary,
      this.wiki,
      this.imageURL,
      this.name,
      this.allFlights,
      this.allAccommodation,
      this.allActivities,
      this.preferences});
  @override
  State<StatefulWidget> createState() {
    return ResultsPageState(
        destId: destId,
        flights: flights,
        accommodation: accommodation,
        itinerary: itinerary,
        wiki: wiki,
        imageURL: imageURL,
        name: name,
        allFlights: allFlights,
        allAccommodation: allAccommodation,
        allActivities: allActivities,
        preferences: preferences);
  }
}

class ResultsPageState extends State<ResultsPage> {
  final int destId;
  final Map flights;
  final Map accommodation;
  final Map itinerary;
  String imageURL;
  final String wiki;
  final String name;
  final List allFlights;
  final List allAccommodation;
  final List allActivities;
  final Preferences preferences;

  ScrollController _scrollController;
  double kExpandedHeight = 300.0;

  double price;

  ResultsPageState(
      {this.destId,
      this.flights,
      this.accommodation,
      this.itinerary,
      this.wiki,
      this.imageURL,
      this.name,
      this.allFlights,
      this.allAccommodation,
      this.allActivities,
      this.preferences}) {
    price = flights["outbound"]["price"]["amount"] +
        flights["return"]["price"]["amount"] +
        accommodation["price"]["amount"];
  }

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()..addListener(() => setState(() {}));
  }

  bool get _showTitle {
    return _scrollController.hasClients &&
        _scrollController.offset > kExpandedHeight - kToolbarHeight;
  }

  Future<void> getDestImageUrl() async {
    final response = await get(imageURL);

    if (response.statusCode != 200) {
      imageURL = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // getDestImageUrl();
    return Scaffold(
      backgroundColor: CustomColors.greyBackground,
      body: Stack(
        children: <Widget>[
          CustomScrollView(
            primary: false,
            controller: _scrollController,
            physics: BouncingScrollPhysics(),
            slivers: <Widget>[
              SliverAppBar(
                shape: ContinuousRectangleBorder(
                  side: _showTitle
                      ? BorderSide(color: CustomColors.lightGrey, width: 4)
                      : BorderSide.none,
                ),
                leading: _showTitle
                    ? IconButton(
                        icon: Icon(Icons.arrow_back,
                            color: Theme.of(context).primaryColor),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                    : null,
                actions: _showTitle
                    ? <Widget>[
                        IconButton(
                          icon: Icon(Icons.refresh,
                              color: Theme.of(context).primaryColor),
                          onPressed: () {
                            showGeneralDialog(
                              context: context,
                              barrierColor: CustomColors.dialogBackground,
                              transitionDuration: Duration(milliseconds: 100),
                              barrierDismissible: true,
                              barrierLabel: '',
                              transitionBuilder: (context, a1, a2, widget) {
                                return Transform.scale(
                                  scale: a1.value,
                                  child: FeedbackScreen(
                                    destId: destId,
                                    preferences: preferences,
                                    price: price,
                                  ),
                                );
                              },
                              pageBuilder: (context, animation1, animation2) {},
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.sort,
                              color: Theme.of(context).primaryColor),
                          onPressed: () {},
                        ),
                      ]
                    : null,
                backgroundColor: Colors.white,
                stretch: true,
                elevation: 0,
                pinned: true,
                floating: false,
                onStretchTrigger: () {
                  // Function callback for stretch
                  return;
                },
                expandedHeight: kExpandedHeight,
                flexibleSpace: Stack(
                  children: <Widget>[
                    FlexibleSpaceBar(
                      stretchModes: <StretchMode>[
                        StretchMode.zoomBackground,
                        StretchMode.fadeTitle,
                      ],
                      centerTitle: true,
                      title: _showTitle
                          ? Text(
                              name,
                              style: Theme.of(context).textTheme.headline3,
                            )
                          : null,
                      collapseMode: CollapseMode.parallax,
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          FadeInImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                "https://blimp-resources.s3.eu-west-2.amazonaws.com/images/destinations/" +
                                    destId.toString() +
                                    "/1.jpg"),
                            placeholder:
                                AssetImage("assets/images/mountains.jpg"),
                          ),
                          // Image.asset(
                          //   'assets/images/paris.jpg',
                          //   fit: BoxFit.cover,
                          // ),
                          // imageURL != null
                          //     ? Image.network(
                          //         imageURL,
                          //         fit: BoxFit.cover,
                          //       )
                          //     : Image.asset(
                          //         'assets/images/paris.jpg',
                          //         fit: BoxFit.cover,
                          //       ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: -1,
                      left: 0,
                      right: 0,
                      child: Visibility(
                        visible: !_showTitle,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30)),
                          child: Container(
                            height: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 100),
                  child: Container(
                    color: CustomColors.greyBackground,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        DestinationInfo(name: name, wiki: wiki),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: FlightsSection(
                            flights: flights,
                            allFlights: allFlights,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: AccommodationSection(
                            accommodation: accommodation,
                            allAccommodation: allAccommodation,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: ActivitiesSection(
                            itinerary: itinerary,
                            allActivities: allActivities,
                            travel: flights,
                            accommodation: accommodation,
                            preferences: preferences,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned.fill(
            top: null,
            child: ResultsPageBookBar(flights["outbound"]["price"],
                flights["return"]["price"], accommodation["price"]),
          ),
        ],
      ),
    );
  }
}

class ResultsPageBookBar extends StatelessWidget {
  Map outboundFlightPrice;
  Map returnFlightPrice;
  Map accommodationPrice;
  double totalPrice;
  String currency;
  ResultsPageBookBar(
      Map outboundFlightPrice, Map returnFlightPrice, Map accommodationPrice) {
    this.outboundFlightPrice = outboundFlightPrice;
    this.returnFlightPrice = returnFlightPrice;
    this.accommodationPrice = accommodationPrice;
    this.totalPrice = outboundFlightPrice["amount"] +
        returnFlightPrice["amount"] +
        accommodationPrice["amount"];
    this.currency = outboundFlightPrice["currency"];
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 100,
          width: 1000,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: CustomColors.lightGrey,
              width: 3,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Total",
                      style: Theme.of(context).textTheme.headline1,
                      textAlign: TextAlign.left,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        NumberFormat.currency(
                                name: currency,
                                symbol: getCurrencySuggestions()[currency]
                                    ["symbol"])
                            .format(totalPrice),
                        style: Theme.of(context).textTheme.headline4,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
                Container(
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 20, bottom: 20, left: 40, right: 40),
                    child: Text(
                      "BOOK",
                      style: Theme.of(context).textTheme.button,
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

String getActivityTime(num startTime, num duration) {
  if (startTime == -1) {
    return "Calculating Times...";
  } else {
    int startHours = (startTime / 3600).floor();
    int startMinutes = ((startTime % 3600) / 60).floor();
    int endHours = startHours + ((duration / 3600).floor());
    int endMinutes = startMinutes + (((duration % 3600) / 60).floor());
    DateTime startDT = DateTime.utc(2020, 3, 10, startHours, startMinutes);
    DateTime endDT = DateTime.utc(2020, 3, 10, endHours, endMinutes);
    var formatter = new DateFormat('Hm');
    String formattedStart = formatter.format(startDT);
    String formattedEnd = formatter.format(endDT);
    return formattedStart + " - " + formattedEnd;
  }
}

class ActivityDayTitle extends StatelessWidget {
  final String day;
  ActivityDayTitle({this.day});
  @override
  Widget build(BuildContext context) {
    return Text(
      "Day " + day,
      style: Theme.of(context).textTheme.headline3,
    );
  }
}

List<Widget> getActivityRows(Map itinerary, int day) {
  List<Widget> rows = [];
  for (int index = 0; index < itinerary[day.toString()].length; index++) {
    rows.add(
      Padding(
        padding: EdgeInsets.only(top: 20),
        child: ActivityOption(activity: itinerary[day.toString()][index]),
      ),
    );
  }

  return rows;
}

class ActivityOption extends StatefulWidget {
  final Map activity;
  final Key key;
  ActivityOption({this.activity, this.key});

  @override
  State<StatefulWidget> createState() {
    return ActivityOptionState(activity);
  }
}

class ActivityOptionState extends State<ActivityOption> {
  Map activity;
  String category;
  String bestPhotoURL;
  String name;
  String time;

  ActivityOptionState(Map activity) {
    this.activity = activity;
    category = activity["category"] ?? "Activity";
    bestPhotoURL = activity["bestPhoto"] ?? getDefaultActivityImageURL();
    name = activity["name"];
    time = getActivityTime(activity["startTime"], activity["duration"]);
  }

  void clickActivity() {
    showGeneralDialog(
      context: context,
      barrierColor: CustomColors.dialogBackground,
      transitionDuration: Duration(milliseconds: 100),
      barrierDismissible: true,
      barrierLabel: '',
      transitionBuilder: (context, a1, a2, widget) {
        return Transform.scale(
          scale: a1.value,
          child: ActivityDetails(
            activity: activity,
          ),
        );
      },
      pageBuilder: (context, animation1, animation2) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedButton(
      callback: clickActivity,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              child: Container(
                height: 100,
                width: 140,
                child: Image(
                  image: NetworkImage(bestPhotoURL),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 20, right: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(
                      time,
                      style: Theme.of(context).textTheme.headline1,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text(
                        name,
                        style: Theme.of(context).textTheme.headline2,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Container(
                        decoration: BoxDecoration(
                          color: CustomColors.redGrey,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 5, bottom: 5, left: 10, right: 10),
                          child: Text(
                            category,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            textWidthBasis: TextWidthBasis.longestLine,
                            maxLines: 2,
                            style: Theme.of(context).textTheme.headline1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ActivitiesSection extends StatefulWidget {
  final Map itinerary;
  final List allActivities;
  final Map travel;
  final Map accommodation;
  final Preferences preferences;

  ActivitiesSection(
      {this.itinerary,
      this.allActivities,
      this.travel,
      this.accommodation,
      this.preferences});
  @override
  State<StatefulWidget> createState() {
    return ActivitiesSectionState(
        itinerary: itinerary,
        allActivities: allActivities,
        travel: travel,
        accommodation: accommodation,
        preferences: preferences);
  }
}

class ActivitiesSectionState extends State<ActivitiesSection> {
  Map itinerary;
  final List allActivities;
  final Map travel;
  final Map accommodation;
  final Preferences preferences;
  int _currentIndex;
  ActivitiesSectionState(
      {this.itinerary,
      this.allActivities,
      this.travel,
      this.accommodation,
      this.preferences}) {
    _currentIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    int numDays = itinerary.values.length;
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Activities",
                  style: Theme.of(context).textTheme.headline3,
                ),
                Icon(
                  Icons.map,
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 30),
              child: Container(
                height: 350,
                child: Swiper(
                  onIndexChanged: (value) {
                    setState(() {
                      _currentIndex = value;
                    });
                  },
                  itemWidth: 3000,
                  itemBuilder: (BuildContext context, int day) {
                    return Column(
                      children: <Widget>[
                        Text(
                          "Day " + (day + 1).toString(),
                          style: Theme.of(context).textTheme.headline3,
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: itinerary[day.toString()].length != 0
                                ? MediaQuery.removePadding(
                                    context: context,
                                    removeTop: true,
                                    child: ListView.builder(
                                      primary: false,
                                      itemCount:
                                          itinerary[day.toString()].length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Padding(
                                          padding: EdgeInsets.only(top: 20),
                                          child: ActivityOption(
                                              key: Key(itinerary[day.toString()]
                                                      [index]["id"] +
                                                  itinerary[day.toString()]
                                                          [index]["startTime"]
                                                      .toString()),
                                              activity:
                                                  itinerary[day.toString()]
                                                      [index]),
                                        );
                                      },
                                    ),
                                  )
                                : NoActivities(
                                    numDays: numDays,
                                    day: day,
                                  ),
                          ),
                        ),
                      ],
                    );
                  },
                  itemCount: numDays,
                  viewportFraction: 0.9,
                  scale: 0.5,
                  control: SwiperControl(
                    padding: EdgeInsets.only(bottom: 5000),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: GestureDetector(
                onTap: () async {
                  registerClick("change_activities");
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.downToUp,
                      child: ChangeActivitiesScreen(
                        itinerary: itinerary,
                        day: _currentIndex,
                        allActivities: allActivities,
                        travel: travel,
                        accommodation: accommodation,
                        preferences: preferences,
                      ),
                    ),
                  ).then((value) {
                    setState(() {});
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Color.fromRGBO(220, 220, 220, 1),
                      width: 2,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(
                      child: Text(
                        "Change Activities",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NoActivities extends StatelessWidget {
  final int numDays;
  final int day;

  NoActivities({this.numDays, this.day});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            day == 0 ? Icons.flight_land : Icons.flight_takeoff,
          ),
          Text(
            day == 0 ? "Arrival Day" : "Departure Day",
            style: Theme.of(context)
                .textTheme
                .headline3
                .copyWith(color: Theme.of(context).primaryColor),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              "No Activities",
              style: Theme.of(context)
                  .textTheme
                  .headline2
                  .copyWith(color: Theme.of(context).primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}

class AccommodationSection extends StatelessWidget {
  final Map accommodation;
  final List allAccommodation;

  AccommodationSection({this.accommodation, this.allAccommodation});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Accommodation",
              style: Theme.of(context).textTheme.headline3,
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: HotelOption(hotelDetails: accommodation),
            ),
            Padding(
              padding: EdgeInsets.only(top: 30, left: 20, right: 20),
              child: AnimatedButton(
                callback: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.downToUp,
                      child: AccommodationScreen(
                        allAccommodation: allAccommodation,
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Color.fromRGBO(220, 220, 220, 1),
                      width: 2,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(
                      child: Text(
                        "See All Accommodation",
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                              color: Theme.of(context).primaryColor,
                            ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FlightsSection extends StatelessWidget {
  final Map flights;
  final List allFlights;

  FlightsSection({this.flights, this.allFlights});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Flights",
              style: Theme.of(context).textTheme.headline3,
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: FlightTicket(
                ticketDetails: flights["outbound"],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: FlightTicket(
                ticketDetails: flights["return"],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 30, left: 20, right: 20),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.downToUp,
                      child: FlightsScreen(allFlights: allFlights),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Color.fromRGBO(220, 220, 220, 1),
                      width: 2,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(
                      child: Text(
                        "See All Flights",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DestinationInfo extends StatelessWidget {
  final String name;
  final String wiki;

  DestinationInfo({this.name, this.wiki});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.only(left: 30, right: 30, bottom: 30, top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              name,
              style: Theme.of(context).textTheme.headline4,
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                wiki,
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final List child = imgList.map(
  (path) {
    return Container(
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(0.0)),
        child: Image.asset(
          path,
          fit: BoxFit.cover,
          width: 1000.0,
        ),
      ),
    );
  },
).toList();

class CarouselWithIndicator extends StatefulWidget {
  final BuildContext originalContext;
  CarouselWithIndicator({this.originalContext});
  @override
  _CarouselWithIndicatorState createState() =>
      _CarouselWithIndicatorState(originalContext: originalContext);
}

class _CarouselWithIndicatorState extends State<CarouselWithIndicator> {
  int _current = 0;
  final BuildContext originalContext;

  _CarouselWithIndicatorState({this.originalContext});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: child,
      autoPlay: true,
      viewportFraction: 1.0,
      aspectRatio: 1,
      onPageChanged: (index) {
        setState(() {
          _current = index;
        });
      },
    );
    // Positioned(
    //   child: Align(
    //     alignment: Alignment.bottomCenter,
    //     child: Row(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [0, 1].map(
    //         (index) {
    //           return Container(
    //             width: 8.0,
    //             height: 8.0,
    //             margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
    //             decoration: BoxDecoration(
    //                 shape: BoxShape.circle,
    //                 color: _current == index
    //                     ? Color.fromRGBO(0, 0, 0, 0.9)
    //                     : Color.fromRGBO(0, 0, 0, 0.4)),
    //           );
    //         },
    //       ).toList(),
    //     ),
    //   ),
    // ),
  }
}
