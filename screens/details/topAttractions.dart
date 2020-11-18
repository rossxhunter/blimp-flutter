import 'package:blimp/screens/details/details.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TopAttractions extends StatefulWidget {
  final List attractions;
  TopAttractions({this.attractions});
  @override
  State<StatefulWidget> createState() {
    return TopAttractionsState(attractions: attractions);
  }
}

class TopAttractionsState extends State<TopAttractions> {
  final List attractions;
  TopAttractionsState({this.attractions});
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
          "Top Attractions",
          style: Theme.of(context)
              .textTheme
              .headline4
              .copyWith(color: Theme.of(context).primaryColor),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 20),
          child: ListView.builder(
            itemCount: attractions.length,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    EdgeInsets.only(bottom: 20, left: 20, right: 20, top: 10),
                child: Row(
                  children: [
                    Text(
                      (index + 1).toString(),
                      style: Theme.of(context)
                          .textTheme
                          .headline3
                          .copyWith(color: Theme.of(context).primaryColor),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 20,
                        ),
                        child: ActivityListOption(
                          activity: attractions[index],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
