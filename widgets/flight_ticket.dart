import 'package:blimp/services/suggestions.dart';
import 'package:blimp/styles/colors.dart';
import 'package:blimp/styles/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class FlightTicket extends StatelessWidget {
  final Map ticketDetails;
  FlightTicket({this.ticketDetails});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: CustomColors.lightGrey,
          width: 2,
        ),
      ),
      // height: 150,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: IntrinsicHeight(
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                flex: 1,
                child: FlightTicketDetails(
                  ticketDetails: ticketDetails,
                ),
              ),
              Flexible(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: FlightTicketLogistics(
                    ticketDetails: ticketDetails,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FlightTicketDetails extends StatelessWidget {
  final Map ticketDetails;
  FlightTicketDetails({this.ticketDetails});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Wrap(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: CustomColors.redLowOpacity,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        ticketDetails["class"].toString().replaceAll("_", " "),
                        maxLines: 2,
                        textWidthBasis: TextWidthBasis.longestLine,
                        softWrap: true,
                        style: Theme.of(context)
                            .textTheme
                            .headline1
                            .copyWith(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Row(
            children: <Widget>[
              Text(
                NumberFormat.currency(
                        name: ticketDetails["price"]["currency"],
                        symbol: getCurrencySuggestions()[ticketDetails["price"]
                            ["currency"]]["symbol"])
                    .format(ticketDetails["price"]["amount"]),
                style: textThemes["ticket_header_1"],
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              CachedNetworkImage(
                errorWidget: (context, url, error) => Icon(
                  Icons.flight_takeoff,
                  size: 20,
                  color: Theme.of(context).primaryColor,
                ),
                imageUrl: ticketDetails["carrierLogo"],
                height: 20,
                width: 20,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Text(
                    ticketDetails["carrierName"],
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
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

class FlightTicketLogistics extends StatelessWidget {
  final Map ticketDetails;
  FlightTicketLogistics({this.ticketDetails});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text(ticketDetails["departure"]["airportCode"]),
                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    ticketDetails["departure"]["time"],
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    DateFormat("d MMM").format(
                      DateTime.parse(ticketDetails["departure"]["date"]),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.arrow_forward,
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(ticketDetails["arrival"]["airportCode"]),
                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    ticketDetails["arrival"]["time"],
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(DateFormat("d MMM").format(
                      DateTime.parse(ticketDetails["arrival"]["date"]))),
                ),
              ],
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.swap_vert,
                    size: 20,
                    color: Theme.of(context).primaryColor,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text(
                      ticketDetails["journey"],
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.timer,
                    size: 20,
                    color: Theme.of(context).primaryColor,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text(
                      (ticketDetails["duration"] ~/ 60).toString() +
                          "h " +
                          ticketDetails["duration"].remainder(60).toString() +
                          "m",
                      style: Theme.of(context).textTheme.bodyText2,
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
