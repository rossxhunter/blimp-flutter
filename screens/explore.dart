import 'dart:io';

import 'package:blimp/configurations.dart';
import 'package:blimp/model/preferences.dart';
import 'package:blimp/routes.dart';
import 'package:blimp/screens/results.dart';
import 'package:blimp/services/http.dart';
import 'package:blimp/services/suggestions.dart';
import 'package:blimp/styles/colors.dart';
import 'package:blimp/widgets/alerts.dart';
import 'package:blimp/widgets/buttons.dart';
import 'package:blimp/widgets/loading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:transparent_image/transparent_image.dart';

final List<String> _tabsString = <String>[
  "For You",
  "Popular",
  "Inspiration",
  "Tours",
  "Europe",
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

class ExplorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.only(left: 0, right: 0, bottom: 0, top: 20),
        child: DefaultTabController(
          length: _tabs.length,
          child: NestedScrollView(
            physics: BouncingScrollPhysics(),
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverOverlapAbsorber(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverSafeArea(
                    top: false,
                    sliver: SliverPadding(
                      padding: EdgeInsets.only(
                          left: 30, right: 30, bottom: 0, top: 0),
                      sliver: SliverAppBar(
                        backgroundColor: Colors.white,
                        // floating: true,
                        pinned: true,
                        // snap: true,
                        primary: true,
                        centerTitle: false,
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                // Icon(Icons.settings,
                                //     size: 30, color: Colors.black),
                                Padding(
                                  padding: EdgeInsets.only(left: 0),
                                  child: Text("Explore",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                right: 0,
                                bottom: 5,
                                top: 0,
                              ),
                              child: RandomHolidayButton(),
                            ),
                          ],
                        ),
                        // expandedHeight: 50,
                        elevation: 0,
                        titleSpacing: 0,
                        bottom: TabBar(
                          isScrollable: true,
                          unselectedLabelColor: Theme.of(context).primaryColor,
                          labelStyle: Theme.of(context).textTheme.bodyText1,
                          labelColor: Theme.of(context).primaryColor,
                          labelPadding: EdgeInsets.only(left: 10, right: 20),
                          indicator: CircleTabIndicator(
                              color: Theme.of(context).primaryColor, radius: 4),
                          tabs: _tabs,
                        ),
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: ExplorePageTabView(),
          ),
        ),
      ),
    );
  }
}

class CircleTabIndicator extends Decoration {
  final BoxPainter _painter;

  CircleTabIndicator({@required Color color, @required double radius})
      : _painter = _CirclePainter(color, radius);

  @override
  BoxPainter createBoxPainter([onChanged]) => _painter;
}

class _CirclePainter extends BoxPainter {
  final Paint _paint;
  final double radius;

  _CirclePainter(Color color, this.radius)
      : _paint = Paint()
          ..color = color
          ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final Offset circleOffset =
        offset + Offset(cfg.size.width / 2 - radius, cfg.size.height - radius);
    canvas.drawCircle(circleOffset, radius, _paint);
  }
}

class ExplorePageTabView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                stops: [0, 0.1],
                end: Alignment
                    .bottomCenter, // 10% of the width, so there are ten blinds.
                colors: [
                  Colors.white,
                  CustomColors.greyBackground
                ], // whitish to gray
                tileMode:
                    TileMode.repeated, // repeats the gradient over the canvas
              ),
            ),
            child: TabBarView(
              physics: AlwaysScrollableScrollPhysics(),
              children: _tabsString.map((String name) {
                return SafeArea(
                  top: false,
                  bottom: false,
                  child: Builder(
                    builder: (BuildContext context) {
                      return Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: CustomScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          key: PageStorageKey<String>(name),
                          slivers: <Widget>[
                            SliverOverlapInjector(
                              handle: NestedScrollView
                                  .sliverOverlapAbsorberHandleFor(context),
                            ),
                            SliverPadding(
                              padding: const EdgeInsets.only(
                                  left: 30, right: 30, top: 20),
                              sliver: SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                          bottom: 20, top: 20, left: 20),
                                      child: ExploreOption(
                                        index: index,
                                        name: name,
                                      ),
                                    );
                                  },
                                  childCount: getExploreSuggestions().length,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class RandomHolidayButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.white,
      elevation: 0,
      highlightElevation: 0,
      child: Icon(
        CupertinoIcons.shuffle_thick,
        color: Theme.of(context).primaryColor,
        size: 30,
      ),
      onPressed: () {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return LoadingIndicator();
            });
        Preferences prefs = prefsConfig[0];
        getHoliday(prefs).then((holiday) {
          print(holiday);
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultsPageRoute(holiday, prefs).page(),
            ),
          );
        }).catchError((e) {
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (BuildContext context) => CustomDialog(
              title: "Error",
              description: "Can't get holiday - " + e.toString(),
            ),
          );
        });
      },
    );
  }
}

class ExploreOption extends StatelessWidget {
  final int index;
  final String name;
  ExploreOption({this.index, this.name});

  var parser = EmojiParser();

  void exploreOptionClicked() {}

  @override
  Widget build(BuildContext context) {
    return AnimatedButton(
      callback: () {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return LoadingIndicator();
            });
        Preferences prefs = prefsConfig[0];
        prefs.constraints.add(Constraint("destination",
            {"type": "city", "id": getExploreSuggestions()[index]["id"]}));
        getHoliday(prefs).then((holiday) {
          print(holiday);
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultsPageRoute(holiday, prefs).page(),
            ),
          );
        }).catchError((e) {
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (BuildContext context) => CustomDialog(
              title: "Error",
              description: "Can't get holiday - " + e.toString(),
            ),
          );
        });
      },
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 130, right: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              getExploreSuggestions()[index]["name"],
                              style: Theme.of(context).textTheme.headline3,
                            ),
                            Text(
                              getExploreSuggestions()[index]["country_name"] +
                                  " " +
                                  parser
                                      .get("flag-" +
                                          getExploreSuggestions()[index]
                                              ["country_code"])
                                      .code,
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.camera_alt,
                                  size: 20,
                                ),
                                Expanded(
                                  child: Wrap(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 5),
                                        child: TopAttractionBox(
                                          attraction:
                                              getExploreSuggestions()[index]
                                                  ["top_attractions"][0],
                                        ),
                                      ),
                                    ],
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
            ),
          ),
          Positioned(
            bottom: 20,
            left: -20,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: Container(
                height: 120,
                width: 140,
                child: FadeInImage(
                  fit: BoxFit.cover,
                  image: getExploreSuggestions()[index]["image"] != null
                      ? NetworkImage(getExploreSuggestions()[index]["image"])
                      : AssetImage("assets/images/mountains.jpg"),
                  placeholder: AssetImage("assets/images/mountains.jpg"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TopAttractionBox extends StatelessWidget {
  final String attraction;

  TopAttractionBox({this.attraction});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CustomColors.lightGrey,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
        child: Text(
          attraction,
          overflow: TextOverflow.ellipsis,
          textWidthBasis: TextWidthBasis.longestLine,
          softWrap: true,
          maxLines: 2,
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
    );
  }
}
