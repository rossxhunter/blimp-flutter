import 'package:blimp/screens/results.dart';
import 'package:blimp/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class HolidayItineraryEvaluation extends StatelessWidget {
  final Map city;
  final Map itineraries;
  HolidayItineraryEvaluation({this.city, this.itineraries});
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
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.white,
              child: Padding(
                padding:
                    EdgeInsets.only(top: 20, left: 30, right: 30, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Itinerary 1",
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: HolidayItinerary(
                        itinerary: itineraries["blimp"],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding:
                      EdgeInsets.only(top: 20, left: 30, right: 30, bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Itinerary 2",
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: HolidayItinerary(
                          itinerary: itineraries["google"],
                        ),
                      ),
                    ],
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
