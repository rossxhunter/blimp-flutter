import 'dart:ui';

import 'package:blimp/model/preferences.dart';
import 'package:blimp/screens/results/activitiesOptions.dart';
import 'package:blimp/screens/explore.dart';
import 'package:blimp/screens/results/flights.dart';
import 'package:blimp/screens/results/newActivity.dart';
import 'package:blimp/screens/results/results.dart';
import 'package:blimp/services/http.dart';
import 'package:blimp/styles/colors.dart';
import 'package:blimp/widgets/alerts.dart';
import 'package:blimp/widgets/buttons.dart';
import 'package:blimp/widgets/selectors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:popup_menu/popup_menu.dart';
import 'package:reorderables/reorderables.dart';

class ChangeActivitiesScreen extends StatefulWidget {
  final List itinerary;
  final List allActivities;
  final Map travel;
  final Map accommodation;
  final Preferences preferences;
  final int day;
  final String mode;
  final int destId;
  final List<List<double>> windows;
  final int itinNum;

  ChangeActivitiesScreen(
      {this.itinerary,
      this.day,
      this.allActivities,
      this.travel,
      this.mode,
      this.accommodation,
      this.preferences,
      this.destId,
      this.itinNum,
      this.windows});
  @override
  State<StatefulWidget> createState() {
    return ChangeActivitiesScreenState(
        itinerary: itinerary,
        day: day,
        allActivities: allActivities,
        travel: travel,
        accommodation: accommodation,
        preferences: preferences,
        destId: destId,
        mode: mode,
        itinNum: itinNum,
        windows: windows);
  }
}

class ChangeActivitiesScreenState extends State<ChangeActivitiesScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  List itinerary;
  int day;
  final List allActivities;
  final Map travel;
  final Map accommodation;
  final Preferences preferences;
  final int destId;
  final int itinNum;
  final String mode;
  List<List> _activities;
  List<double> windowTimes;
  List<List<double>> windows;

  ChangeActivitiesScreenState(
      {this.itinerary,
      this.day,
      this.allActivities,
      this.travel,
      this.destId,
      this.itinNum,
      this.mode,
      this.accommodation,
      this.preferences,
      this.windows}) {
    _activities = List<List>();
    for (int i = 0; i < itinerary.length; i++) {
      _activities.add(List());
      for (Map activity in itinerary[i]) {
        _activities[i].add(activity);
      }
    }
  }

  void addNewActivity(Map activity) {
    List<Map> newActivities = List<Map>();
    for (Map a in _activities[day]) {
      newActivities.add(a);
    }
    newActivities.add(activity);
    mode == "standard"
        ? getItineraryFromActivities(newActivities, day, travel, accommodation,
            preferences, windows[day], destId)
        : getEvaluationItineraryFromActivities(
            newActivities, day, destId, windows[day])
      ..then((newItineraryActivities) {
        setState(() {
          _activities[day] = newItineraryActivities;
          registerClick("add_activity", mode, {
            "poi_id": activity["id"],
            "dest_id": destId,
            "itinNum": itinNum,
          });
        });
      }).catchError((e) {
        showErrorToast(context, "Unable to add activity - " + e.toString());
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

  void changeDuration(Map changedActivity, int duration) {
    List<Map> newActivities = List<Map>();
    for (Map a in _activities[day]) {
      newActivities.add(Map.from(a));
      if (a == changedActivity) {
        newActivities.last["duration"] = duration;
      }
    }
    mode == "standard"
        ? getItineraryFromActivities(newActivities, day, travel, accommodation,
            preferences, windows[day], destId)
        : getEvaluationItineraryFromActivities(
            newActivities, day, destId, windows[day])
      ..then((newItineraryActivities) {
        setState(() {
          _activities[day] = newItineraryActivities;
          _isScreenDisabled = false;
          registerClick("change_duration", mode, {
            "dest_id": destId,
            "poi_id": changedActivity["id"],
            "itinNum": itinNum,
            "new_duration": duration
          });
        });
      }).catchError((e) {
        showErrorToast(context, "Unable to change duration - " + e.toString());
      });
  }

  void removeActivity(Map activity) {
    _activities[day].remove(activity);
    List<Map> pendingActivties = List<Map>();
    for (int i = 0; i < _activities[day].length; i++) {
      pendingActivties.add(Map.from(_activities[day][i]));
      pendingActivties.last["startTime"] = -1;
      pendingActivties.last["travelTimeToNext"] = -1;
    }
    setState(() {
      _activities[day] = pendingActivties;
    });
    mode == "standard"
        ? getItineraryFromActivities(_activities[day], day, travel,
            accommodation, preferences, windows[day], destId)
        : getEvaluationItineraryFromActivities(
            _activities[day], day, destId, windows[day])
      ..then((newItineraryActivities) {
        setState(() {
          _activities[day] = newItineraryActivities;
          _isScreenDisabled = false;
          registerClick("delete_activity", mode, {
            "dest_id": destId,
            "poi_id": activity["id"],
            "itinNum": itinNum,
          });
        });
      }).catchError((e) {
        showErrorToast(context, "Unable to change duration - " + e.toString());
      });
  }

  void updateWindowTimes(List<double> times) {
    mode == "standard"
        ? getItineraryFromActivities(_activities[day], day, travel,
            accommodation, preferences, times, destId)
        : getEvaluationItineraryFromActivities(
            _activities[day], day, destId, times)
      ..then((newItineraryActivities) {
        setState(() {
          _activities[day] = newItineraryActivities;
          _isScreenDisabled = false;
          windows[day] = times;
          registerClick("update_window", mode,
              {"dest_id": destId, "itinNum": itinNum, "new_times": times});
        });
      }).catchError((e) {
        showErrorToast(context, "Unable to change window - " + e.toString());
      });
  }

  bool _isScreenDisabled = false;

  @override
  Widget build(BuildContext context) {
    void activityAction(String action, Map activity) {
      if (action == "delete") {
        setState(() {
          removeActivity(activity);
        });
      } else if (action == "changeDuration") {
        int hours = activity["duration"] ~/ (60 * 60);
        int minutes = (activity["duration"] - (hours * 60 * 60)) ~/ 60;
        showDialog(
            context: context,
            builder: (BuildContext builder) {
              return ChangeDuration(
                  callback: (duration) => changeDuration(activity, duration),
                  hours: hours,
                  minutes: minutes);
            });
      } else if (action == "switchDays") {}
    }

    List<Widget> _getActivityRows(List activities) {
      List<Widget> rows = [];
      int i = 0;
      for (Map activity in activities) {
        rows.add(
          ListViewCard(
            key: Key(activity["id"] +
                activity["startTime"].toString() +
                activity["duration"].toString()),
            activity: activity,
            actionCallback: activityAction,
            reorderCallback: _onReorder,
            travelCallback: changeTravelMethod,
            index: i,
            length: activities.length,
          ),
        );
        i += 1;
      }
      return rows;
    }

    PopupMenu.context = context;
    TabController _controller =
        TabController(vsync: this, length: itinerary.length, initialIndex: day);
    _controller.addListener(() {
      setState(() {
        day = _controller.index;
      });
    });
    super.build(context);
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
                    icon: Icon(
                      FontAwesomeIcons.slidersH,
                      size: 20,
                    ),
                    color: Theme.of(context).primaryColor,
                    iconSize: 30,
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierColor: Color.fromRGBO(40, 40, 40, 0.2),
                        builder: (BuildContext context) => ActivitiesOptions(
                          callback: updateWindowTimes,
                          windowTimes: windows[day],
                        ),
                      );
                    },
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
                    tabs: _getActivityTabs(itinerary.length),
                  ),
                  Expanded(
                    child: TabBarView(
                        controller: _controller,
                        physics: AlwaysScrollableScrollPhysics(),
                        children: _getTabNums(itinerary.length).map((int d) {
                          return Padding(
                            padding: EdgeInsets.only(
                                bottom: 80, top: 10, left: 10, right: 10),
                            child: LayoutBuilder(
                              builder: (context, constraint) {
                                return Stack(
                                  children: <Widget>[
                                    ListView.builder(
                                        itemCount:
                                            _getActivityRows(_activities[d])
                                                .length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return _getActivityRows(
                                              _activities[d])[index];
                                        }),

                                    // Stack(
                                    //   children: getTravelTimeWidgets(
                                    //       _activities[d]),
                                    // ),
                                    // Padding(
                                    //   padding: EdgeInsets.only(
                                    //       left: 20, top: 60),
                                    //   child: ActivitiesBar(
                                    //     activities: _activities[d],
                                    //     callback: activityAction,
                                    //     key: Key(d.toString()),
                                    //   ),
                                    // ),
                                  ],
                                );
                              },
                            ),
                          );
                        }).toList()),
                  ),
                ],
              ),
            ),
          ),
          Positioned.fill(
            top: null,
            bottom: 0,
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 30),
                child: AnimatedButton(
                  callback: () {
                    for (int i = 0; i < _activities.length; i++) {
                      itinerary[i] = _activities[i];
                    }
                    // Future.delayed(Duration(microseconds: 10000), () {
                    Navigator.of(context).pop();
                    // });
                    showSuccessToast(context, "Activities Updated");
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

  void changeTravelMethod(int journeyNum, String method) {
    String oldMethod = _activities[day][journeyNum]["travelMethodToNext"];
    List<Map> newActivities = List<Map>();
    for (int i = 0; i < _activities[day].length; i++) {
      newActivities.add(Map.from(_activities[day][i]));
      if (i == journeyNum) {
        newActivities[i]["travelMethodToNext"] = method;
        newActivities[i]["travelMethodChanged"] = true;
      }
    }
    mode == "standard"
        ? getItineraryFromActivities(newActivities, day, travel, accommodation,
            preferences, windows[day], destId)
        : getEvaluationItineraryFromActivities(
            newActivities, day, destId, windows[day])
      ..then((newItineraryActivities) {
        setState(() {
          _activities[day] = newItineraryActivities;
          _isScreenDisabled = false;
          registerClick("change_travel_method", mode, {
            "dest_id": destId,
            "poi_id": _activities[day][journeyNum]["id"],
            "itinNum": itinNum,
            "new_method": method
          });
        });
      }).catchError((e) {
        setState(() {
          _activities[day][journeyNum]["travelMethodToNext"] = oldMethod;
          _activities[day][journeyNum]["travelMethodChanged"] = false;
        });
        showErrorToast(
            context, "Unable to change travel method - " + e.toString());
      });
  }

  List<Widget> getTravelTimeWidgets(List activities) {
    List<Widget> widgetList = List<Widget>();
    for (int i = 0; i < activities.length - 1; i++) {
      widgetList.add(
        Padding(
          padding: EdgeInsets.only(top: 70 + 65.0 + 160 * i, left: 50),
          child: Row(
            key: Key(
              activities[i]["id"] +
                  activities[i]["startTime"].toString() +
                  activities[i]["travelTimeToNext"].toString(),
            ),
            children: [
              TravelMethodSelector(
                callback: changeTravelMethod,
                journey: i,
                method: activities[i]["travelMethodToNext"],
                key: Key(activities[i]["travelMethodToNext"]),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10, top: 5),
                child: Text(activities[i]["travelTimeToNext"] == -1
                    ? "..."
                    : (activities[i]["travelTimeToNext"] ~/ 60).toString() +
                        " mins"),
              ),
            ],
          ),
        ),
      );
    }
    return widgetList;
  }

  void _onReorder(int oldIndex, int newIndex) {
    _isScreenDisabled = true;
    List<String> poiIds = [
      _activities[day][oldIndex]["id"],
      _activities[day][newIndex]['id']
    ];
    List<Map> oldActivities = List.from(_activities[day]);
    List<Map> newActivities = List.from(_activities[day]);
    Map a = newActivities.removeAt(oldIndex);
    newActivities.insert(newIndex, a);
    List<Map> pendingActivties = List<Map>();
    for (int i = 0; i < newActivities.length; i++) {
      pendingActivties.add(Map.from(newActivities[i]));
      pendingActivties.last["startTime"] = -1;
      pendingActivties.last["travelTimeToNext"] = -1;
    }
    setState(() {
      _activities[day] = pendingActivties;
    });
    mode == "standard"
        ? getItineraryFromActivities(newActivities, day, travel, accommodation,
            preferences, windows[day], destId)
        : getEvaluationItineraryFromActivities(
            newActivities, day, destId, windows[day])
      ..then((newItineraryActivities) {
        setState(() {
          _activities[day] = newItineraryActivities;
          _isScreenDisabled = false;
        });
        registerClick("reorder_activities", mode, {
          "dest_id": destId,
          "poi_ids": poiIds,
          "itinNum": itinNum,
        });
      }).catchError((e) {
        setState(() {
          _activities[day] = oldActivities;
          _isScreenDisabled = false;
        });
        showErrorToast(
            context, "Unable to reorder activities - " + e.toString());
      });
  }

  @override
  bool get wantKeepAlive => true;
}

class ActivitiesBar extends StatelessWidget {
  final List activities;
  final Key key;
  final Function callback;
  ActivitiesBar({this.activities, this.key, this.callback});

  Widget getExtraActivityBars(int index, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 5, left: 10),
          child: Dash(
            direction: Axis.vertical,
            length: 100,
            dashColor: Color.fromRGBO(220, 220, 220, 1),
            dashGap: 4,
            dashThickness: 2,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 5),
          child: Column(
            children: [
              Icon(
                FontAwesomeIcons.chevronUp,
                color: Theme.of(context).primaryColor,
              ),
              EditActivityPopupMenuButton(
                callback: callback,
                activity: activities[index],
              ),
              Icon(
                FontAwesomeIcons.chevronDown,
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (activities.length == 0) {
      return Container(
        height: 0,
        width: 0,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 25,
          child: EditActivityPopupMenuButton(
            callback: callback,
            activity: activities[0],
          ),
        ),
        Expanded(
          child: SizedBox(
            width: 25,
            child: ListView.builder(
                itemCount: activities.length - 1,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return getExtraActivityBars(index + 1, context);
                }),
          ),
        ),
      ],
    );
  }
}

class EditActivityPopupMenuButton extends StatelessWidget {
  final Function callback;
  final Map activity;
  EditActivityPopupMenuButton({this.callback, this.activity});
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: CustomColors.lightGrey, width: 2),
      ),
      elevation: 0,
      padding: EdgeInsets.zero,
      tooltip: "Actions",
      onSelected: (value) {
        callback(value, activity);
      },
      icon: Icon(
        Icons.edit,
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
        // PopupMenuItem<String>(
        //   value: "switchDays",
        //   child: Row(
        //     children: [
        //       Icon(
        //         Icons.shuffle,
        //         color: Colors.green,
        //       ),
        //       Padding(
        //         padding: EdgeInsets.only(left: 5),
        //         child: Text('Switch Days'),
        //       ),
        //     ],
        //   ),
        // ),
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
    );
  }
}

class ChangeDuration extends StatefulWidget {
  final int hours;
  final int minutes;
  final Function callback;

  ChangeDuration({this.callback, this.hours, this.minutes});
  @override
  State<StatefulWidget> createState() {
    return ChangeDurationState(
        callback: callback, hours: hours, minutes: minutes);
  }
}

class ChangeDurationState extends State<ChangeDuration> {
  final int hours;
  final int minutes;
  int duration;
  final Function callback;

  ChangeDurationState({this.callback, this.hours, this.minutes}) {
    duration = (hours * 60 * 60) + minutes * 60;
  }
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0.0,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoTimerPicker(
              onTimerDurationChanged: (value) {
                setState(() {
                  duration = value.inSeconds;
                });
              },
              mode: CupertinoTimerPickerMode.hm,
              minuteInterval: 5,
              initialTimerDuration: Duration(hours: hours, minutes: minutes),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: AnimatedButton(
                callback: () {
                  callback(duration);
                  Navigator.pop(context);
                },
                child: ConfirmButton(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ListViewCard extends StatelessWidget {
  final Map activity;
  final Function actionCallback;
  final Function reorderCallback;
  final Function travelCallback;
  final Key key;
  final int index;
  final int length;

  ListViewCard(
      {this.activity,
      this.actionCallback,
      this.reorderCallback,
      this.travelCallback,
      this.key,
      this.index,
      this.length});

  @override
  Widget build(BuildContext context) {
    Widget child = ActivityOption(activity: activity);
    return Padding(
      padding: EdgeInsets.only(bottom: 0, top: 20, left: 0, right: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: Column(
                  children: [
                    index != 0
                        ? AnimatedButton(
                            callback: () => reorderCallback(index, index - 1),
                            child: Icon(
                              FontAwesomeIcons.chevronUp,
                              color: Theme.of(context).primaryColor,
                            ),
                          )
                        : Container(
                            height: 0,
                            width: 0,
                          ),
                    EditActivityPopupMenuButton(
                      activity: activity,
                      callback: actionCallback,
                    ),
                    index != length - 1
                        ? AnimatedButton(
                            callback: () => reorderCallback(index, index + 1),
                            child: Icon(
                              FontAwesomeIcons.chevronDown,
                              color: Theme.of(context).primaryColor,
                            ),
                          )
                        : Container(
                            height: 0,
                            width: 0,
                          ),
                  ],
                ),
              ),
              Expanded(
                child: child,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 60, top: 10),
            child: activity["travelTimeToNext"] != null
                ? Row(
                    key: Key(
                      activity["id"] +
                          activity["startTime"].toString() +
                          activity["travelTimeToNext"].toString(),
                    ),
                    children: [
                      TravelMethodSelector(
                        callback: travelCallback,
                        journey: index,
                        method: activity["travelMethodToNext"],
                        key: Key(activity["travelMethodToNext"]),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10, top: 5),
                        child: Text(activity["travelTimeToNext"] == -1
                            ? "..."
                            : (activity["travelTimeToNext"] ~/ 60).toString() +
                                " mins"),
                      ),
                    ],
                  )
                : Container(
                    height: 0,
                    width: 0,
                  ),
          ),
        ],
      ),
    );
  }
}
