import 'dart:async';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:blimp/screens/details/details.dart';
import 'package:blimp/services/http.dart';
import 'package:blimp/services/images.dart';
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

class ActivityDetails extends StatefulWidget {
  final Map activity;
  ActivityDetails({this.activity});
  @override
  State<StatefulWidget> createState() {
    return ActivityDetailsState(activity: activity);
  }
}

class ActivityDetailsState extends State<ActivityDetails> {
  Map activity;
  ActivityDetailsState({this.activity});
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
                              ReCase(activity["name"]).titleCase,
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
                        activity["images"].length == 0
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
                                    imageUrl: activity["images"][index],
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
                                itemCount: min(activity["images"].length, 15),
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
                padding: EdgeInsets.only(bottom: 40),
                child: Container(
                  color: CustomColors.greyBackground,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      ActivityDetailsOption(
                        activity: activity,
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

class ActivityDetailsDialog extends StatelessWidget {
  final Map activity;

  ActivityDetailsDialog({this.activity});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(30),
        ),
        child: ActivityDetailsOption(
          activity: activity,
        ),
      ),
    );
  }
}

class ActivityDetailsOptionSnapshot extends StatelessWidget {
  final Map activity;

  ActivityDetailsOptionSnapshot({this.activity});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: CachedNetworkImage(
            imageUrl: activity["images"][0] ?? getDefaultActivityImageURL(),
            width: 10000,
            height: 250,
            fit: BoxFit.cover,
          ),
        ),
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
            padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  activity["name"],
                  style: Theme.of(context).textTheme.headline3,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Row(
                          children: [
                            Image(
                              image: NetworkImage(
                                activity["categoryIcon"] + "64.png",
                              ),
                              color: Colors.black,
                              height: 30,
                              width: 30,
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: Text(
                                  activity["category"],
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                  maxLines: 2,
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.lightGreen,
                            shape: BoxShape.circle,
                          ),
                          child: Visibility(
                            visible: activity["rating"] != 0,
                            child: Padding(
                              padding: EdgeInsets.all(12),
                              child: Text(
                                activity["rating"].toString(),
                                style: Theme.of(context).textTheme.button,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: activity["description"] != null &&
                      activity["description"] != "",
                  child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Description",
                          style: Theme.of(context).textTheme.headline2,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: ConstrainedBox(
                            constraints: new BoxConstraints(
                              minHeight: 0,
                              maxHeight: 100,
                            ),
                            child: SingleChildScrollView(
                              child: Text(
                                activity["description"] ??
                                    activity["name"] +
                                        " is a " +
                                        activity["category"],
                                style: Theme.of(context).textTheme.bodyText2,
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

class ActivityDetailsOption extends StatelessWidget {
  final Map activity;

  final Completer<GoogleMapController> _controller = Completer();
  @override
  ActivityDetailsOption({this.activity});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
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
            padding: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  activity["name"],
                  style: Theme.of(context).textTheme.headline4,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Row(
                          children: [
                            Image(
                              image: NetworkImage(
                                activity["categoryIcon"] + "64.png",
                              ),
                              color: Colors.black,
                              height: 30,
                              width: 30,
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: Text(
                                  activity["category"],
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                  maxLines: 2,
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.lightGreen,
                            shape: BoxShape.circle,
                          ),
                          child: Visibility(
                            visible: activity["rating"] != 0,
                            child: Padding(
                              padding: EdgeInsets.all(12),
                              child: Text(
                                activity["rating"].toString(),
                                style: Theme.of(context).textTheme.button,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: activity["description"] != null &&
                      activity["description"] != "",
                  child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Description",
                          style: Theme.of(context).textTheme.headline3,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            activity["description"] ??
                                activity["name"] +
                                    " is a " +
                                    activity["category"],
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: activity["tickets"].length > 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: 30,
                        ),
                        child: Text(
                          "Tickets and Tours",
                          style: Theme.of(context).textTheme.headline3,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 10,
                        ),
                        child: Container(
                          height: 350,
                          child: MediaQuery.removePadding(
                            context: context,
                            removeTop: true,
                            child: ListView.builder(
                              primary: false,
                              scrollDirection: Axis.horizontal,
                              itemCount: min(activity["tickets"].length, 10),
                              // itemExtent: 100,
                              // shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      bottom: 20, left: 10, right: 10, top: 10),
                                  child: TourListOption(
                                    tour: activity["tickets"][index],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
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
                                    position: LatLng(activity["latitude"],
                                        activity["longitude"]))
                              },
                              initialCameraPosition: CameraPosition(
                                target: LatLng(activity["latitude"],
                                    activity["longitude"]),
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
              ],
            ),
          ),
        ),
      ],
    );
  }
}
