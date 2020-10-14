import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:blimp/screens/activityDetails.dart';
import 'package:blimp/styles/colors.dart';
import 'package:blimp/widgets/buttons.dart';
import 'package:blimp/widgets/map.dart';
import 'package:blimp/widgets/marker_generator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class MapScreen extends StatefulWidget {
  final Map accommodation;
  final List itinerary;
  MapScreen({this.accommodation, this.itinerary});
  @override
  State<StatefulWidget> createState() {
    return MapScreenState(accommodation: accommodation, itinerary: itinerary);
  }
}

class MapScreenState extends State<MapScreen> {
  Map accommodation;
  List itinerary;
  MapScreenState({this.accommodation, this.itinerary});
  Set<Marker> markers = {};
  Set<Marker> shownMarkers = Set();
  List<Map> markerDetails = [];
  Map<MarkerId, Map> markerProperties = {};
  List<bool> daysShown = [];
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  PersistentBottomSheetController controller;
  @override
  void initState() {
    super.initState();
    List<Widget> markerWidgets = [];
    int dayNum = 0;
    for (List day in itinerary) {
      int activityNum = 0;
      if (day.length > 0) {
        daysShown.add(true);
      } else {
        daysShown.add(false);
      }
      for (Map activity in day) {
        markerWidgets.add(ActivityMarker(
          activityNum: activityNum,
          dayNum: dayNum,
        ));
        MarkerId markerId = MarkerId("marker-" + activity["id"]);
        markerDetails.add({"markerId": markerId, "details": activity});
        markerProperties[markerId] = {
          "type": "activity",
          "day": dayNum,
        };
        activityNum += 1;
      }
      dayNum += 1;
    }
    markerWidgets.add(HotelMarker());
    MarkerId markerId = MarkerId("marker-hotel");
    markerDetails.add({"markerId": markerId, "details": accommodation});
    markerProperties[markerId] = {
      "type": "hotel",
    };

    MarkerGenerator(markerWidgets, (bitmaps) {
      setState(() {
        markers = mapBitmapsToMarkers(bitmaps);
      });
    }).generate(context);
  }

  Set<Marker> mapBitmapsToMarkers(List<Uint8List> bitmaps) {
    Set<Marker> markersList = Set();
    bitmaps.asMap().forEach((i, bmp) {
      markersList.add(Marker(
        markerId: markerDetails[i]["markerId"],
        position: LatLng(markerDetails[i]["details"]["latitude"],
            markerDetails[i]["details"]["longitude"]),
        icon: BitmapDescriptor.fromBytes(bmp),
        onTap: () {
          if (controller != null) {
            controller.close();
            controller = null;
          }
          controller = scaffoldKey.currentState.showBottomSheet(
            (context) => GestureDetector(
              onVerticalDragDown: (details) {},
              child: BottomSheetDetails(
                details: markerDetails[i]["details"],
                callback: () {
                  if (controller != null) {
                    controller.close();
                    controller = null;
                  }
                },
              ),
            ),
            backgroundColor: Colors.transparent,
          );
        },
      ));
    });
    return markersList;
  }

  List<PopupMenuItem> getDayPopupMenuItems() {
    List<PopupMenuItem> items = [];
    for (int i = 0; i < itinerary.length; i++) {
      if (itinerary[i].length > 0) {
        items.add(
          PopupMenuItem(
            child: DayPopupMenuItem(
              callback: (day, value) {
                setState(() {
                  daysShown[day] = value;
                });
              },
              day: i,
              value: daysShown[i],
            ),
          ),
        );
      }
    }
    return items;
  }

  void updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Completer<GoogleMapController> _controller = Completer();
    double minLat = accommodation["latitude"] - 0.005;
    double maxLat = accommodation["latitude"] + 0.005;
    double minLng = accommodation["longitude"] - 0.005;
    double maxLng = accommodation["longitude"] + 0.005;

    for (List day in itinerary) {
      for (Map activity in day) {
        if (activity["latitude"] < minLat) {
          minLat = activity["latitude"];
        } else if (activity["latitude"] > maxLat) {
          maxLat = activity["latitude"];
        }
        if (activity["longitude"] < minLng) {
          minLng = activity["longitude"];
        } else if (activity["longitude"] > maxLng) {
          maxLng = activity["longitude"];
        }
      }
    }
    LatLng northEast = LatLng(maxLat, maxLng);
    LatLng southWest = LatLng(minLat, minLng);
    shownMarkers.clear();
    markers.forEach((m) {
      if (markerProperties[m.markerId]["type"] == "hotel" ||
          daysShown[markerProperties[m.markerId]["day"]]) {
        shownMarkers.add(m);
      }
    });

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 0),
            child: GoogleMap(
              mapType: MapType.normal,
              markers: shownMarkers,
              initialCameraPosition: CameraPosition(
                target: LatLng(maxLat, maxLng),
                zoom: 15,
              ),
              cameraTargetBounds: CameraTargetBounds(
                LatLngBounds(
                  northeast: northEast,
                  southwest: southWest,
                ),
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);

                controller.moveCamera(
                  CameraUpdate.newLatLngBounds(
                    LatLngBounds(
                      southwest: southWest,
                      northeast: northEast,
                    ),
                    15,
                  ),
                );
              },
            ),
          ),
          Positioned(
            top: 60,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: AnimatedButton(
                    callback: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      FontAwesomeIcons.times,
                      color: Theme.of(context).primaryColor,
                      size: 30,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: PopupMenuButton<void>(
                    itemBuilder: (context) => getDayPopupMenuItems(),
                    child: Icon(
                      FontAwesomeIcons.slidersH,
                      color: Theme.of(context).primaryColor,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DayPopupMenuItem extends StatefulWidget {
  final int day;
  final bool value;
  final Function callback;
  DayPopupMenuItem({this.day, this.value, this.callback});
  @override
  State<StatefulWidget> createState() {
    return DayPopupMenuItemState(
      day: day,
      value: value,
    );
  }
}

class DayPopupMenuItemState extends State<DayPopupMenuItem> {
  int day;
  bool value;
  DayPopupMenuItemState({this.day, this.value});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Day " + day.toString(),
          style: Theme.of(context).textTheme.headline2,
        ),
        CupertinoSwitch(
          value: value,
          activeColor: markerColors[day],
          onChanged: (v) {
            setState(() {
              value = v;
            });
            widget.callback(day, v);
          },
        ),
      ],
    );
  }
}

class BottomSheetDetails extends StatelessWidget {
  final Map details;
  final Function callback;
  BottomSheetDetails({this.details, this.callback});
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Container(
        height: 400,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: ActivityDetailsOption(
                activity: details,
              ),
            ),
            Positioned(
              top: 20,
              left: 20,
              child: AnimatedButton(
                callback: () {
                  callback();
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: CustomColors.lightGrey,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      FontAwesomeIcons.times,
                      size: 20,
                      color: Theme.of(context).primaryColor,
                    ),
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
