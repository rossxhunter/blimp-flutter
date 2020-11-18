import 'package:blimp/screens/results/newActivity.dart';
import 'package:blimp/services/suggestions.dart';
import 'package:blimp/styles/colors.dart';
import 'package:blimp/widgets/fields.dart';
import 'package:blimp/widgets/hotel_option.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BrowseActivities extends StatefulWidget {
  final List allActivities;
  BrowseActivities({this.allActivities});
  @override
  State<StatefulWidget> createState() {
    return BrowseActivitiesState(allActivities: allActivities);
  }
}

class BrowseActivitiesState extends State<BrowseActivities> {
  final List allActivities;
  List validActivities;
  List chosenActivities = [];
  String searchTerm = "";
  BrowseActivitiesState({this.allActivities}) {
    validActivities = allActivities;
  }
  void typeNewActivity(String term) {
    setState(() {
      searchTerm = term;
      validActivities = _getValidActivities();
    });
  }

  List selectedCategories = [];

  void selectCategory(Map category, bool isSelected) {
    setState(() {
      if (isSelected) {
        selectedCategories.add(category);
      } else {
        selectedCategories.remove(category);
      }
      validActivities = _getValidActivities();
    });
  }

  void selectActivity(Map activity, bool isSelected) {
    setState(() {
      if (isSelected) {
        chosenActivities.add(activity);
      } else {
        chosenActivities.remove(activity);
      }
    });
  }

  List _getValidActivities() {
    List va = [];
    for (Map activity in allActivities) {
      if ((selectedCategories.length != 0 &&
              selectedCategories
                  .map((e) => e["name"])
                  .contains(activity["category"])) ||
          selectedCategories.length == 0) {
        if (searchTerm == "" ||
            suggestions
                .getSpecificActivitySuggestionsForQuery(
                    allActivities, searchTerm)
                .contains(activity)) {
          va.add(activity);
        }
      }
    }
    return va;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        centerTitle: false,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            FontAwesomeIcons.arrowLeft,
            color: Theme.of(context).primaryColor,
          ),
        ),
        title: Text(
          "Add Activities",
          style: Theme.of(context)
              .textTheme
              .headline4
              .copyWith(color: Theme.of(context).primaryColor),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 140),
                child: BrowseActivityOptions(
                  activities: validActivities,
                  chosenActivities: chosenActivities,
                  callback: selectActivity,
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    BrowseActivitiesSearchBar(
                      callback: typeNewActivity,
                      allActivities: allActivities,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: BrowseActivitiesCategoriesBar(
                        categories: suggestions
                            .getActivitySuggestions()
                            .getRange(0, 10)
                            .toList(),
                        selectedCategories: selectedCategories,
                        callback: selectCategory,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BrowseActivitiesCategoriesBar extends StatelessWidget {
  final List categories;
  final List selectedCategories;
  final Function callback;
  BrowseActivitiesCategoriesBar(
      {this.categories, this.selectedCategories, this.callback});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        // shrinkWrap: true,

        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () {
                callback(categories[index],
                    !selectedCategories.contains(categories[index]));
              },
              child: ActivityCategoryBox(
                category: categories[index],
                isSelected: selectedCategories.contains(categories[index]),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ActivityCategoryBox extends StatelessWidget {
  final Map category;
  final bool isSelected;
  ActivityCategoryBox({this.category, this.isSelected});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected
            ? Theme.of(context).primaryColor
            : CustomColors.lightGrey,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 0, bottom: 0, left: 10, right: 10),
        child: Center(
          child: Text(
            category["name"],
            style: Theme.of(context)
                .textTheme
                .headline2
                .copyWith(color: isSelected ? Colors.white : Colors.black),
          ),
        ),
      ),
    );
  }
}

class BrowseActivitiesSearchBar extends StatelessWidget {
  final Function callback;
  final List allActivities;
  BrowseActivitiesSearchBar({this.allActivities, this.callback});
  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      prefixIcon: FontAwesomeIcons.search,
      onChanged: (value) => callback(value),
    );
  }
}

class BrowseActivityOptions extends StatelessWidget {
  final List activities;
  final List chosenActivities;
  final Function callback;
  BrowseActivityOptions(
      {this.activities, this.callback, this.chosenActivities});
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: activities.length,
      itemBuilder: (context, index) {
        return BrowseActivityOption(
          activity: activities[index],
          isSelected: chosenActivities.contains(activities[index]),
          callback: callback,
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.6,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
    );
  }
}

class BrowseActivityOption extends StatelessWidget {
  final Map activity;
  final Function callback;
  final bool isSelected;
  BrowseActivityOption({this.activity, this.callback, this.isSelected});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: activity["images"][0],
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 5,
              left: 5,
              child: RatingBox(
                rating: activity["rating"],
                max: 5,
              ),
            ),
            Positioned(
              bottom: 5,
              right: 5,
              child: GestureDetector(
                onTap: () => callback(activity, !isSelected),
                child: SelectActivityIcon(
                  isSelected: isSelected,
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: 5),
          child: Text(
            activity["name"],
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
        Row(
          children: [
            Image(
              image: NetworkImage(
                activity["categoryIcon"] + "64.png",
              ),
              color: Colors.black,
              height: 30,
              width: 30,
            ),
            Text(activity["category"]),
          ],
        ),
      ],
    );
  }
}

class SelectActivityIcon extends StatelessWidget {
  final bool isSelected;
  SelectActivityIcon({
    this.isSelected,
    ValueKey<String> key,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected
            ? Theme.of(context).primaryColor
            : CustomColors.lightGrey,
        borderRadius: BorderRadius.circular(300),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Icon(
          FontAwesomeIcons.plus,
          color: isSelected ? Colors.white : Colors.grey,
        ),
      ),
    );
  }
}
