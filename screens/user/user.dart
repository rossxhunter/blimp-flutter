import 'package:auto_size_text/auto_size_text.dart';
import 'package:blimp/screens/user/achievements.dart';
import 'package:blimp/screens/explore.dart';
import 'package:blimp/screens/user/gifts.dart';
import 'package:blimp/screens/user/login.dart';
import 'package:blimp/screens/user/referrals.dart';
import 'package:blimp/screens/settings.dart';
import 'package:blimp/screens/user/trips.dart';
import 'package:blimp/services/user.dart';
import 'package:blimp/styles/colors.dart';
import 'package:blimp/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_carousel/carousel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UserPageState();
  }
}

class UserPageState extends State<UserPage> with TickerProviderStateMixin {
  void _refreshUserPage() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 20),
            child: isLoggedIn
                ? UserPageLoggedIn(
                    callback: _refreshUserPage,
                  )
                : UserPageLoggedOut(
                    callback: _refreshUserPage,
                  ),
          ),
        ),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  final Color backgroundColor;
  LoginButton({this.text, this.icon, this.color, this.backgroundColor});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            blurRadius: 10.0,
            offset: Offset(0, 5),
          )
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                text,
                style: Theme.of(context)
                    .textTheme
                    .headline2
                    .copyWith(color: color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserPageLoggedOut extends StatelessWidget {
  final Function callback;
  UserPageLoggedOut({this.callback});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 30, right: 30, top: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedButton(
            callback: () {
              showDialog(
                context: context,
                barrierColor: Color.fromRGBO(40, 40, 40, 0.2),
                builder: (BuildContext context) => Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: LoginSignupScreen(callback: callback),
                ),
              );
            },
            child: LoginButton(
              backgroundColor: Colors.blueGrey,
              color: Colors.white,
              text: "Login with email",
              icon: Icons.email,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 40),
            child: AnimatedButton(
              child: LoginButton(
                backgroundColor: Theme.of(context).primaryColor,
                color: Colors.white,
                text: "Login with Google",
                icon: FontAwesomeIcons.google,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 40),
            child: AnimatedButton(
              child: LoginButton(
                backgroundColor: Color.fromRGBO(40, 40, 240, 1),
                color: Colors.white,
                text: "Login with Facebook",
                icon: FontAwesomeIcons.facebookF,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UserQuickStat extends StatelessWidget {
  final String statName;
  final int statNum;
  UserQuickStat({this.statName, this.statNum});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      child: Column(
        children: [
          Text(
            statNum.toString(),
            style: Theme.of(context).textTheme.headline2,
          ),
          Text(
            statName,
            style: Theme.of(context).textTheme.headline1,
          ),
        ],
      ),
    );
  }
}

class UserPageLoggedIn extends StatefulWidget {
  final Function callback;
  UserPageLoggedIn({this.callback});
  @override
  State<StatefulWidget> createState() {
    return UserPageLoggedInState();
  }
}

class UserPageLoggedInState extends State<UserPageLoggedIn> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: 50,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ProfilePicture(),
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                isLoggedIn
                                    ? currentUser["firstName"] +
                                        " " +
                                        currentUser["lastName"]
                                    : "Guest",
                                style: Theme.of(context).textTheme.headline4,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          UserQuickStat(
                            statName: "Bookings",
                            statNum: currentUser["bookings"],
                          ),
                          UserQuickStat(
                            statName: "Searches",
                            statNum: currentUser["searches"],
                          ),
                          UserQuickStat(
                            statName: "Shares",
                            statNum: currentUser["shares"],
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AnimatedButton(
                              callback: () {
                                showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context) {
                                    return GiftsPage();
                                  },
                                );
                              },
                              child: UserOption(
                                text: "Redeem",
                                color: Theme.of(context).primaryColor,
                                icon: FontAwesomeIcons.ticketAlt,
                              ),
                            ),
                            AnimatedButton(
                              callback: () {
                                showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context) {
                                    return ReferralsPage();
                                  },
                                );
                              },
                              child: UserOption(
                                text: "Referrals",
                                color: Color.fromRGBO(243, 156, 18, 1),
                                icon: FontAwesomeIcons.bullhorn,
                              ),
                            ),
                            AnimatedButton(
                              callback: () {
                                showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context) {
                                    return GiftsPage();
                                  },
                                );
                              },
                              child: UserOption(
                                text: "Gifts",
                                color: Color.fromRGBO(46, 204, 113, 1),
                                icon: FontAwesomeIcons.gift,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TripsSection(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              isLoggedIn
                  ? UserQuickStat(
                      statName: "Blimp Score",
                      statNum: currentUser["score"],
                    )
                  : Container(
                      width: 0,
                      height: 0,
                    ),
              IconButton(
                icon: Icon(
                  Icons.settings,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingsPage(
                        logoutCallback: widget.callback,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ProfilePicture extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
            image: currentUser["profilePictureURL"] != null
                ? DecorationImage(
                    image: AssetImage(currentUser["profilePictureURL"]),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: Center(
            child: isLoggedIn
                ? currentUser["profilePictureURL"] == null
                    ? Text(
                        currentUser["firstName"][0] +
                            currentUser["lastName"][0],
                        style: Theme.of(context)
                            .textTheme
                            .headline4
                            .copyWith(color: Colors.white),
                      )
                    : Container(
                        height: 0,
                        width: 0,
                      )
                : Icon(
                    FontAwesomeIcons.solidUserCircle,
                    size: 60,
                    color: Colors.white,
                  ),
          ),
        ),
      ],
    );
  }
}

class UserOption extends StatelessWidget {
  final String text;
  final String subtext;
  final Color color;
  final IconData icon;
  UserOption({this.text, this.subtext, this.color, this.icon});
  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 120,
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: color.withOpacity(0.9),
                shape: BoxShape.circle,
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
                  child: FaIcon(
                    icon,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5),
              child: AutoSizeText(
                text,
                style: Theme.of(context).textTheme.headline2,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
