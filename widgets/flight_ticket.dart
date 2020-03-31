import 'package:blimp/services/suggestions.dart';
import 'package:blimp/styles/text.dart';
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
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Color.fromRGBO(230, 230, 230, 0.8),
          width: 2,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FlightTicketDetails(
              ticketDetails: ticketDetails,
            ),
            FlightTicketLogistics(
              ticketDetails: ticketDetails,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(ticketDetails["class"]),
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
              Text(ticketDetails["carrierCode"]),
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
      children: <Widget>[
        Row(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(ticketDetails["departure"]["airportCode"]),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    ticketDetails["departure"]["time"],
                    style: textThemes["ticket_header_2"],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(ticketDetails["departure"]["date"]),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Icon(
                    Icons.arrow_forward,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(ticketDetails["arrival"]["airportCode"]),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    ticketDetails["arrival"]["time"],
                    style: textThemes["ticket_header_2"],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(ticketDetails["arrival"]["date"]),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: <Widget>[],
        ),
      ],
    );
  }
}
