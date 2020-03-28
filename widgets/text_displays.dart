import 'package:flutter/material.dart';

class ActivityText extends StatelessWidget {
  final String text;
  ActivityText({this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(240, 240, 240, 0.8),
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
