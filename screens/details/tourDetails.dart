import 'dart:async';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:blimp/screens/details/activityDetails.dart';
import 'package:blimp/services/http.dart';
import 'package:blimp/styles/colors.dart';
import 'package:blimp/widgets/buttons.dart';
import 'package:blimp/widgets/text_displays.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:recase/recase.dart';

class TourDetails extends StatefulWidget {
  final Map tour;
  TourDetails({this.tour});
  @override
  State<StatefulWidget> createState() {
    return TourDetailsState(tour: tour);
  }
}

class TourDetailsState extends State<TourDetails> {
  Map tour;
  TourDetailsState({this.tour});
  ScrollController _scrollController = ScrollController();
  double kExpandedHeight = 300.0;
  bool get _showTitle {
    return _scrollController.hasClients &&
        _scrollController.offset > kExpandedHeight - kToolbarHeight;
  }

  bool _isShowingTitle = true;

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

  int _currentIndex;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PrimaryScrollController(
        controller: _scrollController,
        child: CustomScrollView(
          primary: true,
          physics: AlwaysScrollableScrollPhysics(),
          slivers: <Widget>[
            SliverAppBar(
              titleSpacing: 0.0,
              leading: _showTitle
                  ? Padding(
                      padding: EdgeInsets.only(left: 10, bottom: 10),
                      child: AnimatedButton(
                        key: Key("smallBack"),
                        callback: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          FontAwesomeIcons.times,
                          color: Theme.of(context).primaryColor,
                          size: 20,
                        ),
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.only(left: 20, bottom: 0),
                      child: AnimatedButton(
                        key: Key("largeBack"),
                        callback: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          FontAwesomeIcons.times,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
              backgroundColor: Colors.white,
              stretch: true,
              elevation: 15,
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
                        ? Padding(
                            padding: EdgeInsets.only(
                                top: 0, left: 40, right: 10, bottom: 0),
                            child: AutoSizeText(
                              ReCase(tour["name"]).titleCase,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              minFontSize: 20,
                              style: Theme.of(context).textTheme.headline3,
                            ),
                          )
                        : null,
                    collapseMode: CollapseMode.parallax,
                    background: Stack(
                      // fit: StackFit.loose,
                      children: [
                        tour["images"].length == 0
                            ? Image(
                                image:
                                    AssetImage("assets/images/mountains.jpg"),
                                fit: BoxFit.cover)
                            : Swiper(
                                onIndexChanged: (value) {
                                  setState(() {
                                    _currentIndex = value;
                                  });
                                },
                                pagination: SwiperPagination(
                                  margin: EdgeInsets.only(
                                      left: 10, right: 10, bottom: 40),
                                ),
                                // itemWidth: 100,
                                itemBuilder: (BuildContext context, int index) {
                                  return CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: tour["images"][index],
                                    errorWidget: (context, url, error) => Image(
                                      image: AssetImage(
                                          "assets/images/mountain.jpg"),
                                      fit: BoxFit.cover,
                                    ),
                                    placeholder: (context, url) => Container(
                                      height: 10000,
                                      width: 10000,
                                      color: CustomColors.lightGrey,
                                    ),
                                  );
                                },
                                itemCount: min(tour["images"].length, 15),
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
                child: Container(
                  color: CustomColors.greyBackground,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      TourDetailsOption(
                        tour: tour,
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

class TourDetailsOption extends StatelessWidget {
  final Map tour;
  final Completer<GoogleMapController> _controller = Completer();

  TourDetailsOption({this.tour});
  @override
  Widget build(BuildContext context) {
    double lat = tour["location"] == null ? 0 : tour["location"]["latitude"];
    double lng = tour["location"] == null ? 0 : tour["location"]["longitude"];
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)),
            // border: Border.all(
            //   color: CustomColors.lightGrey,
            //   width: 4,
            // ),
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AutoSizeText(
                  tour["name"],
                  maxLines: 2,
                  style: Theme.of(context).textTheme.headline4,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            tour["category"].toUpperCase(),
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            maxLines: 2,
                            textWidthBasis: TextWidthBasis.longestLine,
                            style: Theme.of(context)
                                .textTheme
                                .headline2
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.clock,
                            size: 20,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Text(
                              tour["duration"]
                                  .substring(2, tour["duration"].length),
                              style: Theme.of(context).textTheme.headline1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: tour["pois"].length > 0,
                  child: Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Container(
                      height: 50,
                      // width: 50,
                      child: ListView.builder(
                        itemCount: tour["pois"].length,
                        scrollDirection: Axis.horizontal,
                        // itemExtent: 50,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(
                                right: 20, top: 5, bottom: 5, left: 0),
                            child: AnimatedButton(
                              callback: () {
                                getActivityDetailsFromId(
                                        tour["pois"][index]["id"])
                                    .then((details) {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.bottomToTop,
                                      child: ActivityDetails(
                                        activity: details,
                                      ),
                                    ),
                                  );
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      blurRadius: 5,
                                      offset: Offset(0, 0),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Center(
                                    child: Text(
                                      tour["pois"][index]["name"],
                                      style:
                                          Theme.of(context).textTheme.headline2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Description",
                        style: Theme.of(context).textTheme.headline3,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: DescriptionTextWidget(
                          text: tour["description"] + "\n\n" + tour["about"],
                          // style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: tour["location"] != null,
                  child: Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Location",
                          style: Theme.of(context).textTheme.headline3,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              height: 300,
                              child: GoogleMap(
                                mapType: MapType.normal,
                                markers: {
                                  Marker(
                                      markerId: MarkerId("hotel"),
                                      icon: BitmapDescriptor.defaultMarker,
                                      position: LatLng(lat, lng))
                                },
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(lat, lng),
                                  zoom: 15,
                                ),
                                // cameraTargetBounds: CameraTargetBounds(
                                //   LatLngBounds(
                                //     northeast: LatLng(latitude, longitude),
                                //     southwest: LatLng(latitude, longitude),
                                //   ),
                                // ),
                                onMapCreated: (GoogleMapController controller) {
                                  _controller.complete(controller);
                                },
                              ),
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
      ],
    );
  }
}
