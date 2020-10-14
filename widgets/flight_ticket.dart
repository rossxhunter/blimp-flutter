import 'package:auto_size_text/auto_size_text.dart';
import 'package:blimp/services/suggestions.dart';
import 'package:blimp/styles/colors.dart';
import 'package:blimp/styles/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class FlightTicket extends StatelessWidget {
  final Map ticketDetails;
  FlightTicket({this.ticketDetails});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10.0,
            spreadRadius: 0,
            offset: Offset(0, 5),
          )
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: 10),
              child: FlightTicketLogistics(
                ticketDetails: ticketDetails,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: Dash(
                dashColor: Colors.grey,
                dashGap: 5,
                length: 280,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: FlightTicketDetails(
                ticketDetails: ticketDetails,
              ),
            ),
          ],
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
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withOpacity(0.4),
        //     blurRadius: 10.0,
        //     spreadRadius: 0,
        //     offset: Offset(0, 5),
        //   )
        // ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: CachedNetworkImage(
              alignment: Alignment.centerLeft,
              errorWidget: (context, url, error) => Row(
                children: [
                  Icon(
                    Icons.flight_takeoff,
                    size: 20,
                    color: Theme.of(context).primaryColor,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text(
                        ticketDetails["carrierName"],
                        style: Theme.of(context).textTheme.headline2,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ),
                ],
              ),
              imageUrl: ticketDetails["carrierLogo"],
              height: 30,
              width: 90,
            ),
          ),
          AutoSizeText(
            NumberFormat.currency(
                    name: ticketDetails["price"]["currency"],
                    symbol: suggestions.getCurrencySuggestions()[
                        ticketDetails["price"]["currency"]]["symbol"])
                .format(ticketDetails["price"]["amount"]),
            maxLines: 1,
            style: textThemes["ticket_header_1"],
          ),
        ],
      ),
    );
  }
}

class FlightTicketLogistics extends StatelessWidget {
  final Map ticketDetails;
  FlightTicketLogistics({this.ticketDetails});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withOpacity(0.4),
        //     blurRadius: 10.0,
        //     spreadRadius: 0,
        //     offset: Offset(0, 5),
        //   )
        // ],
      ),
      child: Column(
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
                  // Text(ticketDetails["departure"]["time"]),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Text(
                      ticketDetails["departure"]["airportCode"],
                      style: Theme.of(context).textTheme.headline3.copyWith(
                          color: ticketDetails["journey"] == "Outbound"
                              ? Colors.orange
                              : Colors.blue),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Text(
                      ticketDetails["origin"],
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ticketDetails["journey"] == "Outbound"
                              ? Colors.orange
                              : Colors.blue,
                        ),
                        width: 10,
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Dash(
                          length: 30,
                          dashColor: Colors.grey,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Icon(
                          FontAwesomeIcons.plane,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Dash(
                          length: 30,
                          dashColor: Colors.grey,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: ticketDetails["journey"] == "Return"
                                ? Colors.orange
                                : Colors.blue,
                          ),
                          width: 10,
                          height: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  // Text(),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Text(
                      ticketDetails["arrival"]["airportCode"],
                      style: Theme.of(context).textTheme.headline3.copyWith(
                          color: ticketDetails["journey"] == "Return"
                              ? Colors.orange
                              : Colors.blue),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Text(
                      ticketDetails["destination"],
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  ticketDetails["departure"]["time"],
                  style: Theme.of(context).textTheme.headline3,
                ),
                Text(
                  ticketDetails["arrival"]["time"],
                  style: Theme.of(context).textTheme.headline3,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  // (ticketDetails["duration"] ~/ 60).toString() +
                  //     "h " +
                  //     ticketDetails["duration"]
                  //         .remainder(60)
                  //         .toString() +
                  //     "m",
                  DateFormat("d MMM").format(
                      DateTime.parse(ticketDetails["departure"]["date"])),
                  style: Theme.of(context).textTheme.headline2,
                ),
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
    );
  }
}
