import 'package:blimp/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ActivityMarker extends StatelessWidget {
  final int dayNum;
  final int activityNum;
  ActivityMarker({this.activityNum, this.dayNum});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Icon(
          FontAwesomeIcons.mapMarker,
          color: markerColors[dayNum],
          size: 40,
        ),
        Positioned(
          top: 2.5,
          left: 7.5,
          child: Container(
            height: 25,
            width: 25,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text((activityNum + 1).toString(),
                  style: Theme.of(context).textTheme.headline2
                  // .copyWith(color: Colors.white),
                  ),
            ),
          ),
        ),
      ],
    );
  }
}

class HotelMarker extends StatelessWidget {
  HotelMarker();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Icon(
          FontAwesomeIcons.mapMarker,
          color: Theme.of(context).primaryColor,
          size: 50,
        ),
        Positioned(
          left: 14,
          top: 9,
          child: FaIcon(
            FontAwesomeIcons.home,
            size: 20,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
