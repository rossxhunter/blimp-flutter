import 'package:blimp/services/images.dart';
import 'package:blimp/styles/colors.dart';
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
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.only(bottom: 20),
        decoration: new BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(20),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black26,
          //     blurRadius: 10.0,
          //     offset: const Offset(0.0, 10.0),
          //   ),
          // ],
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
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          child: Image(
            image: NetworkImage(
              activity["bestPhoto"] ?? getDefaultActivityImageURL(),
            ),
            width: 10000,
            height: 250,
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 20),
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
                    Container(
                      decoration: BoxDecoration(
                        color: CustomColors.redGrey,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 5, bottom: 5, left: 10, right: 10),
                        child: Text(
                          activity["category"],
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.headline1,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.lightGreen,
                          borderRadius: BorderRadius.circular(300),
                        ),
                        child: Visibility(
                          visible: activity["rating"] != 0,
                          child: Padding(
                            padding: EdgeInsets.all(10),
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
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  activity["description"] ?? "",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
