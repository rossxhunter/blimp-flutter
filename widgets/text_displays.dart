import 'package:blimp/styles/colors.dart';
import 'package:flutter/material.dart';

class ActivityText extends StatelessWidget {
  final String text;
  ActivityText({this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CustomColors.lightGrey,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          text,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
          maxLines: 2,
        ),
      ),
    );
  }
}
