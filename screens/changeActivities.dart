import 'package:blimp/screens/flights.dart';
import 'package:blimp/screens/newActivity.dart';
import 'package:blimp/screens/results.dart';
import 'package:blimp/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:reorderables/reorderables.dart';

class ChangeActivitiesScreen extends StatefulWidget {
  final Map itinerary;
  final int day;

  ChangeActivitiesScreen({this.itinerary, this.day});
  @override
  State<StatefulWidget> createState() {
    return ChangeActivitiesScreenState(itinerary: itinerary, day: day);
  }
}

class ChangeActivitiesScreenState extends State<ChangeActivitiesScreen> {
  final Map itinerary;
  final int day;
  List _activities;

  ChangeActivitiesScreenState({this.itinerary, this.day});

  @override
  Widget build(BuildContext context) {
    ScrollController _scrollController =
        PrimaryScrollController.of(context) ?? ScrollController();
    _activities = itinerary[day.toString()];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          'Day ' + (day + 1).toString(),
          style: Theme.of(context)
              .textTheme
              .headline3
              .copyWith(color: Colors.white),
        ),
        leading: Padding(
          padding: EdgeInsets.only(left: 20),
          child: IconButton(
            icon: Icon(Icons.close),
            color: Colors.white,
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
              color: Colors.white,
              iconSize: 30,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => NewActivity(),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: IconButton(
              icon: Icon(Icons.add),
              color: Colors.white,
              iconSize: 30,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => NewActivity(),
                );
              },
            ),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 20, top: 10, left: 0, right: 0),
            child: CustomScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              controller: _scrollController,
              slivers: <Widget>[
                ReorderableSliverList(
                  delegate: ReorderableSliverChildListDelegate(
                      _getActivityRows(_activities, context)),
                  // or use ReorderableSliverChildBuilderDelegate if needed
//          delegate: ReorderableSliverChildBuilderDelegate(
//            (BuildContext context, int index) => _rows[index],
//            childCount: _rows.length
//          ),
                  onReorder: _onReorder,
                )
              ],
            ),
          ),
          Positioned.fill(
            top: null,
            bottom: 0,
            child: Container(
              color: Colors.transparent,
              child: Padding(
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 30),
                child: ConfirmButton(),
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
        Slidable(
          key: Key("${activity["name"]}"),
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          child: ListViewCard(
            child: ActivityOption(activity),
          ),
          actions: <Widget>[
            IconSlideAction(
              caption: 'Duration',
              color: Colors.blue,
              iconWidget: Padding(
                padding: EdgeInsets.only(
                  bottom: 10,
                ),
                child: Icon(
                  Icons.timer,
                  color: Colors.white,
                ),
              ),
              onTap: () => Scaffold.of(context)
                  .showSnackBar(SnackBar(content: Text('Yay! A SnackBar!'))),
            ),
            IconSlideAction(
              caption: 'Switch Days',
              color: Colors.indigo,
              iconWidget: Padding(
                padding: EdgeInsets.only(
                  bottom: 10,
                ),
                child: Icon(
                  Icons.shuffle,
                  color: Colors.white,
                ),
              ),
              // onTap: () => _showSnackBar('Share'),
            ),
          ],
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: 'Delete',
              color: Colors.red,
              icon: Icons.delete,
              onTap: () => Scaffold.of(context)
                  .showSnackBar(SnackBar(content: Text('Yay! A SnackBar!'))),
            ),
          ],
        ),
      );
    }
    return rows;
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      Map temp = _activities[oldIndex];
      _activities.removeAt(oldIndex);
      _activities.insert(newIndex, temp);
    });
  }
}

class ListViewCard extends StatelessWidget {
  final Widget child;
  // final Key key;

  ListViewCard({this.child});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20, top: 20, left: 30, right: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: child,
          ),
          Icon(
            Icons.reorder,
            color: Color.fromRGBO(210, 210, 210, 1),
          ),
        ],
      ),
    );
  }
}
