import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class FeedbackScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FeedbackDialog(
      title: "Feedback",
      description: "fshk",
    );
  }
}

class FeedbackDialog extends StatelessWidget {
  final String title, description;

  FeedbackDialog({
    @required this.title,
    @required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: new BoxDecoration(
          // color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(20),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black26,
          //     blurRadius: 10.0,
          //     offset: const Offset(0.0, 10.0),
          //   ),
          // ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Text(
            //   "Different Destination",
            //   textAlign: TextAlign.center,
            //   style: Theme.of(context).textTheme.headline3,
            // ),
            Padding(
              padding: EdgeInsets.only(top: 0),
              child: GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                children: <Widget>[
                  FeedbackOption(
                    text: "Cheaper",
                    iconData: Icons.account_balance_wallet,
                    color: Colors.purple,
                  ),
                  FeedbackOption(
                    text: "Closer",
                    iconData: Icons.timer,
                    color: Colors.blue,
                  ),
                  FeedbackOption(
                    text: "Hotter",
                    iconData: Icons.wb_sunny,
                    color: Colors.orange,
                  ),
                  FeedbackOption(
                    text: "More Cultural",
                    iconData: Icons.map,
                    color: Colors.teal,
                  ),
                  FeedbackOption(
                    text: "More Chilled",
                    iconData: Icons.spa,
                    color: Colors.green,
                  ),
                  FeedbackOption(
                    text: "More Adventurous",
                    iconData: Icons.feedback,
                    color: Colors.pink,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: FeedbackOption(
                text: "Just Different",
                iconData: CupertinoIcons.shuffle_thick,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeedbackOption extends StatelessWidget {
  final String text;
  final IconData iconData;
  final Color color;

  FeedbackOption({this.text, this.iconData, this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              iconData,
              color: Colors.white,
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: AutoSizeText(
                text,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline3
                    .copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
