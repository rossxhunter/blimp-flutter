import 'package:blimp/screens/details/details.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ToursPage extends StatefulWidget {
  final List tours;
  ToursPage({this.tours});
  @override
  State<StatefulWidget> createState() {
    return ToursPageState(tours: tours);
  }
}

class ToursPageState extends State<ToursPage> {
  final List tours;
  Map categories = {};
  ToursPageState({this.tours}) {
    for (Map tour in tours) {
      if (!categories.containsKey(tour["category"])) {
        categories[tour["category"]] = [];
      }
      categories[tour["category"]].add(tour);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            FontAwesomeIcons.times,
            color: Theme.of(context).primaryColor,
          ),
        ),
        title: Text(
          "Tours and Tickets",
          style: Theme.of(context)
              .textTheme
              .headline4
              .copyWith(color: Theme.of(context).primaryColor),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 20, bottom: 20),
          child: ListView.builder(
            itemCount: 10,
            shrinkWrap: true,
            itemBuilder: (context, catIndex) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Text(
                      categories.entries.toList()[catIndex].key,
                      style: Theme.of(context).textTheme.headline3,
                    ),
                  ),
                  Container(
                    height: 350,
                    child: ListView.builder(
                      primary: false,
                      scrollDirection: Axis.horizontal,
                      itemCount:
                          categories.entries.toList()[catIndex].value.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int tourIndex) {
                        if (categories.entries.toList()[catIndex].key ==
                            "Day trips & excursions") {
                          Map m = categories.entries
                              .toList()[catIndex]
                              .value[tourIndex];
                          print(m);
                        }
                        return Padding(
                          padding: EdgeInsets.only(
                              bottom: 20, left: 30, right: 10, top: 10),
                          child: TourListOption(
                            tour: categories.entries
                                .toList()[catIndex]
                                .value[tourIndex],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
