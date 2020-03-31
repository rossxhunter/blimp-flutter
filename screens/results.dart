import 'package:blimp/services/suggestions.dart';
import 'package:blimp/widgets/flight_ticket.dart';
import 'package:blimp/widgets/hotel_option.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

final List<String> _tabsString = <String>[
  "Destination",
  "Flights",
  "Accommodation",
  "Activities",
  "Eating",
];

List<Widget> _tabs = [
  Tab(
    child: Align(
      alignment: Alignment.center,
      child: Text(_tabsString[0]),
    ),
  ),
  Tab(
    child: Align(
      alignment: Alignment.center,
      child: Text(_tabsString[1]),
    ),
  ),
  Tab(
    child: Align(
      alignment: Alignment.center,
      child: Text(_tabsString[2]),
    ),
  ),
  Tab(
    child: Align(
      alignment: Alignment.center,
      child: Text(_tabsString[3]),
    ),
  ),
  Tab(
    child: Align(
      alignment: Alignment.center,
      child: Text(_tabsString[4]),
    ),
  ),
];

class ResultsPage extends StatefulWidget {
  final String name;
  final String wiki;
  final Map itinerary;
  final Map flights;
  final Map accommodation;
  ResultsPage(
      {this.name, this.wiki, this.itinerary, this.flights, this.accommodation});
  @override
  State<StatefulWidget> createState() {
    return ResultsPageState(
        name: name,
        wiki: wiki,
        itinerary: itinerary,
        flights: flights,
        accommodation: accommodation);
  }
}

class ResultsPageState extends State<ResultsPage> {
  final String name;
  final String wiki;
  final Map itinerary;
  final Map flights;
  final Map accommodation;
  ResultsPageState(
      {this.name, this.wiki, this.itinerary, this.flights, this.accommodation});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          DefaultTabController(
            length: _tabs.length,
            child: NestedScrollView(
              physics: BouncingScrollPhysics(),
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverOverlapAbsorber(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context),
                    child: SliverSafeArea(
                      top: false,
                      bottom: false,
                      sliver: SliverAppBar(
                        backgroundColor: Colors.white,
                        floating: false,
                        pinned: true,
                        snap: false,
                        primary: true,
                        stretch: true,
                        centerTitle: false,
                        expandedHeight: 300,
                        elevation: 0,
                        titleSpacing: 0,
                        leading: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: BackPageButton(),
                        ),
                        flexibleSpace: FlexibleSpaceBar(
                          stretchModes: <StretchMode>[
                            // StretchMode.zoomBackground,
                            // StretchMode.blurBackground,
                            // StretchMode.fadeTitle,
                          ],
                          centerTitle: false,
                          titlePadding: EdgeInsets.only(left: 50),
                          background: Stack(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                                child: Image(
                                  image: AssetImage('assets/images/paris.jpg'),
                                  fit: BoxFit.cover,
                                  width: 10000,
                                ),
                              ),
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 200),
                                  child: DestinationQuickInfoBox(
                                    name: name,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // bottom:
                    ),
                  ),
                ];
              },
              body: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 0),
                  child: Column(
                    children: <Widget>[
                      TabBar(
                        isScrollable: true,
                        unselectedLabelColor: Colors.redAccent,
                        labelStyle: Theme.of(context).textTheme.body2,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicator: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Colors.redAccent, Colors.pinkAccent]),
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.redAccent,
                        ),
                        tabs: _tabs,
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 100),
                          child: ResultsPageTabView(
                            wiki: wiki,
                            itinerary: itinerary,
                            flights: flights,
                            accommodation: accommodation,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 15.0,
                // offset: Offset.fromDirection(200),
              ),
            ],
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
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 15.0,
                        // offset: Offset.fromDirection(200),
                      ),
                    ],
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

class ResultsPageTabView extends StatelessWidget {
  final String wiki;
  final Map itinerary;
  final Map flights;
  final Map accommodation;
  ResultsPageTabView(
      {this.wiki, this.itinerary, this.flights, this.accommodation});
  @override
  Widget build(BuildContext context) {
    return TabBarView(
      physics: AlwaysScrollableScrollPhysics(),
      children: _tabsString.map((String tabName) {
        return SafeArea(
          top: false,
          bottom: false,
          child: Builder(
            builder: (BuildContext context) {
              return Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        ResultsTab(
                          tabName: tabName,
                          wiki: wiki,
                          itinerary: itinerary,
                          flights: flights,
                          accommodation: accommodation,
                        ),
                      ],
                    ),
                  ));
            },
          ),
        );
      }).toList(),
    );
  }
}

class DestinationQuickInfoBox extends StatelessWidget {
  final String name;
  DestinationQuickInfoBox({this.name});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 15.0,
            // offset: Offset.fromDirection(200),
          ),
        ],
      ),
      height: 120,
      width: 300,
      child: Padding(
        padding: EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  name,
                  style: Theme.of(context).textTheme.headline4,
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            "4",
                            style: Theme.of(context).textTheme.headline1,
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.black54,
                          ),
                        ],
                      )
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.cloud,
                            color: Colors.black54,
                          ),
                          Text(
                            " 27",
                            style: Theme.of(context).textTheme.headline1,
                          ),
                        ],
                      )
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.local_airport,
                            color: Colors.black54,
                          ),
                          Text(
                            " 1hr",
                            style: Theme.of(context).textTheme.headline1,
                          ),
                        ],
                      )
                    ],
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

class BackPageButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Color.fromRGBO(230, 230, 230, 0.8),
      elevation: 0,
      mini: false,
      highlightElevation: 1,
      child: Icon(
        Icons.arrow_back,
        color: Theme.of(context).primaryColor,
        size: 20,
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }
}

class ResultsTab extends StatelessWidget {
  final String tabName;
  final String wiki;
  final Map itinerary;
  final Map flights;
  final Map accommodation;
  int numDays;
  ResultsTab(
      {this.tabName,
      this.wiki,
      this.itinerary,
      this.flights,
      this.accommodation});
  @override
  Widget build(BuildContext context) {
    numDays = itinerary.values.length;
    List<int> indexesOfDayTitles = List<int>();
    indexesOfDayTitles.add(0);
    for (int i = 0; i < numDays; i++) {
      if (indexesOfDayTitles.length > 0) {
        indexesOfDayTitles
            .add(itinerary[i.toString()].length + indexesOfDayTitles[i] + 1);
      } else {
        indexesOfDayTitles.add(itinerary[i.toString()].length);
      }
    }
    if (tabName == "Destination") {
      return Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 10),
        child: Text(
          wiki,
          textAlign: TextAlign.justify,
        ),
      );
    } else if (tabName == "Flights") {
      return Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 10),
        child: Column(
          children: <Widget>[
            FlightTicket(
              ticketDetails: flights["outbound"],
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: FlightTicket(
                ticketDetails: flights["return"],
              ),
            ),
          ],
        ),
      );
    } else if (tabName == "Accommodation") {
      return Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 10),
          child: HotelOption(hotelDetails: accommodation));
    } else if (tabName == "Activities") {
      int itemCount = 0;
      for (List day in itinerary.values) {
        itemCount += day.length + 1;
      }
      return Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 10),
        child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: itemCount,
            primary: false,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: getActivityRows(itinerary, index, indexesOfDayTitles),
              );
            }),
      );
    } else {
      return Text("Placeholder");
    }
  }
}

Widget getActivityRows(Map itinerary, int index, List<int> indexesOfDayTitles) {
  if (indexesOfDayTitles.contains(index)) {
    return ActivityDayTitle(
        day: (indexesOfDayTitles.indexOf(index) + 1).toString());
  }
  int dayIndex = 0;
  int withinDayIndex = 0;

  for (int i = 0; i < indexesOfDayTitles.length; i++) {
    if (indexesOfDayTitles[i] > index) {
      break;
    }
    dayIndex = i;
    withinDayIndex = index - indexesOfDayTitles[i] - 1;
  }
  String description = itinerary[dayIndex.toString()][withinDayIndex]
          ["description"] ??
      "POI Description...";
  String bestPhotoURL = itinerary[dayIndex.toString()][withinDayIndex]
          ["bestPhoto"] ??
      "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e9/Buckingham_Palace_UK.jpg/2560px-Buckingham_Palace_UK.jpg";

  return ActivityOption(
      activity: itinerary[dayIndex.toString()][withinDayIndex]["name"],
      description: description,
      bestPhotoURL: bestPhotoURL,
      time: getActivityTime(
          itinerary[dayIndex.toString()][withinDayIndex]["startTime"],
          itinerary[dayIndex.toString()][withinDayIndex]["duration"]));
}

class ActivityDayTitle extends StatelessWidget {
  final String day;
  ActivityDayTitle({this.day});
  @override
  Widget build(BuildContext context) {
    return Text(
      "Day " + day,
      style: Theme.of(context).textTheme.headline4,
    );
  }
}

String getActivityTime(num startTime, num duration) {
  int startHours = (startTime / 3600).floor();
  int startMinutes = ((startTime % 3600) / 60).floor();
  int endHours = startHours + ((duration / 3600).floor());
  int endMinutes = startMinutes + (((duration % 3600) / 60).floor());
  DateTime startDT = DateTime.utc(2020, 3, 10, startHours, startMinutes)
      .add(new Duration(hours: 8));
  DateTime endDT = DateTime.utc(2020, 3, 10, endHours, endMinutes)
      .add(new Duration(hours: 8));
  var formatter = new DateFormat('Hm');
  String formattedStart = formatter.format(startDT);
  String formattedEnd = formatter.format(endDT);
  return formattedStart + " - " + formattedEnd;
}

class ActivityOption extends StatelessWidget {
  final String activity;
  final String time;
  final String description;
  final String bestPhotoURL;
  ActivityOption(
      {this.activity, this.time, this.description, this.bestPhotoURL});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          child: Container(
            decoration:
                BoxDecoration(color: Color.fromRGBO(240, 240, 240, 0.8)),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          child: Row(
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
                    children: <Widget>[
                      Text(
                        time,
                        style: Theme.of(context).textTheme.headline1,
                      ),
                      Text(
                        activity,
                        style: Theme.of(context).textTheme.headline2,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              description,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              maxLines: 2,
                              style: Theme.of(context).textTheme.headline1,
                            ),
                          ),
                        ],
                      ),
                    ],
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
