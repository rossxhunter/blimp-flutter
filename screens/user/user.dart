import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:blimp/screens/user/achievements.dart';
import 'package:blimp/screens/explore.dart';
import 'package:blimp/screens/user/gifts.dart';
import 'package:blimp/screens/user/login.dart';
import 'package:blimp/screens/user/referrals.dart';
import 'package:blimp/screens/settings/settings.dart';
import 'package:blimp/screens/user/support.dart';
import 'package:blimp/screens/user/trips.dart';
import 'package:blimp/services/http.dart';
import 'package:blimp/services/user.dart';
import 'package:blimp/styles/colors.dart';
import 'package:blimp/widgets/alerts.dart';
import 'package:blimp/widgets/buttons.dart';
import 'package:blimp/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_carousel/carousel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

class UserPage extends StatefulWidget {
  final bool intro;
  UserPage({this.intro});
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
                    intro: widget.intro,
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
        padding: EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

class UserPageLoggedOut extends StatefulWidget {
  final Function callback;
  final bool intro;
  UserPageLoggedOut({this.callback, this.intro});
  @override
  State<StatefulWidget> createState() {
    return UserPageLoggedOutState(callback: callback);
  }
}

class UserPageLoggedOutState extends State<UserPageLoggedOut> {
  final Function callback;
  UserPageLoggedOutState({this.callback});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 30, right: 30, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image(
              //   image: AssetImage("assets/images/logo.png"),
              //   width: 80,
              // ),
              Padding(
                padding: EdgeInsets.only(top: 80),
                child: Text(
                  "Welcome\nBack.",
                  style: Theme.of(context)
                      .textTheme
                      .headline4
                      .copyWith(color: Colors.black54),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 40),
                child: Text(
                  "Sign in to book holidays and connect with your friends",
                  style: Theme.of(context)
                      .textTheme
                      .headline2
                      .copyWith(color: Colors.black54),
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.bottomToTop,
                      child: LoginSignupScreen(callback: callback),
                    ),
                  ).then((value) {
                    if (widget.intro) {
                      Navigator.pop(context);
                    }
                  });
                },
                child: LoginButton(
                  backgroundColor: Theme.of(context).primaryColor,
                  color: Colors.white,
                  text: "Login with Email",
                  icon: FontAwesomeIcons.envelope,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: GestureDetector(
                  child: LoginButton(
                    backgroundColor: Colors.white,
                    color: Colors.black,
                    text: "Login with Apple",
                    icon: FontAwesomeIcons.apple,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: GestureDetector(
                  child: LoginButton(
                    backgroundColor: Colors.white,
                    color: Colors.red,
                    text: "Login with Google",
                    icon: FontAwesomeIcons.google,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: GestureDetector(
                  child: LoginButton(
                    backgroundColor: Colors.white,
                    color: Color.fromRGBO(40, 40, 240, 1),
                    text: "Login with Facebook",
                    icon: FontAwesomeIcons.facebookF,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class LoginSignUpButton extends StatelessWidget {
  final String text;
  final Color color;
  LoginSignUpButton({this.text, this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
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
        padding: EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon(
            //   icon,
            //   color: color,
            // ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                text,
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
  final picker = ImagePicker();
  int v = 0;
  String _ppPath = currentUser["profilePicture"] != null
      ? currentUser["profilePicture"] + "?v=0"
      : null;

  Future changeProfilePicture() async {
    if (_ppPath != null) {
      final NetworkImage provider = NetworkImage(_ppPath);
      provider.evict().then<void>((bool success) {
        if (success) debugPrint('removed image!');
      }).catchError((e) {
        print(e);
      });
    }
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return LoadingIndicator();
          });

      await addProfilePicture(currentUser["id"], pickedFile.path);
      setState(() {
        if (pickedFile != null) {
          v += 1;
          _ppPath = currentUser["profilePicture"] ??
              "https://blimp-resources.s3.eu-west-2.amazonaws.com/profile_pictures/${currentUser["id"]}.jpg" +
                  "?v=$v";
        } else {
          print('No image selected.');
        }
      });
      Navigator.pop(context);
      showSuccessToast(context, "Profile Picture Updated");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              top: 50,
              bottom: 30,
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ProfilePicture(
                          callback: changeProfilePicture,
                          filePath: _ppPath ?? currentUser["profilePicture"],
                        ),
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
                                  barrierColor: Colors.transparent,
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
                                  barrierColor: Colors.transparent,
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
                                  barrierColor: Colors.transparent,
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
                      Padding(
                        padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TripsPage(),
                              ),
                            );
                          },
                          child: UserLargeOption(
                            text: "Trips",
                            subtext: "View and edit trips",
                            color: Colors.orange,
                            icon: FontAwesomeIcons.suitcaseRolling,
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SupportPage(),
                              ),
                            );
                          },
                          child: UserLargeOption(
                            text: "Support",
                            subtext: "Reach out to our support staff ",
                            color: Colors.white,
                            icon: FontAwesomeIcons.userFriends,
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ),
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

class UserLargeOption extends StatelessWidget {
  final Color backgroundColor;
  final String text;
  final String subtext;
  final Color color;
  final IconData icon;
  UserLargeOption(
      {this.backgroundColor, this.text, this.subtext, this.color, this.icon});
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
          )
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              icon,
              color: Color.fromRGBO(20, 20, 60, 1),
              size: 30,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      text,
                      style: Theme.of(context)
                          .textTheme
                          .headline3
                          .copyWith(color: Color.fromRGBO(20, 20, 60, 1)),
                    ),
                    Text(
                      subtext,
                      textAlign: TextAlign.end,
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePicture extends StatelessWidget {
  final Function callback;
  final String filePath;

  ProfilePicture({this.callback, this.filePath});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => callback(),
          child: Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: CustomColors.greyBackground,
              shape: BoxShape.circle,
              image: filePath != null
                  ? DecorationImage(
                      image: NetworkImage(filePath),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: Center(
              child: isLoggedIn
                  ? filePath == null
                      ? Text(
                          currentUser["firstName"][0] +
                              currentUser["lastName"][0],
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              .copyWith(color: Theme.of(context).primaryColor))
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
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 10.0,
                    offset: Offset(0, 0),
                  )
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: FaIcon(
                    icon,
                    color: color,
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
