import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:blimp/configurations.dart';
import 'package:blimp/model/preferences.dart';
import 'package:blimp/routes.dart';
import 'package:blimp/screens/details.dart';
import 'package:blimp/screens/results/results.dart';
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
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_typeahead/cupertino_flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:percent_indicator/percent_indicator.dart';

final List<String> _tabsString = <String>[
  "For You",
  "Popular",
  "Europe",
  "Asia",
  "Americas",
];

final List<String> _continents = <String>[
  "Europe",
  "Asia",
  "Americas",
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
  final List imageURLs = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.only(left: 0, right: 0, bottom: 0, top: 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: 30, right: 20, bottom: 0, top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Explore",
                            style: Theme.of(context).textTheme.headline4),
                        // Image(
                        //   image: AssetImage(
                        //     "assets/images/logo.png",
                        //   ),
                        //   width: 40,
                        //   height: 40,
                        // ),
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
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 30, right: 30, bottom: 20, top: 20),
                    child: ExploreSearchBar(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 30, right: 30, bottom: 0, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        QuickExploreBox(
                          text: "Flight",
                          color: Theme.of(context).primaryColor,
                          icon: FontAwesomeIcons.plane,
                        ),
                        QuickExploreBox(
                          text: "Hotel",
                          color: Colors.blue,
                          icon: FontAwesomeIcons.hotel,
                        ),
                        QuickExploreBox(
                          text: "Attraction",
                          color: Color.fromRGBO(46, 204, 113, 1),
                          icon: FontAwesomeIcons.umbrellaBeach,
                        ),
                        QuickExploreBox(
                          text: "Inspiration",
                          color: Colors.orange,
                          icon: FontAwesomeIcons.lightbulb,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 10, right: 10, bottom: 20, top: 30),
                    child: Container(
                      height: 240,
                      child: Swiper(
                        onIndexChanged: (value) {
                          // setState(() {
                          //   _currentIndex = value;
                          // });
                        },
                        itemWidth: 3000,
                        itemBuilder: (BuildContext context, int index) {
                          return AnimatedButton(
                            callback: () {
                              getCityDetailsFromId(suggestions
                                          .getExploreSuggestions()["For You"]
                                      [index]["id"])
                                  .then((details) {
                                Map cityDetails = details;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailsPage(
                                      cityDetails: cityDetails,
                                      quickView: false,
                                    ),
                                  ),
                                );
                              });
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: suggestions
                                            .getExploreSuggestions()["For You"]
                                        [index]["images"][1],
                                    placeholder: (context, url) => Container(
                                      height: 10000,
                                      width: 10000,
                                      color: CustomColors.lightGrey,
                                    ),
                                    errorWidget: (context, url, error) => Image(
                                      image: NetworkImage(
                                          suggestions.getExploreSuggestions()[
                                              "For You"][index]["images"][1]),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        stops: [0, 0.5],
                                        colors: [
                                          Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.5),
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 20,
                                    left: 20,
                                    child: Text(
                                      suggestions.getExploreSuggestions()[
                                          "For You"][index]["name"],
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline3
                                          .copyWith(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        itemCount: suggestions
                            .getExploreSuggestions()["For You"]
                            .length,
                        viewportFraction: 0.8,
                        scale: 0.8,
                      ),
                    ),
                  ),
                  ListView.builder(
                    itemCount: _continents.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int contIndex) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: 30, right: 30, bottom: 20, top: 20),
                            child: Text(
                              _continents[contIndex],
                              style: Theme.of(context).textTheme.headline3,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 20, right: 20, bottom: 20, top: 0),
                            child: Container(
                              height: 340,
                              child: MediaQuery.removePadding(
                                context: context,
                                removeLeft: true,
                                child: ListView.builder(
                                  itemCount: suggestions
                                      .getExploreSuggestions()[
                                          _continents[contIndex]]
                                      .length,
                                  scrollDirection: Axis.horizontal,
                                  physics: BouncingScrollPhysics(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return AnimatedButton(
                                      callback: () {
                                        getCityDetailsFromId(suggestions
                                                    .getExploreSuggestions()[
                                                _continents[
                                                    contIndex]][index]["id"])
                                            .then((details) {
                                          Map cityDetails = details;
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => DetailsPage(
                                                cityDetails: cityDetails,
                                                quickView: false,
                                              ),
                                            ),
                                          );
                                        });
                                      },
                                      child: DestinationOption(
                                          option: suggestions
                                                  .getExploreSuggestions()[
                                              _continents[contIndex]][index]),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 30, right: 30, bottom: 20, top: 20),
                    child: Text(
                      "Attractions",
                      style: Theme.of(context).textTheme.headline3,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 20, right: 20, bottom: 20, top: 0),
                    child: Container(
                      height: 310,
                      child: MediaQuery.removePadding(
                        context: context,
                        removeLeft: true,
                        child: ListView.builder(
                          itemCount: 12,
                          scrollDirection: Axis.horizontal,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return AttractionsOption(
                                attraction: suggestions
                                    .getAttractionSuggestions()[index]);
                          },
                        ),
                      ),
                    ),
                  ),
                  //       Padding(
                  //         padding: EdgeInsets.only(
                  //             left: 30, right: 30, bottom: 20, top: 20),
                  //         child: Text(
                  //           "Holiday Themes",
                  //           style: Theme.of(context).textTheme.headline3,
                  //         ),
                  //       ),
                  //       Padding(
                  //         padding:
                  //             EdgeInsets.only(left: 30, right: 30, bottom: 0, top: 0),
                  //         child: GridView.count(
                  //           shrinkWrap: true,
                  //           physics: NeverScrollableScrollPhysics(),
                  //           crossAxisCount: 3,
                  //           crossAxisSpacing: 20,
                  //           mainAxisSpacing: 10,
                  //           children: [
                  //             QuickExploreBox(
                  //                 text: "Relax",
                  //                 color: Colors.indigo,
                  //                 icon: Icons.spa),
                  //             QuickExploreBox(
                  //                 text: "Cultural",
                  //                 color: Colors.blue,
                  //                 icon: FontAwesomeIcons.landmark),
                  //             QuickExploreBox(
                  //                 text: "Active",
                  //                 color: Colors.orange,
                  //                 icon: Icons.directions_run),
                  //             QuickExploreBox(
                  //                 text: "Family",
                  //                 color: Colors.purple,
                  //                 icon: Icons.people),
                  //             QuickExploreBox(
                  //                 text: "Romantic",
                  //                 color: Colors.red,
                  //                 icon: FontAwesomeIcons.solidHeart),
                  //             QuickExploreBox(
                  //                 text: "Nature",
                  //                 color: Colors.green,
                  //                 icon: FontAwesomeIcons.tree),
                  //           ],
                  //         ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AttractionsOption extends StatelessWidget {
  final Map attraction;
  AttractionsOption({this.attraction});
  @override
  Widget build(BuildContext context) {
    var parser = EmojiParser();
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
      child: Container(
        width: 240,
        // height: 30,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 160,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CachedNetworkImage(
                    imageUrl: attraction["photo"],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 10, left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        fit: FlexFit.tight,
                        child: AutoSizeText(
                          attraction["name"],
                          maxLines: 2,
                          minFontSize: 14,
                          maxFontSize: 20,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headline3,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Row(
                          children: [
                            Text(
                              parser
                                  .get("flag-" +
                                      attraction["country_code"].toLowerCase())
                                  .code,
                              style: Theme.of(context).textTheme.headline3,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                attraction["city_name"],
                                style: Theme.of(context).textTheme.headline1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          CachedNetworkImage(
                            imageUrl: attraction["cat_icon"] + "64.png",
                            color: Colors.black,
                            height: 25,
                            width: 25,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              attraction["cat_name"],
                              style: Theme.of(context).textTheme.headline1,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DestinationOption extends StatelessWidget {
  final Map option;
  DestinationOption({this.option});
  @override
  Widget build(BuildContext context) {
    var parser = EmojiParser();
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
      child: Container(
        width: 250,
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
                width: 240,
                height: 180,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: option["images"][0],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 10, left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AutoSizeText(
                        option["name"] +
                            " " +
                            parser.get("flag-" + option["country_code"]).code,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.headline3,
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              CircularPercentIndicator(
                                radius: 40,
                                percent: option["culture"] / 10,
                                animationDuration: 1000,
                                circularStrokeCap: CircularStrokeCap.round,
                                animation: true,
                                center: Text(
                                  option["culture"].toStringAsFixed(1),
                                  style: Theme.of(context).textTheme.headline1,
                                ),
                                footer: Text(
                                  "Culture",
                                  style: Theme.of(context).textTheme.headline1,
                                ),
                              ),
                              CircularPercentIndicator(
                                radius: 40,
                                percent: option["shopping"] / 10,
                                animationDuration: 1000,
                                circularStrokeCap: CircularStrokeCap.round,
                                animation: true,
                                center: Text(
                                  option["shopping"].toStringAsFixed(1),
                                  style: Theme.of(context).textTheme.headline1,
                                ),
                                footer: Text(
                                  "Shopping",
                                  style: Theme.of(context).textTheme.headline1,
                                ),
                              ),
                              CircularPercentIndicator(
                                radius: 40,
                                percent: option["nightlife"] / 10,
                                animationDuration: 1000,
                                circularStrokeCap: CircularStrokeCap.round,
                                animation: true,
                                center: Text(
                                  option["nightlife"].toStringAsFixed(1),
                                  style: Theme.of(context).textTheme.headline1,
                                ),
                                footer: Text(
                                  "Nightlife",
                                  style: Theme.of(context).textTheme.headline1,
                                ),
                              ),
                            ],
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
      ),
    );
  }
}

// class ExplorePopularDestinations extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return ExplorePopularDestinationsState();
//   }
// }

// class ExplorePopularDestinationsState extends State<ExplorePopularDestinations>
//     with TickerProviderStateMixin {
//   @override
//   Widget build(BuildContext context) {
//     TabController _controller =
//         TabController(vsync: this, length: _tabs.length, initialIndex: 0);
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Padding(
//           padding: EdgeInsets.only(left: 10, right: 10, bottom: 0, top: 0),
//           child: TabBar(
//             isScrollable: true,
//             controller: _controller,
//             unselectedLabelColor: Theme.of(context).primaryColor,
//             labelStyle: Theme.of(context).textTheme.bodyText1,
//             labelColor: Theme.of(context).primaryColor,
//             labelPadding: EdgeInsets.only(left: 10, right: 20),
//             indicator: CircleTabIndicator(
//                 color: Theme.of(context).primaryColor, radius: 4),
//             tabs: _tabs,
//           ),
//         ),
//         Flexible(
//           fit: FlexFit.loose,
//           child: Padding(
//             padding: EdgeInsets.only(left: 10, right: 10, bottom: 20, top: 0),
//             child: ExplorePageTabView(
//               tabController: _controller,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

class QuickExploreBox extends StatelessWidget {
  final String text;
  final Color color;
  final IconData icon;
  QuickExploreBox({this.text, this.color, this.icon});
  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 80,
      child: Column(
        children: [
          Container(
            height: 55,
            width: 55,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.2),
                  blurRadius: 10,
                  offset: Offset(5, 5),
                ),
              ],
            ),
            child: Center(
              child: FaIcon(
                icon,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5),
            child: Text(
              text,
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
        ],
      ),
    );
  }
}

class ExploreSearchBar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ExploreSearchBarState();
  }
}

class ExploreSearchBarState extends State<ExploreSearchBar> {
  TextEditingController typeAheadController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var parser = EmojiParser();
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            blurRadius: 20.0,
            offset: Offset(0, 0),
          )
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Icon(
              Icons.search,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 16),
                child: CupertinoTypeAheadField(
                  textFieldConfiguration: CupertinoTextFieldConfiguration(
                    onChanged: (var value) {},
                    maxLines: 1,
                    placeholder: "Discover cities, activities, hotels...",
                    onTap: () {
                      typeAheadController.clear();
                      // callback(point, {});
                    },
                    padding:
                        EdgeInsets.only(left: 0, right: 6, top: 5, bottom: 6),
                    controller: typeAheadController,
                    autofocus: false,
                    style: Theme.of(context).textTheme.headline2,
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                  ),
                  suggestionsCallback: (pattern) {
                    return suggestions.getSearchSuggestionsForQuery(pattern);
                  },
                  suggestionsBoxDecoration: CupertinoSuggestionsBoxDecoration(
                    offsetX: -80,
                    borderRadius: BorderRadius.circular(15),
                    constraints: BoxConstraints(
                        minWidth: MediaQuery.of(context).size.width),
                  ),
                  hideOnLoading: true,
                  hideSuggestionsOnKeyboardHide: true,
                  hideOnEmpty: true,
                  hideOnError: true,
                  getImmediateSuggestions: true,
                  suggestionsBoxController: CupertinoSuggestionsBoxController(),
                  itemBuilder: (context, suggestion) {
                    return Padding(
                      padding: EdgeInsets.only(
                          left: 30, right: 20, top: 20, bottom: 20),
                      child: Row(
                        children: <Widget>[
                          suggestion["type"] == "destination"
                              ? Text(
                                  parser
                                      .get("flag-" +
                                          suggestion["suggestion"]
                                                  ["countryCode"]
                                              .toLowerCase())
                                      .code,
                                  style: Theme.of(context).textTheme.headline4,
                                )
                              : suggestion["type"] == "attraction"
                                  ? CachedNetworkImage(
                                      imageUrl: suggestion["suggestion"]
                                              ["cat_icon"] +
                                          "64.png",
                                      width: 35,
                                      height: 35,
                                      color: Colors.black,
                                    )
                                  : Icon(
                                      Icons.hotel,
                                      size: 30,
                                    ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: suggestion["type"] == "attraction"
                                      ? 20
                                      : 25),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    suggestion["suggestion"]["name"],

                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                    // overflow: TextOverflow.ellipsis,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text(
                                      suggestion["type"] == "destination"
                                          ? suggestion["suggestion"]
                                              ["countryName"]
                                          : parser
                                                  .get("flag-" +
                                                      suggestion["suggestion"]
                                                              ["countryCode"]
                                                          .toLowerCase())
                                                  .code +
                                              " " +
                                              suggestion["suggestion"]["city"],
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  onSuggestionSelected: (suggestion) {
                    // this.typeAheadController.text = suggestion["type"] == "city"
                    //     ? suggestion["cityName"]
                    //     : suggestion["airportName"];
                    // callback(point, suggestion);
                  },
                ),
              ),
            ),
          ],
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

// class ExplorePageTabView extends StatelessWidget {
//   final TabController tabController;
//   ExplorePageTabView({this.tabController});
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 400,
//       decoration: BoxDecoration(
//           // gradient: LinearGradient(
//           //   begin: Alignment.topCenter,
//           //   stops: [0, 0.1],
//           //   end: Alignment
//           //       .bottomCenter,
//           //   colors: [
//           //     Colors.white,
//           //     CustomColors.greyBackground
//           //   ], // whitish to gray
//           //   tileMode:
//           //       TileMode.repeated,
//           // ),
//           ),
//       child: TabBarView(
//         physics: AlwaysScrollableScrollPhysics(),
//         controller: tabController,
//         children: _tabsString.map((String name) {
//           return SafeArea(
//             top: false,
//             bottom: false,
//             child: Builder(
//               builder: (BuildContext context) {
//                 return Padding(
//                   padding: EdgeInsets.only(top: 10, right: 0, left: 10),
//                   child: ExploreList(name: name),
//                 );
//               },
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }
// }

// class ExploreList extends StatefulWidget {
//   final String name;
//   ExploreList({this.name});
//   @override
//   State<StatefulWidget> createState() {
//     return ExploreListState(name: name);
//   }
// }

// class ExploreListState extends State<ExploreList>
//     with AutomaticKeepAliveClientMixin {
//   final String name;
//   ExploreListState({this.name});
//   @override
//   Widget build(BuildContext context) {
//     return MediaQuery.removePadding(
//       removeTop: true,
//       context: context,
//       child: ListView.builder(
//         // itemExtent: 30,
//         addAutomaticKeepAlives: true,
//         shrinkWrap: true,
//         itemCount: getExploreSuggestions()[name].length,
//         physics: BouncingScrollPhysics(),
//         itemBuilder: (BuildContext context, int index) {
//           return Padding(
//             padding: EdgeInsets.only(bottom: 20, top: 20, left: 20, right: 10),
//             child: ExploreOption(
//               index: index,
//               name: name,
//             ),
//           );
//         },
//       ),
//     );
//   }

//   @override
//   bool get wantKeepAlive => true;
// }

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
        prefs.constraints.removeWhere((c) => c.property == "departure_date");
        prefs.constraints.removeWhere((c) => c.property == "return_date");
        prefs.constraints.removeWhere((c) => c.property == "destination");
        prefs.constraints.add(Constraint("departure_date", "2020-08-27"));
        prefs.constraints.add(Constraint("return_date", "2020-08-30"));
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
          showErrorToast(context, "Can't get holiday - " + e.toString());
        });
      },
    );
  }
}

// class ExploreOption extends StatefulWidget {
//   final int index;
//   final String name;
//   ExploreOption({this.index, this.name});
//   @override
//   State<StatefulWidget> createState() {
//     return ExploreOptionState(index: index, name: name);
//   }
// }

// class ExploreOptionState extends State<ExploreOption> {
//   final int index;
//   final String name;
//   ExploreOptionState({this.index, this.name});

//   var parser = EmojiParser();

//   void exploreOptionClicked() {}

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedButton(
//       callback: () {
//         showDialog(
//             context: context,
//             barrierDismissible: false,
//             builder: (BuildContext context) {
//               return LoadingIndicator();
//             });
//         Preferences prefs = prefsConfig[0];
//         prefs.constraints.removeWhere((c) => c.property == "departure_date");
//         prefs.constraints.removeWhere((c) => c.property == "return_date");
//         prefs.constraints.add(Constraint("departure_date",
//             getExploreSuggestions()[name][index]["departure_date"]));
//         prefs.constraints.add(Constraint("return_date",
//             getExploreSuggestions()[name][index]["return_date"]));
//         prefs.constraints.add(Constraint("destination", {
//           "type": "city",
//           "id": getExploreSuggestions()[name][index]["id"]
//         }));
//         Navigator.pop(context);
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => DetailsPage(
//               cityId: getExploreSuggestions()[name][index]["id"],
//               imageURLs: [],
//             ),
//           ),
//         );
//         // getHoliday(prefs).then((holiday) {
//         //   print(holiday);
//         //   Navigator.pop(context);
//         //   Navigator.push(
//         //     context,
//         //     MaterialPageRoute(
//         //       builder: (context) => ResultsPageRoute(holiday, prefs).page(),
//         //     ),
//         //   );
//         // }).catchError((e) {
//         //   Navigator.pop(context);
//         //   showDialog(
//         //     context: context,
//         //     builder: (BuildContext context) => CustomDialog(
//         //       title: "Error",
//         //       description: "Can't get holiday - " + e.toString(),
//         //     ),
//         //   );
//         // });
//       },
//       child: Stack(
//         overflow: Overflow.visible,
//         children: <Widget>[
//           Container(
//             height: 130,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(15),
//               // border: Border.all(
//               //   color: CustomColors.lightGrey,
//               //   width: 2,
//               // ),
//               // boxShadow: [
//               //   BoxShadow(
//               //     color: CustomColors.lightGrey,
//               //     blurRadius: 0.0,
//               //     spreadRadius: 0.0,
//               //     offset: Offset(0.0, 5.0), // shadow direction: bottom right
//               //   )
//               // ],
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.4),
//                   blurRadius: 20.0,
//                   offset: Offset(0, 5),
//                 )
//               ],
//             ),
//             child: Padding(
//               padding: EdgeInsets.all(10),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.all(Radius.circular(15)),
//                 child: Row(
//                   children: <Widget>[
//                     Expanded(
//                       child: Padding(
//                         padding: EdgeInsets.only(left: 130, right: 10),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: <Widget>[
//                             AutoSizeText(
//                               getExploreSuggestions()[name][index]["name"],
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                               style: Theme.of(context).textTheme.headline3,
//                             ),
//                             Row(
//                               children: [
//                                 Text(
//                                   parser
//                                       .get("flag-" +
//                                           getExploreSuggestions()[name][index]
//                                               ["country_code"])
//                                       .code,
//                                   style: Theme.of(context).textTheme.headline3,
//                                 ),
//                                 Padding(
//                                   padding: EdgeInsets.only(left: 10),
//                                   child: Text(
//                                     getExploreSuggestions()[name][index]
//                                         ["country_name"],
//                                     style:
//                                         Theme.of(context).textTheme.bodyText2,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             Row(
//                               children: <Widget>[
//                                 Icon(
//                                   Icons.location_on,
//                                   size: 20,
//                                 ),
//                                 Expanded(
//                                   child: Wrap(
//                                     children: [
//                                       Padding(
//                                         padding: EdgeInsets.only(left: 5),
//                                         child: TopAttractionBox(
//                                           attraction:
//                                               getExploreSuggestions()[name]
//                                                   [index]["top_attractions"][0],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: 0,
//             left: -20,
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(10),
//               child: Container(
//                 height: 130,
//                 width: 145,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   boxShadow: [
//                     BoxShadow(
//                       color: CustomColors.lightGrey,
//                       blurRadius: 10.0,
//                       spreadRadius: 0.0,
//                       offset: Offset(0, 4.0),
//                     )
//                   ],
//                 ),
//                 child:
//                     // Swiper(
//                     //   // autoplay: true,
//                     //   // curve: Curves.elasticIn,
//                     //   itemWidth: 5000,
//                     //   itemHeight: 3000,
//                     //   layout: SwiperLayout.TINDER,
//                     //   itemBuilder: (BuildContext context, int i) {
//                     //     return ClipRRect(
//                     //       borderRadius: BorderRadius.all(Radius.circular(10)),
//                     //       child: CachedNetworkImage(
//                     //         fit: BoxFit.cover,
//                     //         imageUrl: getExploreSuggestions()[name][index]["images"]
//                     //             [i],
//                     //         // placeholder: (context, url) => Image(
//                     //         //     image: AssetImage("assets/images/mountains.jpg"),
//                     //         //     fit: BoxFit.cover),
//                     //         errorWidget: (context, url, error) => Image(
//                     //           image: AssetImage("assets/images/mountains.jpg"),
//                     //           fit: BoxFit.cover,
//                     //         ),
//                     //       ),
//                     //     );
//                     //   },
//                     //   itemCount:
//                     //       getExploreSuggestions()[name][index]["images"].length,
//                     //   viewportFraction: 1,
//                     //   scale: 1,
//                     // ),
//                     CachedNetworkImage(
//                   fit: BoxFit.cover,
//                   imageUrl: getExploreSuggestions()[name][index]["images"][0],
//                   placeholder: (context, url) => Container(
//                     width: 10000,
//                     height: 10000,
//                     color: CustomColors.lightGrey,
//                   ),
//                   errorWidget: (context, url, error) => Image(
//                       image: AssetImage("assets/images/mountains.jpg"),
//                       fit: BoxFit.cover),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

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
