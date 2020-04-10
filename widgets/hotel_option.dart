import 'package:blimp/services/images.dart';
import 'package:blimp/services/suggestions.dart';
import 'package:blimp/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class HotelOption extends StatelessWidget {
  final Map hotelDetails;
  HotelOption({this.hotelDetails});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: Image(
            image: NetworkImage(
              hotelDetails["image_url"] ?? getDefaultAccommodationImageURL(),
            ),
            width: 10000,
            height: 250,
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 20),
          child: HotelDetails(
            hotelDetails: hotelDetails,
          ),
        )
      ],
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
