import 'package:blimp/configurations.dart';
import 'package:blimp/model/preferences.dart';
import 'package:blimp/screens/results.dart';
import 'package:blimp/services/http.dart';
import 'package:blimp/widgets/alerts.dart';
import 'package:blimp/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

final List<String> _tabsString = <String>[
  "For You",
  "Popular",
  "Inspiration",
  "Tours",
  "Europe",
];

List<Widget> _tabs = [
  Tab(
    child: Align(
      alignment: Alignment.center,
      child: Text(_tabsString[0]),
    ),
  ),
  Tab(
    child: Align(
      alignment: Alignment.center,
      child: Text(_tabsString[1]),
    ),
  ),
  Tab(
    child: Align(
      alignment: Alignment.center,
      child: Text(_tabsString[2]),
    ),
  ),
  Tab(
    child: Align(
      alignment: Alignment.center,
      child: Text(_tabsString[3]),
    ),
  ),
  Tab(
    child: Align(
      alignment: Alignment.center,
      child: Text(_tabsString[4]),
    ),
  ),
];

class ExplorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 0, right: 0, bottom: 0, top: 20),
      child: DefaultTabController(
        length: _tabs.length,
        child: NestedScrollView(
          physics: BouncingScrollPhysics(),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                child: SliverSafeArea(
                  top: false,
                  sliver: SliverPadding(
                    padding: EdgeInsets.only(left: 30.0, right: 20),
                    sliver: SliverAppBar(
                      backgroundColor: Colors.white,
                      floating: true,
                      pinned: true,
                      snap: true,
                      primary: true,
                      centerTitle: false,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Explore",
                              style: Theme.of(context).textTheme.headline4),
                          Padding(
                            padding:
                                EdgeInsets.only(right: 10, bottom: 20, top: 10),
                            child: RandomHolidayButton(),
                          ),
                        ],
                      ),
                      expandedHeight: 120,
                      elevation: 0,
                      titleSpacing: 0,
                      bottom: TabBar(
                        isScrollable: true,
                        unselectedLabelColor: Theme.of(context).primaryColor,
                        labelStyle: Theme.of(context).textTheme.body2,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicator: BoxDecoration(
                          // gradient: LinearGradient(
                          //     colors: [Colors.redAccent, Colors.pinkAccent]),
                          borderRadius: BorderRadius.circular(30),
                          color: Theme.of(context).primaryColor,
                        ),
                        tabs: _tabs,
                      ),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: ExplorePageTabView(),
        ),
      ),
    );
  }
}

class ExplorePageTabView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TabBarView(
      physics: AlwaysScrollableScrollPhysics(),
      children: _tabsString.map((String name) {
        return SafeArea(
          top: false,
          bottom: false,
          child: Builder(
            builder: (BuildContext context) {
              return Padding(
                padding: EdgeInsets.only(top: 16),
                child: CustomScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  key: PageStorageKey<String>(name),
                  slivers: <Widget>[
                    SliverOverlapInjector(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                          context),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.only(left: 30, right: 30),
                      sliver: SliverFixedExtentList(
                        itemExtent: 120.0,
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 20),
                              child: ExploreOption(
                                index: index,
                                name: name,
                              ),
                            );
                          },
                          childCount: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }).toList(),
    );
  }
}

class RandomHolidayButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.white,
      elevation: 3,
      highlightElevation: 5,
      child: Icon(
        Icons.casino,
        color: Theme.of(context).primaryColor,
        size: 30,
      ),
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return loadingIndicator;
            });
        Preferences prefs = prefsConfig[0];
        getHoliday(prefs).then((holiday) {
          print(holiday);
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultsPage(
                name: holiday["name"],
                wiki: holiday["wiki"],
                itinerary: holiday["itinerary"],
                flights: holiday["travel"],
                accommodation: holiday["accommodation"],
              ),
            ),
          );
        }).catchError((e) {
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (BuildContext context) => CustomDialog(
              title: "Error",
              description: "Unable to fetch itinerary :(",
            ),
          );
        });
      },
    );
  }
}

class ExploreOption extends StatelessWidget {
  final int index;
  final String name;
  ExploreOption({this.index, this.name});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          child: Container(
            decoration:
                BoxDecoration(color: Color.fromRGBO(240, 240, 240, 0.8)),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          child: Row(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                child: Container(
                  height: 100,
                  width: 140,
                  child: Image(
                    image: AssetImage('assets/images/paris.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 20, right: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Paris ',
                        style: Theme.of(context).textTheme.headline2,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              'The captital of France, a beautiful city with pretty buildings and parks',
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              maxLines: 2,
                              style: Theme.of(context).textTheme.headline1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
