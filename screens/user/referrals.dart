import 'package:blimp/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share/share.dart';

class ReferralsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ReferralsPageState();
  }
}

class ReferralsPageState extends State<ReferralsPage> {
  bool addReferralCodePressed = false;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 0.0,
      // backgroundColor: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.only(top: 30, left: 10, right: 10, bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 0, right: 0),
                  child: Text(
                    "Send this code to your friends",
                    style: Theme.of(context).textTheme.headline1,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 30, right: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "BGHSJKBN",
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: AnimatedButton(
                          callback: () {
                            Clipboard.setData(ClipboardData(text: "BGHSJKBN"));
                          },
                          child: Icon(
                            Icons.content_copy,
                            size: 30,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      // Padding(
                      //   padding: EdgeInsets.only(left: 10),
                      //   child: AnimatedButton(
                      //     callback: () {
                      //       Share.share(
                      //           'Get £10 off your next holiday with Blimp! Use code BGHSJKBN when you sign up. You get £10 off and so does Alice! https://blimptrips.com',
                      //           subject: "£10 off holidays with Blimp");
                      //     },
                      //     child: Icon(
                      //       Icons.share,
                      //       size: 30,
                      //       color: Theme.of(context).primaryColor,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 30, left: 30, right: 30),
                  child: Text(
                    "Been referred by a friend?",
                    style: Theme.of(context).textTheme.headline1,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 30, right: 30),
                  child: AnimatedButton(
                    callback: () {},
                    child: ActionButton(text: "Add Referral Code"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final String text;
  ActionButton({this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            blurRadius: 10.0,
            offset: Offset(0, 5),
          )
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Text(
            text,
            style: Theme.of(context)
                .textTheme
                .button
                .copyWith(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
      ),
    );
  }
}
