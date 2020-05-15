import 'package:blimp/services/images.dart';
import 'package:blimp/services/suggestions.dart';
import 'package:blimp/styles/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:intl/intl.dart';
import 'package:recase/recase.dart';

class HotelOption extends StatefulWidget {
  final Map hotelDetails;
  final Key key;
  HotelOption({this.hotelDetails, this.key});
  @override
  State<StatefulWidget> createState() {
    return HotelOptionState(hotelDetails: hotelDetails, key: key);
  }
}

class HotelOptionState extends State<HotelOption> {
  final Map hotelDetails;
  final Key key;
  HotelOptionState({this.hotelDetails, this.key});
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: Stack(
            children: [
              hotelDetails["images"].length == 0
                  ? CachedNetworkImage(
                      imageUrl: getDefaultAccommodationImageURL(),
                      fit: BoxFit.cover,
                      width: 10000,
                      height: 250,
                    )
                  : SizedBox(
                      height: 250,
                      width: 100000,
                      child: Swiper(
                        onIndexChanged: (value) {
                          setState(() {
                            _currentIndex = value;
                          });
                        },
                        pagination: SwiperPagination(
                          margin:
                              EdgeInsets.only(left: 10, right: 10, bottom: 5),
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: hotelDetails["images"][index],
                            errorWidget: (context, url, error) => Image(
                              image: NetworkImage(
                                  getDefaultAccommodationImageURL()),
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                        itemCount: hotelDetails["images"].length,
                        viewportFraction: 1,
                        scale: 1,
                      ),
                    ),
              Positioned(
                left: 10,
                top: 10,
                child: Visibility(
                  visible: hotelDetails["rating"] != null,
                  child: RatingBox(rating: hotelDetails["rating"]),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10, right: 10, top: 10),
          child: HotelDetails(
            hotelDetails: hotelDetails,
          ),
        )
      ],
    );
  }
}

class RatingBox extends StatelessWidget {
  final double rating;
  RatingBox({this.rating});

  Color _getRatingColor() {
    if (rating >= 4.5) {
      return Color.fromRGBO(87, 227, 44, 0.9);
    } else if (rating >= 4) {
      return Color.fromRGBO(183, 221, 41, 0.9);
    } else if (rating >= 3.5) {
      return Color.fromRGBO(255, 226, 52, 1);
    } else if (rating >= 3) {
      return Color.fromRGBO(255, 165, 52, 0.9);
    } else {
      return Color.fromRGBO(255, 69, 69, 0.9);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _getRatingColor(),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Icon(
              Icons.star,
              size: 20,
              color: Color.fromRGBO(60, 60, 60, 1),
            ),
            Padding(
              padding: EdgeInsets.only(left: 5),
              child: Text(
                rating.toString(),
                style: Theme.of(context).textTheme.headline2.copyWith(
                      color: Color.fromRGBO(60, 60, 60, 1),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HotelDetails extends StatelessWidget {
  final Map hotelDetails;
  HotelDetails({this.hotelDetails});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.star,
                  size: 15,
                  color: Colors.grey,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Text(
                    hotelDetails["stars"].toString() + " stars",
                    style: Theme.of(context).textTheme.headline1,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 15,
                    color: Colors.grey,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text(
                      hotelDetails["hotelDistance"]["distance"].toString() +
                          " " +
                          hotelDetails["hotelDistance"]["distanceUnit"]
                              .toLowerCase() +
                          " from center",
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  Icon(
                    Icons.hotel,
                    size: 15,
                    color: Colors.grey,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text(
                      hotelDetails["nights"].toString() + " nights",
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            ReCase(hotelDetails["name"]).titleCase,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                NumberFormat.currency(
                        name: hotelDetails["price"]["currency"],
                        symbol: getCurrencySuggestions()[hotelDetails["price"]
                            ["currency"]]["symbol"])
                    .format(hotelDetails["price"]["amount"]),
                style: Theme.of(context)
                    .textTheme
                    .headline3
                    .copyWith(color: Theme.of(context).primaryColor),
              ),
              Row(
                children: [
                  Icon(Icons.hotel, size: 20),
                  Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text(
                      ReCase(hotelDetails["roomType"]["bedType"] ??
                              hotelDetails["roomType"]["category"])
                          .titleCase
                          .replaceAll("_", " "),
                    ),
                  ),
                ],
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
