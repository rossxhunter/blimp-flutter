import 'package:auto_size_text/auto_size_text.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
}

class SuccessDialog extends StatelessWidget {
  final String title, description;
  SuccessDialog({this.title, this.description});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: successDialogContent(context, title, description),
    );
  }
}

class CustomDialog extends StatelessWidget {
  final String title, description;

  CustomDialog({
    @required this.title,
    @required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context, title, description),
    );
  }
}

Widget successDialogContent(
    BuildContext context, String title, String description) {
  return Stack(
    children: <Widget>[
      Container(
        height: 250,
        padding: EdgeInsets.all(30),
        margin: EdgeInsets.only(top: Consts.avatarRadius),
        decoration: new BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(Consts.padding),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: const Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              // SizedBox(height: 24.0),
              // Align(
              //   alignment: Alignment.bottomRight,
              //   child: FlatButton(
              //     onPressed: () {
              //       Navigator.of(context).pop();
              //     },
              //     child: Text("OK"),
              //   ),
              // ),
            ],
          ),
        ),
      ),
      Positioned(
        left: Consts.padding,
        right: Consts.padding,
        child: CircleAvatar(
          backgroundColor: Colors.green,
          radius: Consts.avatarRadius,
          child: Icon(
            Icons.check,
            color: Colors.white,
            size: 50,
          ),
        ),
      ),
    ],
  );
}

dialogContent(BuildContext context, String title, String description) {
  return Stack(
    children: <Widget>[
      Container(
        padding: EdgeInsets.only(
          top: Consts.avatarRadius + Consts.padding,
          bottom: Consts.padding,
          left: Consts.padding,
          right: Consts.padding,
        ),
        margin: EdgeInsets.only(top: Consts.avatarRadius),
        decoration: new BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(Consts.padding),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: const Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // To make the card compact
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 24.0),
            Align(
              alignment: Alignment.bottomRight,
              child: FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ),
          ],
        ),
      ),
      Positioned(
        left: Consts.padding,
        right: Consts.padding,
        child: CircleAvatar(
          backgroundColor: Colors.redAccent,
          radius: Consts.avatarRadius,
          child: Icon(
            Icons.error,
            color: Colors.white,
            size: 50,
          ),
        ),
      ),
    ],
  );
}

class CustomToast extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Colors.greenAccent,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check),
            SizedBox(
              width: 12.0,
            ),
            Text("Saved"),
          ],
        ),
      ),
    );
  }
}

void showErrorToast(BuildContext context, String text) {
  BotToast.showNotification(
    borderRadius: 15,
    leading: (c) => Icon(
      FontAwesomeIcons.times,
      color: Colors.red,
      size: 26,
    ),
    title: (cancelFunc) => Padding(
      padding: EdgeInsets.only(right: 40),
      child: AutoSizeText(
        text,
        style:
            Theme.of(context).textTheme.headline2.copyWith(color: Colors.black),
        textAlign: TextAlign.center,
      ),
    ),
    backgroundColor: Colors.white,
    contentPadding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
    align: Alignment.topCenter.add(Alignment(0, 0.02)),
  );
}

void showSuccessToast(BuildContext context, String text) {
  BotToast.showNotification(
    borderRadius: 15,
    leading: (c) => Icon(
      FontAwesomeIcons.checkCircle,
      color: Colors.green,
      size: 26,
    ),
    title: (cancelFunc) => Padding(
      padding: EdgeInsets.only(right: 40),
      child: AutoSizeText(
        text,
        style:
            Theme.of(context).textTheme.headline2.copyWith(color: Colors.black),
        textAlign: TextAlign.center,
      ),
    ),
    backgroundColor: Colors.white,
    contentPadding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
    align: Alignment.topCenter.add(Alignment(0, 0.02)),
  );
}
