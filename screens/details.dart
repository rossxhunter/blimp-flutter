import 'package:auto_size_text/auto_size_text.dart';
import 'package:blimp/configurations.dart';
import 'package:blimp/model/preferences.dart';
import 'package:blimp/routes.dart';
import 'package:blimp/screens/activityDetails.dart';
import 'package:blimp/screens/explore.dart';
import 'package:blimp/screens/results.dart';
import 'package:blimp/screens/trips.dart';
import 'package:blimp/services/http.dart';
import 'package:blimp/services/suggestions.dart';
import 'package:blimp/styles/colors.dart';
import 'package:blimp/widgets/alerts.dart';
import 'package:blimp/widgets/buttons.dart';
import 'package:blimp/widgets/loading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DetailsPage extends StatefulWidget {
  final Map cityDetails;
  final List imageURLs;
  DetailsPage({this.cityDetails, this.imageURLs});
  @override
  State<StatefulWidget> createState() {
    return DetailsPageState(cityDetails: cityDetails, imageURLs: imageURLs);
  }
}

class DetailsPageState extends State<DetailsPage> {
  List imageURLs;
  Map cityDetails;
  DetailsPageState({this.cityDetails, this.imageURLs});
  ScrollController _scrollController;
  int _currentIndex;
  bool _needsToSetState = true;
  bool _isShowingTitle = true;
  double kExpandedHeight = 300.0;
  bool get _showTitle {
    return _scrollController.hasClients &&
        _scrollController.offset > kExpandedHeight - kToolbarHeight;
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_isShowingTitle != _showTitle) {
          setState(() {
            _isShowingTitle = _showTitle;
          });
        }
      });
    _currentIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Stack(
          children: <Widget>[
            PrimaryScrollController(
              controller: _scrollController,
              child: CustomScrollView(
                primary: true,
                // controller: _scrollController,
                physics: AlwaysScrollableScrollPhysics(),
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
                            Padding(
                              padding: EdgeInsets.only(right: 20),
                              child: AnimatedButton(
                                key: Key("smallShare"),
                                // callback: () => clickFeedback(context),
                                child: Icon(Icons.share,
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                            // Padding(
                            //   padding: EdgeInsets.only(left: 20, right: 20),
                            //   child: AnimatedButton(
                            //     key: Key("smallOptions"),
                            //     child: Icon(
                            //       Icons.sort,
                            //       color: Theme.of(context).primaryColor,
                            //     ),
                            //     callback: () {},
                            //   ),
                            // ),
                          ]
                        : <Widget>[
                            Padding(
                              padding: EdgeInsets.only(right: 20),
                              child: AnimatedButton(
                                key: Key("largeShare"),
                                // callback: () => clickFeedback(context),
                                child: Icon(
                                  Icons.share,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ),
                            // Padding(
                            //   padding: EdgeInsets.only(left: 20, right: 20),
                            //   child: AnimatedButton(
                            //     key: Key("largeOptions"),
                            //     child: Icon(
                            //       Icons.sort,
                            //       color: Colors.white,
                            //       size: 30,
                            //     ),
                            //     callback: () {},
                            //   ),
                            // ),
                          ],
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
                                  cityDetails["name"],
                                  style: Theme.of(context).textTheme.headline3,
                                )
                              : null,
                          collapseMode: CollapseMode.parallax,
                          background: Stack(
                            fit: StackFit.expand,
                            children: [
                              Swiper(
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
                                itemBuilder: (BuildContext context, int index) {
                                  return CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: cityDetails["images"][index],
                                    placeholder: (context, url) => Container(
                                      height: 10000,
                                      width: 10000,
                                      color: CustomColors.lightGrey,
                                    ),
                                    errorWidget: (context, url, error) => Image(
                                      image: AssetImage(
                                          "assets/images/mountains.jpg"),
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                },
                                itemCount: cityDetails["images"].length,
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
                      child: DestinationDetails(
                        cityDetails: cityDetails,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned.fill(
              top: null,
              child: DetailsFindHolidayBar(
                cityDetails: cityDetails,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailsFindHolidayBar extends StatelessWidget {
  final Map cityDetails;
  DetailsFindHolidayBar({this.cityDetails});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 100,
          width: 1000,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                blurRadius: 10.0,
                offset: Offset(0, 0),
              )
            ],
            // border: Border.all(
            //   color: CustomColors.lightGrey,
            //   width: 3,
            // ),
          ),
          child: Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          blurRadius: 10.0,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Text(
                        "2 adults, cheapest dates",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: AnimatedButton(
                    callback: () {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return LoadingIndicator();
                          });
                      Preferences prefs = prefsConfig[0];
                      prefs.constraints
                          .removeWhere((c) => c.property == "departure_date");
                      prefs.constraints
                          .removeWhere((c) => c.property == "return_date");
                      prefs.constraints
                          .removeWhere((c) => c.property == "destination");
                      prefs.constraints
                          .add(Constraint("departure_date", "2020-10-27"));
                      prefs.constraints
                          .add(Constraint("return_date", "2020-10-30"));
                      prefs.constraints.add(
                        Constraint(
                          "destination",
                          {"type": "city", "id": cityDetails["id"]},
                        ),
                      );
                      getHoliday(prefs).then((holiday) {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ResultsPageRoute(holiday, prefs).page(),
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
                    child: Container(
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 20, bottom: 20, left: 40, right: 40),
                        child: Text(
                          "Find Holiday",
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
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class DestinationDetails extends StatelessWidget {
  Map cityDetails;

  DestinationDetails({this.cityDetails});

  YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: 'iLnmTe5Q2Qw',
    flags: YoutubePlayerFlags(
      autoPlay: true,
      mute: true,
    ),
  );
  @override
  Widget build(BuildContext context) {
    var parser = EmojiParser();
    return Padding(
      padding: EdgeInsets.only(left: 30, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            cityDetails["name"] +
                " " +
                parser
                    .get("flag-" + cityDetails["country_code"].toLowerCase())
                    .code,
            style: Theme.of(context).textTheme.headline4,
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              cityDetails["description"],
              style: Theme.of(context).textTheme.headline1,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              "Read More",
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                CircularPercentIndicator(
                  radius: 60,
                  percent: 0.6,
                  lineWidth: 10,
                  animationDuration: 1000,
                  circularStrokeCap: CircularStrokeCap.round,
                  animation: true,
                  center: Text(
                    "6.7",
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  footer: Text(
                    "Culture",
                    style: Theme.of(context).textTheme.headline1,
                  ),
                ),
                CircularPercentIndicator(
                  radius: 60,
                  percent: 0.6,
                  lineWidth: 10,
                  animationDuration: 1000,
                  circularStrokeCap: CircularStrokeCap.round,
                  animation: true,
                  center: Text(
                    "6.7",
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  footer: Text(
                    "Shopping",
                    style: Theme.of(context).textTheme.headline1,
                  ),
                ),
                CircularPercentIndicator(
                  radius: 60,
                  percent: 0.6,
                  lineWidth: 10,
                  animationDuration: 1000,
                  circularStrokeCap: CircularStrokeCap.round,
                  animation: true,
                  center: Text(
                    "6.7",
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
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Column(
              children: [
                QuickDetailsBox(
                  field: "Summer Temperature",
                  value: cityDetails["temperature"].round().toString() + "°C",
                  backgroundColor: Colors.red.withOpacity(0.2),
                  icon: Icons.wb_sunny,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: QuickDetailsBox(
                    field: "Spoken Language",
                    value: cityDetails["language"],
                    backgroundColor: Colors.green.withOpacity(0.2),
                    icon: FontAwesomeIcons.language,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: QuickDetailsBox(
                    field: "Currency",
                    value: cityDetails["currency"],
                    backgroundColor: Colors.blue.withOpacity(0.2),
                    icon: FontAwesomeIcons.moneyBill,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: QuickDetailsBox(
                    field: "Population",
                    value: NumberFormat.compact(locale: "en_GB")
                        .format(cityDetails["population"]),
                    backgroundColor: Colors.orange.withOpacity(0.2),
                    icon: Icons.people,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Top Attractions",
                  style: Theme.of(context).textTheme.headline3,
                ),
                Text(
                  "See All",
                  style: Theme.of(context).textTheme.headline2,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 20,
            ),
            child: Container(
              height: 400,
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: ListView.builder(
                  primary: false,
                  itemCount: 5,
                  // itemExtent: 100,
                  // shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.only(
                          bottom: 20, left: 10, right: 10, top: 10),
                      child: Row(
                        children: [
                          Text(
                            (index + 1).toString(),
                            style: Theme.of(context)
                                .textTheme
                                .headline3
                                .copyWith(
                                    color: Theme.of(context).primaryColor),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: 20,
                              ),
                              child: ActivityListOption(
                                activity: cityDetails["attractions"][index],
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
          ),
          // Padding(
          //   padding: EdgeInsets.only(top: 50),
          //   child: Text(
          //     "Videos",
          //     style: Theme.of(context).textTheme.headline3,
          //   ),
          // ),
          // Padding(
          //   padding: EdgeInsets.only(top: 20),
          //   child: Container(
          //     height: 300,
          //     child: Swiper(
          //       onIndexChanged: (value) {
          //         // setState(() {
          //         //   _currentIndex = value;
          //         // });
          //       },
          //       // pagination: SwiperPagination(
          //       //   alignment: Alignment.topCenter,
          //       //   margin: EdgeInsets.only(left: 10, right: 10, top: 40),
          //       // ),
          //       control: SwiperControl(
          //         padding: EdgeInsets.only(bottom: 5000),
          //       ),
          //       itemWidth: 300,
          //       itemBuilder: (BuildContext context, int index) {
          //         return Column(
          //           children: [
          //             Text(
          //               "Video 1",
          //               style: Theme.of(context).textTheme.headline3,
          //             ),
          //             // Padding(
          //             //   padding: EdgeInsets.only(top: 30),
          //             //   child: YoutubePlayer(
          //             //     controller: _controller,
          //             //     showVideoProgressIndicator: true,
          //             //     progressIndicatorColor: Colors.amber,
          //             //     progressColors: ProgressBarColors(
          //             //       playedColor: Colors.amber,
          //             //       handleColor: Colors.amberAccent,
          //             //     ),
          //             //     onReady: () {
          //             //       // _controller.addListener();
          //             //     },
          //             //   ),
          //             // ),
          //           ],
          //         );
          //       },
          //       itemCount: 3,
          //       viewportFraction: 1,
          //       scale: 0.5,
          //     ),
          //   ),
          // ),
          Padding(
            padding: EdgeInsets.only(top: 50),
            child: Text(
              "Similar Destinations",
              style: Theme.of(context).textTheme.headline3,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Container(
              height: 340,
              child: MediaQuery.removePadding(
                context: context,
                removeLeft: true,
                child: ListView.builder(
                  itemCount: getExploreSuggestions()["Europe"].length,
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return DestinationOption(
                      option: cityDetails["similarDestinations"][index],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SimilarDestinationOption extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
      child: Container(
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
                      "Paris",
                      maxLines: 1,
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Row(
                        children: [
                          Text(
                            "🇫🇷",
                            style: Theme.of(context).textTheme.headline3,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              "France",
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

class ActivityListOption extends StatefulWidget {
  final Map activity;
  ActivityListOption({this.activity});
  @override
  State<StatefulWidget> createState() {
    return ActivityListOptionState(activity: activity);
  }
}

class ActivityListOptionState extends State<ActivityListOption> {
  final Map activity;
  ActivityListOptionState({this.activity});

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
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              blurRadius: 10.0,
              spreadRadius: 0,
              offset: Offset(0, 0),
            )
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 0, bottom: 0, right: 0),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                child: Container(
                  width: 100,
                  height: 100,
                  child: CachedNetworkImage(
                    placeholder: (context, url) => Container(
                      width: 100,
                      height: 100,
                      color: CustomColors.lightGrey,
                    ),
                    imageUrl: activity["bestPhoto"],
                    fit: BoxFit.cover,
                  ),
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
                    // Text(
                    //   time,
                    //   style: Theme.of(context).textTheme.headline1,
                    // ),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text(
                        activity["name"],
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
                                activity["category"],
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
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.yellow,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Text(
                              activity["rating"].toString() + "/5",
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
      ),
    );
  }
}

class QuickDetailsBox extends StatelessWidget {
  final String field;
  final String value;
  final Color backgroundColor;
  final IconData icon;
  QuickDetailsBox({this.field, this.value, this.backgroundColor, this.icon});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              icon,
              color: backgroundColor.withOpacity(1),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    AutoSizeText(
                      value,
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .headline3
                          .copyWith(color: backgroundColor.withOpacity(1)),
                    ),
                    Text(
                      field,
                      style: Theme.of(context).textTheme.headline2.copyWith(
                            color: Color.fromRGBO(20, 20, 60, 1),
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
