import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GiftsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 10,
      // backgroundColor: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.only(top: 30, left: 10, right: 10, bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              FontAwesomeIcons.gift,
              size: 40,
              color: Theme.of(context).primaryColor,
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                "Give the gift of travel with Blimp Credit",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
