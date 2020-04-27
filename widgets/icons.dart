import 'package:blimp/styles/colors.dart';
import 'package:flutter/material.dart';

class IconBox extends StatelessWidget {
  final IconData icon;
  IconBox({this.icon});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CustomColors.redGrey,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Icon(
          icon,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
