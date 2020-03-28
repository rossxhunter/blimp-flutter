import 'package:blimp/screens/explore.dart';
import 'package:blimp/screens/search.dart';
import 'package:blimp/screens/settings.dart';
import 'package:flutter/material.dart';

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
    return MaterialApp(
      title: 'Blimp',
      theme: ThemeData(
        primarySwatch: Theme.of(context).primaryColor,
        primaryColor: Colors.pink,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        textTheme: TextTheme(
          headline4: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontFamily: "Helvetica",
            fontSize: 30,
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
      home: BlimpScaffold(),
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
  final List<Widget> _children = [ExplorePage(), SearchPage(), SettingsPage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _children,
      ),
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped, // new
        backgroundColor: Colors.white,
        currentIndex: _currentIndex, // ne
        showSelectedLabels: false, // <-- HERE
        showUnselectedLabels: false,
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text("Home"),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text("Search"),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text("Profile"),
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
