import 'package:blimp/services/suggestions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class HotelOption extends StatelessWidget {
  final Map hotelDetails;
  HotelOption({this.hotelDetails});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Color.fromRGBO(230, 230, 230, 0.8),
          width: 2,
        ),
      ),
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            child: Image(
              image: NetworkImage(hotelDetails["image_url"] ??
                  "https://www.businesstravelnewseurope.com/uploadedImages/1_Sections/Lodging/Generic%20hotel%20room.jpg"),
              fit: BoxFit.fill,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: HotelDetails(
              hotelDetails: hotelDetails,
            ),
          ),
        ],
      ),
    );
  }
}

class HotelDetails extends StatelessWidget {
  final Map hotelDetails;
  HotelDetails({this.hotelDetails});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                hotelDetails["name"],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headline2,
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: StarRating(
                  numStars: hotelDetails["stars"],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20),
          child: Column(
            children: <Widget>[
              Text(
                NumberFormat.currency(
                        name: hotelDetails["price"]["currency"],
                        symbol: getCurrencySuggestions()[hotelDetails["price"]
                            ["currency"]]["symbol"])
                    .format(hotelDetails["price"]["amount"]),
                style: Theme.of(context).textTheme.headline2,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class StarRating extends StatelessWidget {
  final int numStars;
  StarRating({this.numStars});
  @override
  Widget build(BuildContext context) {
    return Row(children: getStars());
  }

  List<Widget> getStars() {
    List<Widget> stars = List<Widget>();
    for (int i = 0; i < numStars; i++) {
      stars.add(Icon(Icons.star, color: Colors.yellow));
    }
    return stars;
  }
}
