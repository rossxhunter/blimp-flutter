import 'package:blimp/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/percent_indicator.dart';

class AchievementsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AchievementsPageState();
  }
}

class AchievementsPageState extends State<AchievementsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 30, left: 30, right: 30),
          child: ListView.builder(
            itemCount: 3,
            physics: BouncingScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return Achievement();
            },
          ),
        ),
      ),
    );
  }
}

class Achievement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(
                      (Colors.green.red * 0.8).round(),
                      (Colors.green.green * 0.8).round(),
                      (Colors.green.blue * 0.8).round(),
                      1),
                  blurRadius: 0.0,
                  spreadRadius: 0,
                  offset: Offset(0, 5),
                )
              ],
            ),
            child: Padding(
              padding:
                  EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
              child: Column(
                children: [
                  Icon(
                    FontAwesomeIcons.award,
                    size: 30,
                    color: Colors.white,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      "LEVEL 1",
                      style: Theme.of(context)
                          .textTheme
                          .headline2
                          .copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Super Searcher",
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      "Next Reward: £5 Blimp Credit",
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: LinearPercentIndicator(
                            lineHeight: 20.0,
                            percent: 0.4,
                            backgroundColor: CustomColors.lightGrey,
                            progressColor: Colors.green,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            "4/10",
                            style: Theme.of(context).textTheme.headline1,
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
    );
  }
}
