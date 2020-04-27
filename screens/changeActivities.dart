import 'package:blimp/model/preferences.dart';
import 'package:blimp/screens/explore.dart';
import 'package:blimp/screens/flights.dart';
import 'package:blimp/screens/newActivity.dart';
import 'package:blimp/screens/results.dart';
import 'package:blimp/services/http.dart';
import 'package:blimp/styles/colors.dart';
import 'package:blimp/widgets/alerts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:popup_menu/popup_menu.dart';
import 'package:reorderables/reorderables.dart';

class ChangeActivitiesScreen extends StatefulWidget {
  final Map itinerary;
  final List allActivities;
  final Map travel;
  final Map accommodation;
  final Preferences preferences;
  final int day;

  ChangeActivitiesScreen(
      {this.itinerary,
      this.day,
      this.allActivities,
      this.travel,
      this.accommodation,
      this.preferences});
  @override
  State<StatefulWidget> createState() {
    return ChangeActivitiesScreenState(
        itinerary: itinerary,
        day: day,
        allActivities: allActivities,
        travel: travel,
        accommodation: accommodation,
        preferences: preferences);
  }
}

class ChangeActivitiesScreenState extends State<ChangeActivitiesScreen>
    with TickerProviderStateMixin {
  Map itinerary;
  int day;
  final List allActivities;
  final Map travel;
  final Map accommodation;
  final Preferences preferences;
  List<List> _activities;

  ChangeActivitiesScreenState(
      {this.itinerary,
      this.day,
      this.allActivities,
      this.travel,
      this.accommodation,
      this.preferences}) {
    _activities = List<List>();
    for (int i = 0; i < itinerary.keys.length; i++) {
      _activities.add(List());
      for (Map activity in itinerary[i.toString()]) {
        _activities[i].add(activity);
      }
    }
  }

  void removeActivity(Map activity) {
    setState(() {
      _activities[day].remove(activity);
    });
  }

  void addNewActivity(Map activity) {
    List<Map> newActivities = List<Map>();
    for (Map a in _activities[day]) {
      newActivities.add(a);
    }
    newActivities.add(activity);

    getItineraryFromActivities(
            newActivities, day, travel, accommodation, preferences)
        .then((newItineraryActivities) {
      setState(() {
        _activities[day] = newItineraryActivities;
      });
    }).catchError((e) {
      showDialog(
        context: context,
        builder: (BuildContext context) => CustomDialog(
          title: "Error",
          description: "Unable to add activity - " + e.toString(),
        ),
      );
    });
  }

  List<int> _getTabNums(int numDays) {
    List<int> tabs = [];
    for (int i = 0; i < numDays; i++) {
      tabs.add(i);
    }
    return tabs;
  }

  List<Widget> _getActivityTabs(int numDays) {
    List<Widget> tabs = [];
    for (int i = 0; i < numDays; i++) {
      tabs.add(
        Tab(
          child: Align(
            alignment: Alignment.center,
            child: Text("Day " + (i + 1).toString()),
          ),
        ),
      );
    }
    return tabs;
  }

  bool _isScreenDisabled = false;

  @override
  Widget build(BuildContext context) {
    PopupMenu.context = context;
    TabController _controller = TabController(
        vsync: this, length: itinerary.keys.length, initialIndex: day);
    _controller.addListener(() {
      setState(() {
        day = _controller.index;
      });
    });
    return AbsorbPointer(
      absorbing: _isScreenDisabled,
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 0,
              shape: ContinuousRectangleBorder(
                side: BorderSide(
                  color: CustomColors.lightGrey,
                  width: 4,
                ),
              ),
              title: Text(
                "Activities",
                style: Theme.of(context).textTheme.headline3,
              ),
              leading: Padding(
                padding: EdgeInsets.only(left: 20),
                child: IconButton(
                  icon: Icon(Icons.close),
                  color: Theme.of(context).primaryColor,
                  iconSize: 30,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              actions: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 0),
                  child: IconButton(
                    icon: Icon(Icons.filter_list),
                    color: Theme.of(context).primaryColor,
                    iconSize: 30,
                    onPressed: () {},
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: IconButton(
                    icon: Icon(Icons.add),
                    color: Theme.of(context).primaryColor,
                    iconSize: 30,
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierColor: Color.fromRGBO(40, 40, 40, 0.2),
                        builder: (BuildContext context) => NewActivity(
                          allActivities: allActivities,
                          callback: addNewActivity,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            body: Padding(
              padding: EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  TabBar(
                    isScrollable: true,
                    controller: _controller,
                    unselectedLabelColor: Theme.of(context).primaryColor,
                    labelStyle: Theme.of(context).textTheme.bodyText1,
                    labelColor: Theme.of(context).primaryColor,
                    labelPadding: EdgeInsets.only(left: 20, right: 20),
                    indicator: CircleTabIndicator(
                        color: Theme.of(context).primaryColor, radius: 4),
                    tabs: _getActivityTabs(itinerary.keys.length),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _controller,
                      physics: AlwaysScrollableScrollPhysics(),
                      children: _getTabNums(itinerary.keys.length).map((int d) {
                        return Stack(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: 20, top: 10, left: 0, right: 0),
                              child: CustomScrollView(
                                physics: AlwaysScrollableScrollPhysics(),
                                slivers: <Widget>[
                                  ReorderableSliverList(
                                    delegate:
                                        ReorderableSliverChildListDelegate(
                                      _getActivityRows(_activities[d], context),
                                    ),
                                    onReorder: _onReorder,
                                  )
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned.fill(
            top: null,
            bottom: 0,
            child: Container(
              color: Colors.transparent,
              child: Padding(
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 30),
                child: GestureDetector(
                  onTap: () {
                    itinerary[day.toString()] = _activities[day];
                    Navigator.of(context).pop();
                  },
                  child: ConfirmButton(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _getActivityRows(List activities, BuildContext context) {
    List<Widget> rows = [];
    for (Map activity in activities) {
      rows.add(
        ListViewCard(
          key: Key(activity["id"] + activity["startTime"].toString()),
          activity: activity,
          callback: removeActivity,
        ),
      );
    }
    return rows;
  }

  void _onReorder(int oldIndex, int newIndex) {
    _isScreenDisabled = true;
    List<Map> newActivities = List.from(_activities[day]);
    Map a = newActivities.removeAt(oldIndex);
    newActivities.insert(newIndex, a);
    List<Map> pendingActivties = List<Map>();
    for (int i = 0; i < newActivities.length; i++) {
      pendingActivties.add(Map.from(newActivities[i]));
      pendingActivties.last["startTime"] = -1;
    }
    setState(() {
      _activities[day] = pendingActivties;
    });

    getItineraryFromActivities(
            newActivities, day, travel, accommodation, preferences)
        .then((newItineraryActivities) {
      setState(() {
        _activities[day] = newItineraryActivities;
        _isScreenDisabled = false;
      });
    }).catchError((e) {
      showDialog(
        context: context,
        barrierColor: Color.fromRGBO(40, 40, 40, 0.2),
        builder: (BuildContext context) => CustomDialog(
          title: "Error",
          description: "Unable to add activity - " + e.toString(),
        ),
      );
    });
  }
}

class ListViewCard extends StatelessWidget {
  final Map activity;
  final Function callback;
  final Key key;

  ListViewCard({this.activity, this.callback, this.key});

  @override
  Widget build(BuildContext context) {
    Widget child = ActivityOption(activity: activity);
    return Padding(
      padding: EdgeInsets.only(bottom: 20, top: 20, left: 30, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: child,
          ),
          PopupMenuButton<String>(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(color: CustomColors.lightGrey, width: 2),
            ),
            elevation: 0,
            tooltip: "Actions",
            onSelected: (value) {
              if (value == "delete") {
                callback(activity);
              }
            },
            icon: Icon(
              Icons.more_horiz,
              color: Theme.of(context).primaryColor,
            ),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: "changeDuration",
                child: Row(
                  children: [
                    Icon(
                      Icons.timer,
                      color: Colors.blue,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text('Change Duration'),
                    ),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: "switchDays",
                child: Row(
                  children: [
                    Icon(Icons.shuffle, color: Colors.green),
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text('Switch Days'),
                    ),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: "delete",
                child: Row(
                  children: [
                    Icon(
                      Icons.delete,
                      color: Theme.of(context).primaryColor,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text('Delete Activity'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
