import 'package:blimp/screens/filterFlights.dart';
import 'package:blimp/styles/colors.dart';
import 'package:blimp/widgets/flight_ticket.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class FlightsScreen extends StatefulWidget {
  final List allFlights;
  FlightsScreen({this.allFlights});

  @override
  State<StatefulWidget> createState() {
    return FlightsScreenState(allFlights: allFlights);
  }
}

class FlightsScreenState extends State<FlightsScreen> {
  final List allFlights;
  List shownFlights;
  int _selectedFlight = 0;
  List<double> _outboundTimes = [6.0, 18.0];
  List<double> _returnTimes = [6.0, 18.0];

  FlightsScreenState({this.allFlights}) {
    shownFlights = List.from(allFlights);
  }

  void filterFlights(List outboundTimes, List returnTimes) {
    _outboundTimes = outboundTimes;
    _returnTimes = returnTimes;
    shownFlights = List.from(allFlights);

    setState(() {
      shownFlights.removeWhere((e) {
        DateTime outboundDepartureTime =
            DateFormat("h:m").parse(e["outbound"]["departure"]["time"]);
        DateTime returnDepartureTime =
            DateFormat("h:m").parse(e["return"]["departure"]["time"]);
        bool outsideOutboundTimes =
            outboundDepartureTime.hour < outboundTimes[0] ||
                outboundDepartureTime.hour > outboundTimes[1];
        bool outsideReturnTimes = returnDepartureTime.hour < returnTimes[0] ||
            returnDepartureTime.hour > returnTimes[1];

        return outsideOutboundTimes || outsideReturnTimes;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        shape: ContinuousRectangleBorder(
          side: BorderSide(
            color: CustomColors.lightGrey,
            width: 4,
          ),
        ),
        title: Column(
          children: [
            Text(
              'Flights',
              style: Theme.of(context).textTheme.headline3,
            ),
            Padding(
              padding: EdgeInsets.only(top: 5, bottom: 5),
              child: Text(
                shownFlights.length.toString() + " options",
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
          ],
        ),
        leading: Padding(
          padding: EdgeInsets.only(left: 10),
          child: IconButton(
            icon: Icon(Icons.close),
            color: Theme.of(context).primaryColor,
            iconSize: 30,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: IconButton(
              icon: Icon(Icons.sort),
              color: Theme.of(context).primaryColor,
              iconSize: 30,
              onPressed: () {
                showDialog(
                  context: context,
                  barrierColor: CustomColors.dialogBackground,
                  builder: (BuildContext context) => FilterFlights(
                    callback: filterFlights,
                    outboundTimes: _outboundTimes,
                    returnTimes: _returnTimes,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
            color: CustomColors.greyBackground,
            child: ListView.builder(
              itemCount: shownFlights.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedFlight = index;
                      });
                    },
                    child: Container(
                      color: Colors.white,
                      child: Stack(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                top: 20, left: 20, right: 20, bottom: 20),
                            child: Column(
                              children: <Widget>[
                                FlightTicket(
                                  ticketDetails: shownFlights[index]
                                      ["outbound"],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: FlightTicket(
                                    ticketDetails: shownFlights[index]
                                        ["return"],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: Visibility(
                              visible: _selectedFlight == index,
                              child: SelectedIcon(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned.fill(
            top: null,
            bottom: 0,
            child: Container(
              color: Colors.transparent,
              child: Padding(
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 30),
                child: ConfirmButton(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SelectedIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(300),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Icon(
          Icons.check,
          color: Colors.white,
        ),
      ),
    );
  }
}

class ConfirmButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () => callback(),
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Text(
              "Done",
              style: Theme.of(context)
                  .textTheme
                  .button
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}
