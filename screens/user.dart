import 'package:blimp/screens/achievements.dart';
import 'package:blimp/screens/explore.dart';
import 'package:blimp/screens/login.dart';
import 'package:blimp/screens/referrals.dart';
import 'package:blimp/screens/settings.dart';
import 'package:blimp/screens/trips.dart';
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

class UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    void _refreshUserPage() {
      setState(() {});
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Visibility(
                      visible: isLoggedIn,
                      child: Column(
                        children: [
                          Text(
                            "£0.00",
                            style: Theme.of(context).textTheme.headline2,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Text(
                              "REDEEM CREDIT",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1
                                  .copyWith(
                                      color: Theme.of(context).primaryColor),
                            ),
                          ),
                        ],
                      ),
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
                            builder: (context) => SettingsPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
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
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 0),
                    child: isLoggedIn
                        ? UserPageLoggedIn()
                        : UserPageLoggedOut(callback: _refreshUserPage),
                  ),
                ),
              ],
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
            color: Color.fromRGBO(
                (backgroundColor.red * 0.9).round(),
                (backgroundColor.green * 0.9).round(),
                (backgroundColor.blue * 0.9).round(),
                1),
            blurRadius: 0.0,
            spreadRadius: 0.0,
            offset: Offset(5.0, 5.0), // shadow direction: bottom right
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
      padding: EdgeInsets.only(left: 30, right: 30),
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

class UserPageLoggedIn extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UserPageLoggedInState();
  }
}

class UserPageLoggedInState extends State<UserPageLoggedIn>
    with TickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(vsync: this, length: 4, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 30),
      child: Column(
        children: [
          TabBar(
            isScrollable: true,
            controller: _controller,
            unselectedLabelColor: Theme.of(context).primaryColor,
            labelStyle: Theme.of(context).textTheme.bodyText1,
            labelColor: Theme.of(context).primaryColor,
            labelPadding: EdgeInsets.only(left: 20, right: 20),
            indicatorWeight: 2,
            indicator: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 3,
                ),
              ),
            ),
            tabs: [
              Tab(
                child: Align(
                  alignment: Alignment.center,
                  child: Text("Trips"),
                ),
              ),
              Tab(
                child: Align(
                  alignment: Alignment.center,
                  child: Text("Achievements"),
                ),
              ),
              Tab(
                child: Align(
                  alignment: Alignment.center,
                  child: Text("Referrals"),
                ),
              ),
              Tab(
                child: Align(
                  alignment: Alignment.center,
                  child: Text("Gift"),
                ),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _controller,
              physics: AlwaysScrollableScrollPhysics(),
              children: [
                TripsPage(),
                AchievementsPage(),
                ReferralsPage(),
                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
              ],
            ),
          ),
        ],
      ),
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
        Positioned(
          right: 5,
          top: 5,
          child: isLoggedIn
              ? Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Icon(
                      Icons.edit,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                )
              : Container(
                  height: 0,
                  width: 0,
                ),
        ),
      ],
    );
  }
}

class UserOption extends StatelessWidget {
  final String text;
  final Color color;
  final IconData icon;
  UserOption({this.text, this.color, this.icon});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                text,
                style: Theme.of(context)
                    .textTheme
                    .headline2
                    .copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
