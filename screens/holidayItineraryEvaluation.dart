import 'package:blimp/screens/changeActivities.dart';
import 'package:blimp/screens/results.dart';
import 'package:blimp/services/http.dart';
import 'package:blimp/styles/colors.dart';
import 'package:blimp/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:page_transition/page_transition.dart';

class HolidayItineraryEvaluation extends StatelessWidget {
  final Map city;
  final Map itineraries;
  final List allActivities;
  HolidayItineraryEvaluation({this.city, this.itineraries, this.allActivities});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.greyBackground,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          city["name"],
          style: Theme.of(context).textTheme.headline3,
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).primaryColor,
          ),
        ),
        backgroundColor: Colors.white,
        shape: ContinuousRectangleBorder(
          side: BorderSide(color: CustomColors.lightGrey, width: 4),
        ),
      ),
      body: MediaQuery.removePadding(
        context: context,
        removeBottom: true,
        removeTop: true,
        child: ListView.builder(
            itemCount: 3,
            physics: BouncingScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: ItineraryOption(
                  itinNum: index,
                  itinerary:
                      itineraries[["blimp", "google", "inspirock"][index]],
                  allActivities: allActivities,
                  destId: city["id"],
                ),
              );
            }),
      ),
    );
  }
}

class ItineraryOption extends StatefulWidget {
  final int itinNum;
  final Map itinerary;
  final List allActivities;
  final int destId;
  ItineraryOption(
      {this.itinNum, this.itinerary, this.allActivities, this.destId});
  @override
  State<StatefulWidget> createState() {
    return ItineraryOptionState(
        itinNum: itinNum,
        itinerary: itinerary,
        allActivities: allActivities,
        destId: destId);
  }
}

class ItineraryOptionState extends State<ItineraryOption> {
  final int itinNum;
  Map itinerary;
  final List allActivities;
  final int destId;
  ItineraryOptionState(
      {this.itinNum, this.itinerary, this.allActivities, this.destId});
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.only(top: 20, left: 30, right: 30, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Itinerary " + (itinNum + 1).toString(),
              style: Theme.of(context).textTheme.headline4,
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
                                      primary: true,
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
                                    numDays: itinerary.keys.length,
                                    day: day,
                                  ),
                          ),
                        ),
                      ],
                    );
                  },
                  itemCount: itinerary.keys.length,
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
                  Map metadata = {"destId": destId, "itinNum": itinNum};
                  registerClick("change_activities", "evaluation", metadata);
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.downToUp,
                      child: ChangeActivitiesScreen(
                        itinerary: itinerary,
                        day: _currentIndex,
                        allActivities: allActivities,
                        destId: destId,
                        itinNum: itinNum,
                        mode: "evaluation",
                        windows: [
                          [8, 18],
                          [8, 18],
                          [8, 18]
                        ],
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

class HolidayItinerary extends StatefulWidget {
  final Map itinerary;

  HolidayItinerary({this.itinerary});

  @override
  State<StatefulWidget> createState() {
    return HolidayItineraryState(itinerary: itinerary);
  }
}

class HolidayItineraryState extends State<HolidayItinerary> {
  final Map itinerary;
  int _currentIndex = 0;

  HolidayItineraryState({this.itinerary});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                            primary: true,
                            itemCount: itinerary[day.toString()].length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: EdgeInsets.only(top: 20),
                                child: ActivityOption(
                                    key: Key(itinerary[day.toString()][index]
                                            ["id"] +
                                        itinerary[day.toString()][index]
                                                ["startTime"]
                                            .toString()),
                                    activity: itinerary[day.toString()][index]),
                              );
                            },
                          ),
                        )
                      : NoActivities(
                          numDays: itinerary.keys.length,
                          day: day,
                        ),
                ),
              ),
            ],
          );
        },
        itemCount: itinerary.keys.length,
        viewportFraction: 0.9,
        scale: 0.5,
        control: SwiperControl(
          padding: EdgeInsets.only(bottom: 5000),
        ),
      ),
    );
  }
}
