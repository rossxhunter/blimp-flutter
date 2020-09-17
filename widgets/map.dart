import 'package:blimp/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ActivityMarker extends StatelessWidget {
  final int dayNum;
  final int activityNum;
  ActivityMarker({this.activityNum, this.dayNum});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: markerColors[dayNum],
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          (activityNum + 1).toString(),
          style: Theme.of(context)
              .textTheme
              .headline2
              .copyWith(color: Colors.white),
        ),
      ),
    );
  }
}

class HotelMarker extends StatelessWidget {
  HotelMarker();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          FontAwesomeIcons.hotel,
          size: 20,
          color: Colors.white,
        ),
      ),
    );
  }
}
