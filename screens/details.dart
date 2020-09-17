import 'package:auto_size_text/auto_size_text.dart';
import 'package:blimp/configurations.dart';
import 'package:blimp/model/preferences.dart';
import 'package:blimp/model/properties.dart';
import 'package:blimp/routes.dart';
import 'package:blimp/screens/activityDetails.dart';
import 'package:blimp/screens/explore.dart';
import 'package:blimp/screens/results/results.dart';
import 'package:blimp/screens/settings.dart';
import 'package:blimp/screens/user/trips.dart';
import 'package:blimp/services/http.dart';
import 'package:blimp/services/suggestions.dart';
import 'package:blimp/services/util.dart';
import 'package:blimp/styles/colors.dart';
import 'package:blimp/widgets/alerts.dart';
import 'package:blimp/widgets/buttons.dart';
import 'package:blimp/widgets/icons.dart';
import 'package:blimp/widgets/loading.dart';
import 'package:blimp/widgets/selectors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:blimp/widgets/date_range_picker.dart' as DateRangePicker;

class DetailsPage extends StatefulWidget {
  final Map cityDetails;
  final bool quickView;
  DetailsPage({this.cityDetails, this.quickView});
  @override
  State<StatefulWidget> createState() {
    return DetailsPageState(cityDetails: cityDetails, quickView: quickView);
  }
}

class DetailsPageState extends State<DetailsPage> {
  Map cityDetails;
  bool quickView;
  DetailsPageState({this.cityDetails, this.quickView});
  ScrollController _scrollController;
  int _currentIndex;
  bool _needsToSetState = true;
  bool _isShowingTitle = true;
  double kExpandedHeight;

  bool get _showTitle {
    return quickView ||
        (_scrollController.hasClients &&
            _scrollController.offset > kExpandedHeight - kToolbarHeight);
  }

  @override
  void initState() {
    super.initState();
    kExpandedHeight = !quickView ? 300.0 : 30.0;
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
                    // shape: ContinuousRectangleBorder(
                    //   side: _showTitle && !quickView
                    //       ? BorderSide(color: CustomColors.lightGrey, width: 4)
                    //       : BorderSide.none,
                    // ),
                    leading: _showTitle
                        ? Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: IconButton(
                              icon: Icon(
                                quickView ? Icons.close : Icons.arrow_back,
                                color: Theme.of(context).primaryColor,
                                size: 30,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          )
                        : null,
                    actions: _showTitle
                        ? <Widget>[
                            Padding(
                              padding: EdgeInsets.only(right: 20, top: 10),
                              child: AnimatedButton(
                                key: Key("smallShare"),
                                // callback: () => clickFeedback(context),
                                child: Icon(
                                  Icons.share,
                                  color: Theme.of(context).primaryColor,
                                  size: 30,
                                ),
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
                    elevation: !quickView ? 15 : 0,
                    pinned: true,
                    floating: false,
                    bottom: PreferredSize(
                      preferredSize: Size.fromHeight(10.0),
                      child: Text(''),
                    ),
                    onStretchTrigger: () {
                      return;
                    },
                    expandedHeight: kExpandedHeight,
                    flexibleSpace: quickView == false
                        ? Stack(
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline3,
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
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          imageUrl: cityDetails["images"]
                                              [index],
                                          placeholder: (context, url) =>
                                              Container(
                                            height: 10000,
                                            width: 10000,
                                            color: CustomColors.lightGrey,
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Image(
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
                          )
                        : Container(
                            height: 0,
                            width: 0,
                          ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom:
                              cityDetails["validDates"].length > 0 && !quickView
                                  ? 120
                                  : 30),
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
              child: cityDetails["validDates"].length > 0 && !quickView
                  ? DetailsFindHolidayBar(
                      cityDetails: cityDetails,
                    )
                  : Container(
                      height: 0,
                      width: 0,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailsFindHolidayBar extends StatefulWidget {
  final Map cityDetails;

  DetailsFindHolidayBar({this.cityDetails});
  @override
  State<StatefulWidget> createState() {
    List<Map<String, DateTime>> validDates = [];
    for (Map vd in cityDetails["validDates"]) {
      validDates.add({
        "departureDate": DateTime.parse(vd["departureDate"]),
        "returnDate": DateTime.parse(vd["returnDate"])
      });
    }

    DateTime departureDate = validDates[0]["departureDate"];
    DateTime returnDate = validDates[0]["returnDate"];
    Travellers travellers = Travellers(adults: 2);

    return DetailsFindHolidayBarState(
      cityDetails: cityDetails,
      departureDate: departureDate,
      returnDate: returnDate,
      travellers: travellers,
      validDates: validDates,
    );
  }
}

class DetailsFindHolidayBarState extends State<DetailsFindHolidayBar> {
  Map cityDetails;
  DateTime departureDate;
  DateTime returnDate;
  Travellers travellers;
  List<Map<String, DateTime>> validDates;
  DetailsFindHolidayBarState({
    this.cityDetails,
    this.departureDate,
    this.returnDate,
    this.travellers,
    this.validDates,
  });

  String getTravellersText() {
    String text = "";
    if (travellers.adults > 0) {
      text += travellers.adults.toString() + " adults";
    }
    if (travellers.children > 0) {
      text += ", " + travellers.children.toString() + " children";
    }
    return text;
  }

  void updateDetails(Map values) {
    setState(() {
      travellers = values["travellers"];
      departureDate = values["departureDate"];
      returnDate = values["returnDate"];
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
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
        padding: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.grey.withOpacity(0.4),
                  //     blurRadius: 10.0,
                  //     offset: Offset(0, 5),
                  //   ),
                  // ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.users,
                            size: 15,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              getTravellersText(),
                              style: Theme.of(context).textTheme.headline1,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Row(
                          children: [
                            Icon(
                              FontAwesomeIcons.calendar,
                              size: 15,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                DateFormat("d MMM").format(departureDate) +
                                    " - " +
                                    DateFormat("d MMM").format(returnDate),
                                style: Theme.of(context).textTheme.headline1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: AnimatedButton(
                          callback: () {
                            showDialog(
                                context: context,
                                barrierColor: CustomColors.dialogBackground,
                                builder: (BuildContext context) {
                                  return ChangeHolidayOptions(
                                    travellers: travellers,
                                    departureDate: departureDate,
                                    returnDate: returnDate,
                                    validDates: validDates,
                                    callback: updateDetails,
                                  );
                                });
                          },
                          child: Text(
                            "Change",
                            style: Theme.of(context)
                                .textTheme
                                .headline2
                                .copyWith(
                                    color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            AnimatedButton(
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
                    .removeWhere((c) => c.property == "travellers");
                prefs.constraints.add(Constraint("departure_date",
                    DateFormat('yyyy-MM-dd').format(departureDate)));
                prefs.constraints.add(Constraint("return_date",
                    DateFormat('yyyy-MM-dd').format(returnDate)));
                prefs.constraints.add(Constraint("travellers", travellers));
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
                  // showDialog(
                  //   context: context,
                  //   builder: (BuildContext context) => CustomDialog(
                  //     title: "Error",
                  //     description: "Can't get holiday - " + e.toString(),
                  //   ),
                  // );
                  showErrorToast(context, "No flights found");
                });
              },
              child: Container(
                child: Padding(
                  padding:
                      EdgeInsets.only(top: 20, bottom: 20, left: 40, right: 40),
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
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.4),
                      blurRadius: 10.0,
                      offset: Offset(0, 10),
                    )
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

class ChangeHolidayOptions extends StatefulWidget {
  final Travellers travellers;
  final DateTime departureDate;
  final DateTime returnDate;
  final Function callback;
  final List<Map<String, DateTime>> validDates;
  ChangeHolidayOptions({
    this.travellers,
    this.departureDate,
    this.returnDate,
    this.validDates,
    this.callback,
  });

  @override
  State<StatefulWidget> createState() {
    return ChangeHolidayOptionsState(
      callback: callback,
      travellers: travellers,
      departureDate: departureDate,
      returnDate: returnDate,
      validDates: validDates,
    );
  }
}

class ChangeHolidayOptionsState extends State<ChangeHolidayOptions> {
  Travellers travellers;
  DateTime departureDate;
  DateTime returnDate;
  Function callback;
  List<Map<String, DateTime>> validDates;
  ChangeHolidayOptionsState({
    this.travellers,
    this.departureDate,
    this.returnDate,
    this.validDates,
    this.callback,
  });

  void updateNumTravellers(String travellerType, String action) {
    setState(() {
      if (travellerType == "Adults") {
        if (action == "fewer" && travellers.adults > 0) {
          travellers.adults -= 1;
        } else if (action == "more" && travellers.adults < 9) {
          travellers.adults += 1;
        }
      } else if (travellerType == "Children") {
        if (action == "fewer" && travellers.children > 0) {
          travellers.children -= 1;
        } else if (action == "more" && travellers.children < 9) {
          travellers.children += 1;
        }
      }
    });
  }

  void updateNumChildren(int numChildren) {
    setState(() {
      travellers.children = numChildren;
    });
  }

  void updateDates(List<DateTime> picked) {
    setState(() {
      departureDate = picked[0];
      returnDate = picked[1];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        // height: 400,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: <Widget>[
                  IconBox(
                    icon: FontAwesomeIcons.users,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: TravellerNumberChoice(
                      travellerType: "Adults",
                      numTravellers: travellers.adults,
                      callback: updateNumTravellers,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Row(
                  children: <Widget>[
                    IconBox(
                      icon: FontAwesomeIcons.child,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: TravellerNumberChoice(
                        travellerType: "Children",
                        numTravellers: travellers.children,
                        callback: updateNumTravellers,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () async {
                    final List<DateTime> picked =
                        await DateRangePicker.showDatePicker(
                      context: context,
                      initialFirstDate: departureDate,
                      initialLastDate: returnDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(Duration(days: 90)),
                      selectableDayPredicate: (day, firstDay, lastDay) {
                        if (firstDay == null) {
                          return isDateAllowed(
                              day,
                              validDates
                                  .map((vd) => vd["departureDate"])
                                  .toList());
                        } else if (lastDay == null) {
                          return isDateAllowed(
                              day,
                              validDates
                                  .where((vd) => areDatesEqual(
                                      vd["departureDate"], firstDay))
                                  .map((vd) => vd["returnDate"])
                                  .toList());
                        } else {
                          return isDateAllowed(
                              day,
                              validDates
                                  .map((vd) => vd["departureDate"])
                                  .toList());
                        }
                      },
                    );
                    if (picked != null && picked.length == 2) {
                      updateDates(picked);
                    }
                  },
                  child: Row(
                    children: <Widget>[
                      IconBox(
                        icon: Icons.calendar_today,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: DatesSelector(
                          outboundDate: departureDate,
                          returnDate: returnDate,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: AnimatedButton(
                  callback: () {
                    Navigator.pop(context);
                    callback({
                      "travellers": travellers,
                      "departureDate": departureDate,
                      "returnDate": returnDate
                    });
                  },
                  child: GenericSaveButton(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GenericSaveButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.2),
            blurRadius: 10.0,
            offset: Offset(0, 10),
          )
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Text(
            "Save",
            style: Theme.of(context)
                .textTheme
                .button
                .copyWith(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
      ),
    );
  }
}

class TravellerNumberChoice extends StatelessWidget {
  final String travellerType;
  final int numTravellers;
  final Function callback;
  TravellerNumberChoice({
    this.travellerType,
    this.numTravellers,
    this.callback,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          travellerType,
          // style: Theme.of(context).textTheme.headline1,
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Row(
            children: [
              AnimatedButton(
                callback: () {
                  callback(travellerType, "fewer");
                },
                child: Icon(
                  FontAwesomeIcons.minusCircle,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  numTravellers.toString(),
                  style: Theme.of(context).textTheme.headline2,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 15),
                child: AnimatedButton(
                  callback: () {
                    callback(travellerType, "more");
                  },
                  child: Icon(
                    FontAwesomeIcons.plusCircle,
                    color: Theme.of(context).primaryColor,
                    size: 20,
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
                  percent: cityDetails["culture"] / 10,
                  lineWidth: 10,
                  animationDuration: 1000,
                  circularStrokeCap: CircularStrokeCap.round,
                  animation: true,
                  center: Text(
                    cityDetails["culture"].toStringAsFixed(1),
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  footer: Text(
                    "Culture",
                    style: Theme.of(context).textTheme.headline1,
                  ),
                ),
                CircularPercentIndicator(
                  radius: 60,
                  percent: cityDetails["shopping"] / 10,
                  lineWidth: 10,
                  animationDuration: 1000,
                  circularStrokeCap: CircularStrokeCap.round,
                  animation: true,
                  center: Text(
                    cityDetails["shopping"].toStringAsFixed(1),
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  footer: Text(
                    "Shopping",
                    style: Theme.of(context).textTheme.headline1,
                  ),
                ),
                CircularPercentIndicator(
                  radius: 60,
                  percent: cityDetails["nightlife"] / 10,
                  lineWidth: 10,
                  animationDuration: 1000,
                  circularStrokeCap: CircularStrokeCap.round,
                  animation: true,
                  center: Text(
                    cityDetails["nightlife"].toStringAsFixed(1),
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
                  itemCount: cityDetails["similarDestinations"].length,
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
