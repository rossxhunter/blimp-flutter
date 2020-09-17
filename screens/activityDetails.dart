import 'package:blimp/services/images.dart';
import 'package:blimp/styles/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ActivityDetails extends StatelessWidget {
  final Map activity;

  ActivityDetails({this.activity});
  @override
  Widget build(BuildContext context) {
    return ActivityDetailsDialog(
      activity: activity,
    );
  }
}

class ActivityDetailsDialog extends StatelessWidget {
  final Map activity;

  ActivityDetailsDialog({this.activity});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(30),
        ),
        child: ActivityDetailsOption(
          activity: activity,
        ),
      ),
    );
  }
}

class ActivityDetailsOption extends StatelessWidget {
  final Map activity;

  ActivityDetailsOption({this.activity});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: CachedNetworkImage(
            imageUrl: activity["bestPhoto"] ?? getDefaultActivityImageURL(),
            width: 10000,
            height: 250,
            fit: BoxFit.cover,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)),
            // border: Border.all(
            //   color: CustomColors.lightGrey,
            //   width: 4,
            // ),
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  activity["name"],
                  style: Theme.of(context).textTheme.headline3,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Row(
                          children: [
                            Image(
                              image: NetworkImage(
                                activity["categoryIcon"] + "64.png",
                              ),
                              color: Colors.black,
                              height: 30,
                              width: 30,
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: Text(
                                  activity["category"],
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                  maxLines: 2,
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.lightGreen,
                            shape: BoxShape.circle,
                          ),
                          child: Visibility(
                            visible: activity["rating"] != 0,
                            child: Padding(
                              padding: EdgeInsets.all(12),
                              child: Text(
                                activity["rating"].toString(),
                                style: Theme.of(context).textTheme.button,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: activity["description"] != null &&
                      activity["description"] != "",
                  child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Description",
                          style: Theme.of(context).textTheme.headline2,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: ConstrainedBox(
                            constraints: new BoxConstraints(
                              minHeight: 0,
                              maxHeight: 100,
                            ),
                            child: SingleChildScrollView(
                              child: Text(
                                activity["description"] ??
                                    activity["name"] +
                                        " is a " +
                                        activity["category"],
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
