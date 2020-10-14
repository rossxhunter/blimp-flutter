import 'dart:async';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:blimp/screens/results/accommodationRooms.dart';
import 'package:blimp/services/suggestions.dart';
import 'package:blimp/styles/colors.dart';
import 'package:blimp/widgets/buttons.dart';
import 'package:blimp/widgets/text_displays.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:recase/recase.dart';

class AccommodationDetails extends StatefulWidget {
  final Map details;
  final int index;
  final Function callback;
  AccommodationDetails({this.details, this.index, this.callback});
  @override
  State<StatefulWidget> createState() {
    return AccommodationDetailsState(details: details);
  }
}

class AccommodationDetailsState extends State<AccommodationDetails> {
  Map details;
  AccommodationDetailsState({this.details});
  ScrollController _scrollController;
  double kExpandedHeight = 300.0;
  bool get _showTitle {
    return _scrollController.hasClients &&
        _scrollController.offset > kExpandedHeight - kToolbarHeight;
  }

  bool _isShowingTitle = true;

  Set validAmenities = {
    "Restaurant",
    "Massage",
    "Swimming Pool",
    "Spa",
    "Fitness Center",
    "Air Conditioning",
    "Parking",
    "Pets Allowed",
    "Airport Shuttle",
    "Business Center",
    "Disabled Facilities",
    "Wifi",
    "Meeting Rooms",
    "Tennis",
    "Golf",
    "Kitchen",
    "Animal Watching",
    "Baby Sitting",
    "Beach",
    "Casino",
    "Jacuzzi",
    "Sauna",
    "Solarium",
    "Valet Parking",
    "Bar",
    "Minibar",
    "Television",
    "Wifi in Room",
    "Room Service",
    "No Kids Allowed",
    "Guarded Parking"
  };

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
  void updateRoom(Map newOffer) {
    setState(() {
      details["selectedOffer"] = newOffer;
    });
    widget.callback(widget.index, newOffer);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.greyBackground,
      body: Stack(
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
                  //   side: _showTitle
                  //       ? BorderSide(color: CustomColors.lightGrey, width: 4)
                  //       : BorderSide.none,
                  // ),
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
                              FontAwesomeIcons.arrowLeft,
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
                              FontAwesomeIcons.arrowLeft,
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
                                    top: 0, left: 50, right: 10, bottom: 0),
                                child: AutoSizeText(
                                  ReCase(details["name"]).titleCase,
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
                            details["images"].length == 0
                                ? Image(
                                    image: AssetImage(
                                        "assets/images/mountains.jpg"),
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
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl: details["images"][index],
                                        errorWidget: (context, url, error) =>
                                            Image(
                                          image: NetworkImage(details["images"]
                                                  [index] +
                                              "G.JPEG"),
                                          fit: BoxFit.cover,
                                        ),
                                        placeholder: (context, url) =>
                                            Container(
                                          height: 10000,
                                          width: 10000,
                                          color: CustomColors.lightGrey,
                                        ),
                                      );
                                    },
                                    itemCount:
                                        min(details["images"].length, 15),
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
                          AccommodationInfo(
                            name: details["name"],
                            stars: details["stars"],
                            distance: details["hotelDistance"],
                            address: details["address"],
                          ),
                          details["description"] != null
                              ? Padding(
                                  padding: EdgeInsets.only(top: 20),
                                  child: HotelDescriptionSection(
                                    description: details["description"],
                                  ),
                                )
                              : Container(
                                  width: 0,
                                  height: 0,
                                ),
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: HotelRatingsSection(
                              ratings: details["rating"],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: AmenitiesSection(
                              amenities: (details["amenities"].toSet())
                                  .intersection(validAmenities)
                                  .toList(),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: HotelLocationSection(
                              latitude: details["latitude"],
                              longitude: details["longitude"],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned.fill(
            top: null,
            child: PriceAndRoomsBar(
              price: details["selectedOffer"]["price"],
              offers: details["offers"],
              selectedOfferId: details["selectedOffer"]["id"],
              callback: updateRoom,
            ),
          ),
        ],
      ),
    );
  }
}

class HotelRatingsSection extends StatelessWidget {
  final Map ratings;
  HotelRatingsSection({this.ratings});
  @override
  Widget build(BuildContext context) {
    List r = ratings.entries.map((entry) => [entry.key, entry.value]).toList();
    r.removeWhere((element) => element[1] == null);
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Ratings",
              style: Theme.of(context).textTheme.headline3,
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                removeBottom: true,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: HotelRatingBar(
                          ratingType: r[index][0], rating: r[index][1]),
                    );
                  },
                  itemCount: r.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HotelRatingBar extends StatelessWidget {
  final String ratingType;
  final int rating;
  HotelRatingBar({this.ratingType, this.rating});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              ReCase(ratingType).titleCase,
              style: Theme.of(context).textTheme.headline2,
            ),
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: Text(
                rating.toString(),
                style: Theme.of(context).textTheme.headline2,
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: 5),
          child: LinearPercentIndicator(
            percent: rating / 100,
            lineHeight: 10,
          ),
        ),
      ],
    );
  }
}

class HotelLocationSection extends StatelessWidget {
  final double latitude;
  final double longitude;
  HotelLocationSection({this.latitude, this.longitude});
  final Completer<GoogleMapController> _controller = Completer();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Location",
              style: Theme.of(context).textTheme.headline3,
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  // decoration: BoxDecoration(
                  //   borderRadius: BorderRadius.circular(20),
                  // ),
                  height: 300,
                  child: GoogleMap(
                    mapType: MapType.normal,
                    markers: {
                      Marker(
                          markerId: MarkerId("hotel"),
                          icon: BitmapDescriptor.defaultMarker,
                          position: LatLng(latitude, longitude))
                    },
                    initialCameraPosition: CameraPosition(
                      target: LatLng(latitude, longitude),
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
    );
  }
}

class HotelDescriptionSection extends StatelessWidget {
  final String description;
  HotelDescriptionSection({this.description});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Description",
              style: Theme.of(context).textTheme.headline3,
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: DescriptionTextWidget(
                text: description,
                // style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PriceAndRoomsBar extends StatelessWidget {
  final Map price;
  final List offers;
  final String selectedOfferId;
  final Function callback;
  PriceAndRoomsBar(
      {this.price, this.offers, this.selectedOfferId, this.callback});
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Total",
                      style: Theme.of(context).textTheme.headline1,
                      textAlign: TextAlign.left,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text(
                        NumberFormat.currency(
                                name: price["currency"],
                                symbol: suggestions.getCurrencySuggestions()[
                                    price["currency"]]["symbol"])
                            .format(price["amount"]),
                        style: Theme.of(context).textTheme.headline4,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.downToUp,
                        child: AccommodationRooms(
                          offers: offers,
                          selectedOption: selectedOfferId,
                          callback: callback,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 15, bottom: 15, left: 15, right: 15),
                      child: Text(
                        "View Rooms",
                        style: Theme.of(context)
                            .textTheme
                            .headline2
                            .copyWith(color: Theme.of(context).primaryColor),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: CustomColors.lightGrey,
                        width: 4,
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

class AmenitiesSection extends StatelessWidget {
  final List amenities;
  AmenitiesSection({this.amenities});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Amenities",
              style: Theme.of(context).textTheme.headline3,
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: MediaQuery.removePadding(
                context: context,
                removeBottom: true,
                removeTop: true,
                child: GridView.builder(
                  itemCount: amenities.length,
                  itemBuilder: (context, index) {
                    return AmenityBox(amenity: amenities[index]);
                  },
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2,
                  ),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AmenityBox extends StatelessWidget {
  final String amenity;
  AmenityBox({this.amenity});

  Map amenityIcon = {
    "Restaurant": FontAwesomeIcons.utensils,
    "Massage": FontAwesomeIcons.hands,
    "Parking": FontAwesomeIcons.parking,
    "Spa": FontAwesomeIcons.spa,
    "Swimming Pool": FontAwesomeIcons.swimmingPool,
    "Air Conditioning": FontAwesomeIcons.wind,
    "Wifi": FontAwesomeIcons.wifi,
    "Sauna": FontAwesomeIcons.spa,
    "Minibar": FontAwesomeIcons.glassCheers,
    "Television": FontAwesomeIcons.tv,
    "Business Center": FontAwesomeIcons.briefcase,
    "Meeting Rooms": FontAwesomeIcons.businessTime,
    "Disabled Facilities": FontAwesomeIcons.wheelchair,
    "Fitness Center": FontAwesomeIcons.dumbbell,
    "Room Service": FontAwesomeIcons.conciergeBell,
    "Wifi in Room": FontAwesomeIcons.wifi,
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          amenityIcon[amenity],
          size: 30,
          color: Theme.of(context).primaryColor,
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            amenity,
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
      ],
    );
  }
}

class AccommodationInfo extends StatelessWidget {
  final String name;
  final int stars;
  final Map distance;
  final Map address;
  AccommodationInfo({this.name, this.stars, this.distance, this.address});

  String _formatStreetAddress(String streetAddress) {
    String formattedAddress = "";
    List<String> lines = streetAddress.split("\n");
    for (String line in lines) {
      if (formattedAddress != "") {
        formattedAddress += "\n";
      }
      formattedAddress += ReCase(line).titleCase;
    }
    return formattedAddress;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ReCase(name).titleCase,
              style: Theme.of(context).textTheme.headline4,
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  Icon(
                    FontAwesomeIcons.solidStar,
                    size: 20,
                    color: Colors.orange,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      stars.toString() + " stars",
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  Icon(
                    FontAwesomeIcons.mapMarkerAlt,
                    size: 20,
                    color: Colors.blue,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      distance["distance"].toString() +
                          " " +
                          distance["distanceUnit"].toLowerCase() +
                          " from center",
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    FontAwesomeIcons.locationArrow,
                    size: 20,
                    color: Theme.of(context).primaryColor,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      _formatStreetAddress(address["streetAddress"]) +
                              address["postcode"] ??
                          "",
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
