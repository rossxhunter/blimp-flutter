import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:blimp/model/preferences.dart';
import 'package:blimp/screens/accommodation.dart';
import 'package:blimp/screens/activityDetails.dart';
import 'package:blimp/screens/changeActivities.dart';
import 'package:blimp/screens/feedback.dart';
import 'package:blimp/screens/flights.dart';
import 'package:blimp/screens/search.dart';
import 'package:blimp/services/http.dart';
import 'package:blimp/services/images.dart';
import 'package:blimp/services/suggestions.dart';
import 'package:blimp/styles/colors.dart';
import 'package:blimp/widgets/buttons.dart';
import 'package:blimp/widgets/flight_ticket.dart';
import 'package:blimp/widgets/hotel_option.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:flutter_multi_carousel/carousel.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:stretchy_header/stretchy_header.dart';
import 'package:http/http.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';

class ResultsPage extends StatefulWidget {
  final int destId;
  final Map flights;
  final Map accommodation;
  final Map itinerary;
  final List imageURLs;
  final Map weather;
  final String wiki;
  final String name;
  final Map countryInfo;
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
      this.weather,
      this.imageURLs,
      this.countryInfo,
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
        weather: weather,
        imageURLs: imageURLs,
        name: name,
        countryInfo: countryInfo,
        allFlights: allFlights,
        allAccommodation: allAccommodation,
        allActivities: allActivities,
        preferences: preferences);
  }
}

class ResultsPageState extends State<ResultsPage> {
  final int destId;
  Map flights;
  Map accommodation;
  final Map itinerary;
  final List imageURLs;
  final String wiki;
  final String name;
  final Map weather;
  final Map countryInfo;
  final List allFlights;
  final List allAccommodation;
  final List allActivities;
  final Preferences preferences;
  List<List<double>> windows;

  ScrollController _scrollController;
  double kExpandedHeight = 300.0;

  double price;

  ResultsPageState(
      {this.destId,
      this.flights,
      this.accommodation,
      this.itinerary,
      this.wiki,
      this.weather,
      this.countryInfo,
      this.imageURLs,
      this.name,
      this.allFlights,
      this.allAccommodation,
      this.allActivities,
      this.preferences}) {
    price = flights["outbound"]["price"]["amount"] +
        flights["return"]["price"]["amount"] +
        accommodation["price"]["amount"];
    windows = List<List<double>>();
    for (int i = 0; i < itinerary.keys.length; i++) {
      windows.add([8, 17]);
    }
  }
  int _currentIndex;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(() => setState(() {}));
    _currentIndex = 0;
  }

  bool get _showTitle {
    return _scrollController.hasClients &&
        _scrollController.offset > kExpandedHeight - kToolbarHeight;
  }

  void updateFlights(int selectedFlight) {
    setState(() {
      flights = allFlights.where((f) => f["id"] == selectedFlight).toList()[0];
    });
  }

  void updateAccommodation(int selectedAccommodation) {
    setState(() {
      accommodation = allAccommodation
          .where((a) => a["id"] == selectedAccommodation)
          .toList()[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    // preloadImages(context, allAccommodation, itinerary, imageURLs);
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
                        AnimatedButton(
                          callback: () {
                            registerClick("feedback", "standard", {
                              "dest_id": destId,
                            });
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
                                    duration: flights["outbound"]["duration"],
                                    categoryIds: allActivities
                                        .map((a) => a["categoryId"])
                                        .toList(),
                                    preferences: preferences,
                                    price: price,
                                  ),
                                );
                              },
                              pageBuilder: (context, animation1, animation2) {},
                            );
                          },
                          child: Icon(Icons.refresh,
                              color: Theme.of(context).primaryColor),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: AnimatedButton(
                            child: Icon(Icons.sort,
                                color: Theme.of(context).primaryColor),
                            callback: () {
                              showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  isScrollControlled: true,
                                  builder: (_) {
                                    return DraggableScrollableSheet(
                                      expand: false,
                                      initialChildSize: 0.8,
                                      builder: (BuildContext context,
                                          myscrollController) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.only(top: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: 15,
                                                  width: 80,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: SearchPage(),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  });
                            },
                          ),
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
                          imageURLs.length == 0
                              ? Image(
                                  image:
                                      AssetImage("assets/images/mountains.jpg"),
                                  fit: BoxFit.cover)
                              : Swiper(
                                  onIndexChanged: (value) {
                                    setState(() {
                                      _currentIndex = value;
                                    });
                                  },
                                  pagination: SwiperPagination(
                                    margin: EdgeInsets.only(
                                        left: 10, right: 10, bottom: 40),
                                  ),
                                  itemWidth: 3000,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl: imageURLs[index],
                                      errorWidget: (context, url, error) =>
                                          Image(
                                        image: AssetImage(
                                            "assets/images/mountains.jpg"),
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                  },
                                  itemCount: imageURLs.length,
                                  viewportFraction: 1,
                                  scale: 1,
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
                        DestinationInfo(
                          name: name,
                          wiki: wiki,
                          weather: weather,
                          departureDate: preferences.constraints
                              .singleWhere(
                                  (c) => c.property == "departure_date")
                              .value,
                          returnDate: preferences.constraints
                              .singleWhere((c) => c.property == "return_date")
                              .value,
                          travelDuration: flights["outbound"]["duration"],
                          countryInfo: countryInfo,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: FlightsSection(
                            callback: updateFlights,
                            flights: flights,
                            allFlights: allFlights,
                            destId: destId,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: AccommodationSection(
                            callback: updateAccommodation,
                            accommodation: accommodation,
                            allAccommodation: allAccommodation,
                            destId: destId,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: ActivitiesSection(
                            destId: destId,
                            itinerary: itinerary,
                            allActivities: allActivities,
                            travel: flights,
                            accommodation: accommodation,
                            preferences: preferences,
                            windows: windows,
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
                      padding: EdgeInsets.only(top: 5),
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
                      style: Theme.of(context)
                          .textTheme
                          .headline2
                          .copyWith(color: Colors.white),
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
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              child: Container(
                height: 100,
                width: 140,
                child: CachedNetworkImage(
                  imageUrl: bestPhotoURL,
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
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headline2,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          CachedNetworkImage(
                            imageUrl: activity["categoryIcon"] + "64.png",
                            color: Colors.black,
                            height: 25,
                            width: 25,
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 5, top: 2),
                              child: Text(
                                category,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                // textWidthBasis: TextWidthBasis.longestLine,
                                maxLines: 2,
                                style: Theme.of(context).textTheme.headline1,
                              ),
                            ),
                          ),
                        ],
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
  final int destId;
  final Map itinerary;
  final List allActivities;
  final Map travel;
  final Map accommodation;
  final Preferences preferences;
  final List<List<double>> windows;

  ActivitiesSection(
      {this.itinerary,
      this.allActivities,
      this.travel,
      this.destId,
      this.accommodation,
      this.preferences,
      this.windows});
  @override
  State<StatefulWidget> createState() {
    return ActivitiesSectionState(
        itinerary: itinerary,
        allActivities: allActivities,
        travel: travel,
        destId: destId,
        accommodation: accommodation,
        preferences: preferences,
        windows: windows);
  }
}

class ActivitiesSectionState extends State<ActivitiesSection> {
  Map itinerary;
  final List allActivities;
  final int destId;
  final Map travel;
  final Map accommodation;
  final Preferences preferences;
  int _currentIndex;
  List<List<double>> windows;
  ActivitiesSectionState(
      {this.itinerary,
      this.allActivities,
      this.travel,
      this.destId,
      this.accommodation,
      this.preferences,
      this.windows}) {
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
                Row(
                  children: [
                    Icon(
                      Icons.settings,
                      color: Theme.of(context).primaryColor,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Icon(
                        Icons.map,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
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
                                                      .toString() +
                                                  itinerary[day.toString()]
                                                          [index]["duration"]
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
              child: AnimatedButton(
                callback: () async {
                  Map metadata = {"dest_id": destId};
                  registerClick("change_activities", "standard", metadata);
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
                        destId: destId,
                        mode: "standard",
                        windows: windows,
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

class AccommodationSection extends StatefulWidget {
  final Function callback;
  final Map accommodation;
  final List allAccommodation;
  final int destId;

  AccommodationSection(
      {this.callback, this.accommodation, this.allAccommodation, this.destId});

  @override
  State<StatefulWidget> createState() {
    return AccommodationSectionState(
        callback: callback,
        accommodation: accommodation,
        allAccommodation: allAccommodation,
        destId: destId);
  }
}

class AccommodationSectionState extends State<AccommodationSection> {
  final Function callback;
  Map accommodation;
  final List allAccommodation;
  final int destId;

  AccommodationSectionState(
      {this.callback, this.accommodation, this.allAccommodation, this.destId});

  void accommodationSelected(int selectedAccommodation) {
    registerClick("change_accommodation", "standard", {
      "dest_id": destId,
      "old_accommodation": accommodation,
      "new_accommodation": allAccommodation
          .where((a) => a["id"] == selectedAccommodation)
          .toList()[0],
    });
    setState(() {
      accommodation = allAccommodation
          .where((a) => a["id"] == selectedAccommodation)
          .toList()[0];
    });
    callback(selectedAccommodation);
  }

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
              child: HotelOption(
                  hotelDetails: accommodation,
                  key: Key(accommodation["id"].toString())),
            ),
            Padding(
              padding: EdgeInsets.only(top: 30, left: 20, right: 20),
              child: AnimatedButton(
                callback: () {
                  registerClick("see_all_accommodation", "standard", {
                    "dest_id": destId,
                  });
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.downToUp,
                      child: AccommodationScreen(
                        callback: accommodationSelected,
                        selectedAccommodation: accommodation["id"],
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

class FlightsSection extends StatefulWidget {
  final Function callback;
  final Map flights;
  final List allFlights;
  final int destId;

  FlightsSection({this.callback, this.flights, this.allFlights, this.destId});
  @override
  State<StatefulWidget> createState() {
    return FlightsSectionState(
        callback: callback,
        flights: flights,
        allFlights: allFlights,
        destId: destId);
  }
}

class FlightsSectionState extends State<FlightsSection> {
  final Function callback;
  Map flights;
  final List allFlights;
  final int destId;

  FlightsSectionState(
      {this.callback, this.allFlights, this.flights, this.destId});

  void selectFlight(int selectedFlight) {
    registerClick("change_flight", "standard", {
      "dest_id": destId,
      "old_flight": flights,
      "new_flight":
          allFlights.where((f) => f["id"] == selectedFlight).toList()[0],
    });
    setState(() {
      flights = allFlights.where((f) => f["id"] == selectedFlight).toList()[0];
    });

    callback(selectedFlight);
  }

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
              child: AnimatedButton(
                callback: () {
                  registerClick("see_all_flights", "standard", {
                    "dest_id": destId,
                  });
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.downToUp,
                      child: FlightsScreen(
                        allFlights: allFlights,
                        selectedFlight: flights["id"],
                        callback: selectFlight,
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
  final Map countryInfo;
  final String wiki;
  final Map weather;
  final String departureDate;
  final String returnDate;
  final int travelDuration;

  DestinationInfo(
      {this.name,
      this.countryInfo,
      this.wiki,
      this.weather,
      this.departureDate,
      this.returnDate,
      this.travelDuration});
  @override
  Widget build(BuildContext context) {
    EmojiParser parser = EmojiParser();
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.only(left: 30, right: 30, bottom: 30, top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: AutoSizeText(
                    name,
                    style: Theme.of(context).textTheme.headline4,
                    softWrap: true,
                    maxLines: 1,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 40),
                  child: Row(
                    children: [
                      Icon(
                        Icons.wb_sunny,
                        color: Colors.yellow,
                        size: 30,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: Text(
                          weather["temp"].round().toString() + "°C",
                          style: Theme.of(context).textTheme.headline3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.date_range,
                        size: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: Text(
                          DateFormat("d MMM")
                                  .format(DateTime.parse(departureDate)) +
                              " - " +
                              DateFormat("d MMM")
                                  .format(DateTime.parse(returnDate)),
                          style: Theme.of(context).textTheme.headline1,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Row(
                      children: [
                        Icon(
                          Icons.flight,
                          size: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Text(
                            (travelDuration ~/ 60).toString() +
                                "h " +
                                travelDuration.remainder(60).toString() +
                                "m",
                            style: Theme.of(context).textTheme.headline1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          Text(
                            parser
                                .get("flag-" + countryInfo["countryCode"])
                                .code,
                            style: Theme.of(context).textTheme.headline3,
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Text(
                                countryInfo["countryName"],
                                softWrap: true,
                                style: Theme.of(context).textTheme.headline1,
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
