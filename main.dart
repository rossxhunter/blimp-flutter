import 'package:async/async.dart';
import 'package:blimp/screens/explore.dart';
import 'package:blimp/screens/search.dart';
import 'package:blimp/screens/settings.dart';
import 'package:blimp/screens/testing.dart';
import 'package:blimp/screens/trips.dart';
import 'package:blimp/screens/user.dart';
import 'package:blimp/services/suggestions.dart';
import 'package:blimp/widgets/buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';

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
              "An error has occured 😢",
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
        child: Text(
          'Loading App Data...',
          textDirection: TextDirection.ltr,
          style: Theme.of(context)
              .textTheme
              .headline3
              .copyWith(color: Colors.white),
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

    _future = getSuggestions();
  }

  void tryAgain() {
    setState(() {
      _future = getSuggestions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blimp',
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
            fontWeight: FontWeight.bold,
            fontFamily: "Futura",
            fontSize: 30,
          ),
          headline3: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontFamily: "Open Sans",
            fontSize: 20,
          ),
          headline2: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontFamily: "Open Sans",
            fontSize: 15,
          ),
          headline1: TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.w500,
            fontFamily: "Open Sans",
            fontSize: 12,
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
                return BlimpScaffold();
          }
        },
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
    TestingPage()
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
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.lab_flask),
            title: Text("Testing"),
          )
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
