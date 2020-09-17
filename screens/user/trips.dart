import 'package:auto_size_text/auto_size_text.dart';
import 'package:blimp/services/user.dart';
import 'package:blimp/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';

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

class TripsSection extends StatelessWidget {
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
                      currentUser == null ? "No Saved Trips" : "Saved Trips",
                      style: Theme.of(context).textTheme.headline3),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Container(
                    height: 300,
                    child: ListView.builder(
                      itemCount: 3,
                      scrollDirection: Axis.horizontal,
                      physics: AlwaysScrollableScrollPhysics(),
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
        // Divider(
        //   color: Colors.grey,
        // ),
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
                  child: Text("Upcoming Trips",
                      style: Theme.of(context).textTheme.headline3),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Container(
                    height: 300,
                    child: ListView.builder(
                      itemCount: 3,
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
                child: Text("Past Trips",
                    style: Theme.of(context).textTheme.headline3),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Container(
                  height: 300,
                  child: ListView.builder(
                    itemCount: 3,
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

class TripOption extends StatelessWidget {
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
                  image: DecorationImage(
                    image: AssetImage("assets/images/paris.jpg"),
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
                      "Paris " + parser.get("flag-" + "fr").code,
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
                              "22 Feb - 24 Feb",
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
