import 'package:after_layout/after_layout.dart';
import 'package:async/async.dart';
import 'package:blimp/screens/explore.dart';
import 'package:blimp/screens/search.dart';
import 'package:blimp/screens/settings/settings.dart';
import 'package:blimp/screens/testing/testing.dart';
import 'package:blimp/screens/user/trips.dart';
import 'package:blimp/screens/user/user.dart';
import 'package:blimp/services/suggestions.dart';
import 'package:blimp/styles/colors.dart';
import 'package:blimp/widgets/buttons.dart';
import 'package:blimp/widgets/loading.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stripe_payment/stripe_payment.dart';

void main() => runApp(BlimpApp());

enum Page { main, results }

class BlimpApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BlimpAppState();
  }
}

class BlimpAppState extends State<BlimpApp> {
  @override
  Widget build(BuildContext context) {
    return BlimpMaterialApp();
  }
}

class ErrorScreen extends StatelessWidget {
  final Function callback;

  ErrorScreen({this.callback});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Something went wrong 😢",
              textDirection: TextDirection.ltr,
              style: Theme.of(context)
                  .textTheme
                  .headline3
                  .copyWith(color: Colors.white),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: AnimatedButton(
                callback: callback,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "Try Again",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoadingDataScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: SpinKitDoubleBounce(
          color: Colors.white,
          size: 60,
        ),
      ),
    );
  }
}

class BlimpMaterialApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BlimpMaterialAppState();
  }
}

class BlimpMaterialAppState extends State<BlimpMaterialApp> {
  Future<void> _future;

  initState() {
    super.initState();

    _future = suggestions.getSuggestions();
    StripePayment.setOptions(
      StripeOptions(
        publishableKey: 'pk_test_K12DQ53LJmA1a3iVswAArWMw00IU5SbUD1',
        merchantId: 'ross98hunter@gmail.com',
      ),
    );
  }

  void tryAgain() {
    setState(() {
      _future = suggestions.getSuggestions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blimp',
      debugShowCheckedModeBanner: false,
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()], //
      theme: ThemeData(
        primarySwatch: Theme.of(context).primaryColor,
        primaryColor: Color.fromRGBO(230, 20, 60, 1),
        highlightColor: Colors.transparent,
        dividerColor: Colors.transparent,
        accentColor: Color.fromRGBO(230, 20, 60, 1),
        splashColor: Colors.transparent,
        buttonColor: Color.fromRGBO(230, 20, 60, 1),
        canvasColor: Colors.white,
        buttonBarTheme:
            ButtonBarThemeData(buttonTextTheme: ButtonTextTheme.accent),
        textTheme: TextTheme(
          headline4: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontFamily: "Futura",
            fontSize: 30,
          ),
          headline3: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontFamily: "Avenir",
            fontSize: 24,
          ),
          headline2: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontFamily: "Avenir",
            fontSize: 16,
          ),
          headline1: TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.w500,
            fontFamily: "Avenir",
            fontSize: 14,
          ),
          button: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontFamily: "Open Sans",
            fontSize: 16,
          ),
          bodyText1: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontFamily: "Open Sans",
            fontSize: 16,
          ),
        ),
      ),
      home: FutureBuilder<void>(
        future: _future,
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return LoadingDataScreen();
            case ConnectionState.waiting:
              return LoadingDataScreen();
            default:
              if (snapshot.hasError)
                return ErrorScreen(callback: tryAgain);
              else
                return Splash();
          }
        },
      ),
    );
  }
}

class Splash extends StatefulWidget {
  @override
  SplashState createState() => new SplashState();
}

class SplashState extends State<Splash> with AfterLayoutMixin<Splash> {
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    if (_seen) {
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => BlimpScaffold()));
    } else {
      await prefs.setBool('seen', true);
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => IntroScreen()));
    }
  }

  @override
  void afterFirstLayout(BuildContext context) => checkFirstSeen();

  @override
  Widget build(BuildContext context) {
    return LoadingDataScreen();
  }
}

class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final introScreenKey = GlobalKey<IntroductionScreenState>();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Image.asset(
              "assets/images/logowithtext.png",
              height: 80,
            ),
            Expanded(
              child: IntroductionScreen(
                key: introScreenKey,
                pages: [
                  PageViewModel(
                    title: "Welcome to Blimp",
                    body: "Find your next adventure, without the hassle",
                    image: Center(
                      child: Container(
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                            // border: Border.all(width: 2, color: Colors.grey),
                            shape: BoxShape.circle,
                            color: CustomColors.lightGrey,
                          ),
                          child: Image.asset(
                            "assets/icons/location.png",
                            width: 80,
                          )),
                    ),
                    footer: Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: AnimatedButton(
                        callback: () {
                          introScreenKey.currentState.next();
                        },
                        child: BlimpClassicButton(
                          text: "Let's Go!",
                          primary: true,
                        ),
                      ),
                    ),
                    decoration: PageDecoration(
                      titleTextStyle: Theme.of(context).textTheme.headline4,
                      bodyTextStyle: Theme.of(context)
                          .textTheme
                          .headline2
                          .copyWith(color: Colors.black54),
                    ),
                  ),
                  PageViewModel(
                    title: "Flights, Hotels, Activities",
                    body: "Search and book 1000s of available holiday products",
                    image: Center(
                      child: Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          // border: Border.all(width: 2, color: Colors.grey),
                          shape: BoxShape.circle,
                          color: CustomColors.lightGrey,
                        ),
                        child: Center(
                          child: Image.asset(
                            "assets/icons/plane-tickets.png",
                            width: 120,
                            height: 120,
                            // fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    decoration: PageDecoration(
                      titleTextStyle: Theme.of(context).textTheme.headline4,
                      bodyTextStyle: Theme.of(context)
                          .textTheme
                          .headline2
                          .copyWith(color: Colors.black54),
                    ),
                  ),
                  PageViewModel(
                    title: "Holiday planning, but easy",
                    body:
                        "Powerful holiday planning tools make the process super easy. Automatic selection, itinerary planning and Facebook integration.",
                    image: Center(
                      child: Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          // border: Border.all(width: 2, color: Colors.grey),
                          shape: BoxShape.circle,
                          color: CustomColors.lightGrey,
                        ),
                        child: Center(
                          child: Image.asset(
                            "assets/icons/006-magic-wand-3.png",
                            width: 120,
                            height: 120,
                          ),
                        ),
                      ),
                    ),
                    decoration: PageDecoration(
                      titleTextStyle: Theme.of(context).textTheme.headline4,
                      bodyTextStyle: Theme.of(context)
                          .textTheme
                          .headline2
                          .copyWith(color: Colors.black54),
                    ),
                  ),
                  PageViewModel(
                    title: "Travel to help the world",
                    body:
                        "10% of Blimp's profits go direcly to charitable organisations across the world",
                    image: Center(
                      child: Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          // border: Border.all(width: 2, color: Colors.grey),
                          shape: BoxShape.circle,
                          color: CustomColors.lightGrey,
                        ),
                        child: Center(
                          child: Image.asset(
                            "assets/icons/like.png",
                            width: 120,
                            height: 120,
                          ),
                        ),
                      ),
                    ),
                    decoration: PageDecoration(
                      titleTextStyle: Theme.of(context).textTheme.headline4,
                      bodyTextStyle: Theme.of(context)
                          .textTheme
                          .headline2
                          .copyWith(color: Colors.black54),
                    ),
                  ),
                  // PageViewModel(
                  //   title: "Stay in the loop",
                  //   body:
                  //       "We'll keep you updated with price drops and information about your bookings",
                  //   image: Center(
                  //     child: Container(
                  //       height: 200,
                  //       width: 200,
                  //       decoration: BoxDecoration(
                  //         // border: Border.all(width: 2, color: Colors.grey),
                  //         shape: BoxShape.circle,
                  //         color: CustomColors.lightGrey,
                  //       ),
                  //       child: Icon(
                  //         FontAwesomeIcons.bell,
                  //         color: Theme.of(context).primaryColor,
                  //         size: 80,
                  //       ),
                  //     ),
                  //   ),
                  //   footer: Padding(
                  //     padding: EdgeInsets.only(left: 20, right: 20),
                  //     child: Column(
                  //       children: [
                  //         BlimpClassicButton(
                  //           text: "Enable Notifications",
                  //           primary: true,
                  //         ),
                  //         Padding(
                  //           padding: EdgeInsets.only(top: 15),
                  //           child: Text(
                  //             "NOT NOW",
                  //             style: Theme.of(context)
                  //                 .textTheme
                  //                 .headline2
                  //                 .copyWith(
                  //                   color: Theme.of(context).primaryColor,
                  //                 ),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  //   decoration: PageDecoration(
                  //     titleTextStyle: Theme.of(context).textTheme.headline4,
                  //     bodyTextStyle: Theme.of(context)
                  //         .textTheme
                  //         .headline2
                  //         .copyWith(color: Colors.black54),
                  //   ),
                  // ),
                  PageViewModel(
                    title: "The World is Yours",
                    body:
                        "Create an account to take advantage of all the features",
                    image: Center(
                      child: Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          // border: Border.all(width: 2, color: Colors.grey),
                          shape: BoxShape.circle,
                          color: CustomColors.lightGrey,
                        ),
                        child: Center(
                          child: Image.asset(
                            "assets/icons/018-travel.png",
                            // width: 120,
                            // height: 120,
                          ),
                        ),
                      ),
                    ),
                    footer: AnimatedButton(
                      callback: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.bottomToTop,
                            child: UserPage(intro: true),
                          ),
                        ).then((value) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlimpScaffold(),
                            ),
                          );
                        });
                      },
                      child: BlimpClassicButton(
                        text: "Create Account",
                        primary: true,
                      ),
                    ),
                    decoration: PageDecoration(
                      titleTextStyle: Theme.of(context).textTheme.headline4,
                      bodyTextStyle: Theme.of(context)
                          .textTheme
                          .headline2
                          .copyWith(color: Colors.black54),
                    ),
                  ),
                ],
                onDone: () {
                  // When done button is press
                },
                // onSkip: () {
                //   // You can also override onSkip callback
                // },
                showSkipButton: false,
                skip: Text(
                  "Skip",
                  style: Theme.of(context).textTheme.headline1,
                ),
                next: Icon(
                  FontAwesomeIcons.arrowRight,
                  size: 20,
                  color: Colors.grey,
                ),
                done: Text(
                  "Skip",
                  style: Theme.of(context).textTheme.headline1,
                ),
                dotsDecorator: DotsDecorator(
                    size: const Size.square(10.0),
                    activeSize: const Size(20.0, 10.0),
                    activeColor: Theme.of(context).accentColor,
                    color: Colors.black26,
                    spacing: const EdgeInsets.symmetric(horizontal: 3.0),
                    activeShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ImageFade extends StatelessWidget {
  final Widget image;
  ImageFade({this.image});
  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (rect) {
        return LinearGradient(
          begin: Alignment.center,
          end: Alignment.topCenter,
          colors: [Colors.black, Colors.transparent],
        ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
      },
      blendMode: BlendMode.dstIn,
      child: ShaderMask(
        shaderCallback: (rect) {
          return LinearGradient(
            begin: Alignment.center,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Colors.transparent],
          ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
        },
        blendMode: BlendMode.dstIn,
        child: image,
      ),
    );
  }
}

class BlimpClassicButton extends StatelessWidget {
  final String text;
  final bool primary;
  BlimpClassicButton({this.text, this.primary});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: primary ? Theme.of(context).primaryColor : Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: !primary
            ? Border.all(width: 3, color: Theme.of(context).primaryColor)
            : null,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.2),
            blurRadius: 10.0,
            offset: Offset(0, 10),
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

class BlimpScaffold extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BlimpScaffoldState();
  }
}

class BlimpScaffoldState extends State<BlimpScaffold> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    ExplorePage(),
    SearchPage(),
    UserPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _children,
      ),
      // backgroundColor: Color.fromRGBO(250, 250, 250, 1),
      // backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        elevation: 0,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        selectedItemColor: Theme.of(context).primaryColor,
        currentIndex: _currentIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            title: Text("Explore"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text("Search"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text("User"),
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
