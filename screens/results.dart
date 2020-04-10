import 'package:blimp/screens/accommodation.dart';
import 'package:blimp/screens/activityDetails.dart';
import 'package:blimp/screens/changeActivities.dart';
import 'package:blimp/screens/feedback.dart';
import 'package:blimp/screens/flights.dart';
import 'package:blimp/services/images.dart';
import 'package:blimp/services/suggestions.dart';
import 'package:blimp/styles/colors.dart';
import 'package:blimp/widgets/flight_ticket.dart';
import 'package:blimp/widgets/hotel_option.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_carousel/carousel.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:stretchy_header/stretchy_header.dart';

List<String> imgList = ["assets/images/paris.jpg", "assets/images/paris.jpg"];

class ResultsPage extends StatefulWidget {
  final Map flights;
  final Map accommodation;
  final Map itinerary;
  final String wiki;
  final String name;
  final List allFlights;
  final List allAccommodation;

  ResultsPage({
    this.flights,
    this.accommodation,
    this.itinerary,
    this.wiki,
    this.name,
    this.allFlights,
    this.allAccommodation,
  });
  @override
  State<StatefulWidget> createState() {
    return ResultsPageState(
      flights: flights,
      accommodation: accommodation,
      itinerary: itinerary,
      wiki: wiki,
      name: name,
      allFlights: allFlights,
      allAccommodation: allAccommodation,
    );
  }
}

class ResultsPageState extends State<ResultsPage> {
  final Map flights;
  final Map accommodation;
  final Map itinerary;
  final String wiki;
  final String name;
  final List allFlights;
  final List allAccommodation;

  ScrollController _scrollController;
  double kExpandedHeight = 300.0;

  ResultsPageState({
    this.flights,
    this.accommodation,
    this.itinerary,
    this.wiki,
    this.name,
    this.allFlights,
    this.allAccommodation,
  });

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()..addListener(() => setState(() {}));
  }

  bool get _showTitle {
    return _scrollController.hasClients &&
        _scrollController.offset > kExpandedHeight - kToolbarHeight;
  }

  @override
  Widget build(BuildContext context) {
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
                            showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  FeedbackScreen(),
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
                          Image.asset(
                            'assets/images/paris.jpg',
                            fit: BoxFit.cover,
                          ),
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
        child: ActivityOption(itinerary[day.toString()][index]),
      ),
    );
  }

  return rows;
}

class ActivityOption extends StatelessWidget {
  Map activity;
  String category;
  String bestPhotoURL;
  String name;
  String time;

  ActivityOption(Map activity) {
    this.activity = activity;
    category = activity["category"] ?? "Activity";
    bestPhotoURL = activity["bestPhoto"] ?? getDefaultActivityImageURL();
    name = activity["name"];
    time = getActivityTime(activity["startTime"], activity["duration"]);
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) => ActivityDetails(
            activity: activity,
          ),
        );
      },
      child: Stack(
        children: <Widget>[
          // ClipRRect(
          //   borderRadius: BorderRadius.all(Radius.circular(15)),
          //   child: Container(
          //     decoration: BoxDecoration(color: CustomColors.lightGrey),
          //   ),
          // ),
          ClipRRect(
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
                      // mainAxisSize: MainAxisSize.min,
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
        ],
      ),
    );
  }
}

class ActivitiesSection extends StatelessWidget {
  final Map itinerary;
  int _currentIndex = 0;
  ActivitiesSection({this.itinerary});
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
            Text(
              "Activities",
              style: Theme.of(context).textTheme.headline3,
            ),
            Padding(
              padding: EdgeInsets.only(top: 30),
              child: Container(
                height: 350,
                child: Swiper(
                  onIndexChanged: (value) {
                    _currentIndex = value;
                  },
                  itemWidth: 3000,
                  // itemHeight: 400,
                  itemBuilder: (BuildContext context, int day) {
                    List<Widget> rows = getActivityRows(itinerary, day);

                    return Column(
                      children: <Widget>[
                        Text(
                          "Day " + (day + 1).toString(),
                          style: Theme.of(context).textTheme.headline3,
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: rows.length != 0
                                ? SingleChildScrollView(
                                    // primary: false,
                                    physics: BouncingScrollPhysics(),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: rows,
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
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.downToUp,
                      child: ChangeActivitiesScreen(
                        itinerary: itinerary,
                        day: _currentIndex,
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
              child: GestureDetector(
                onTap: () {
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
