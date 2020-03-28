import 'package:flutter/material.dart';

class IconBox extends StatelessWidget {
  final String icon;
  IconBox({this.icon});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(240, 240, 240, 0.8),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Icon(
          _getIcon(),
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  IconData _getIcon() {
    if (icon == "Travellers") {
      return Icons.people;
    } else if (icon == "Dates") {
      return Icons.calendar_today;
    } else if (icon == "Accommodation Type") {
      return Icons.hotel;
    } else if (icon == "Minimum Stars") {
      return Icons.star;
    }
  }
}
