import 'package:blimp/screens/results/filterFlights.dart';
import 'package:blimp/styles/colors.dart';
import 'package:blimp/widgets/alerts.dart';
import 'package:blimp/widgets/buttons.dart';
import 'package:blimp/widgets/flight_ticket.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

class FlightsScreen extends StatefulWidget {
  final List allFlights;
  final int selectedFlight;
  final Function callback;
  FlightsScreen({this.allFlights, this.callback, this.selectedFlight});

  @override
  State<StatefulWidget> createState() {
    return FlightsScreenState(
        allFlights: allFlights,
        callback: callback,
        selectedFlight: selectedFlight);
  }
}

class FlightsScreenState extends State<FlightsScreen> {
  final List allFlights;
  int selectedFlight;
  final Function callback;
  List shownFlights;
  List<double> _outboundTimes = [6.0, 18.0];
  List<double> _returnTimes = [6.0, 18.0];
  FlightsScreenState({this.allFlights, this.callback, this.selectedFlight}) {
    shownFlights = List.from(allFlights);
    shownFlights.removeWhere((f) => f["id"] == selectedFlight);
    shownFlights.insert(
        0, allFlights.where((f) => f["id"] == selectedFlight).toList()[0]);
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
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        centerTitle: false,
        elevation: 0,
        toolbarHeight: kToolbarHeight + 20,
        // shape: ContinuousRectangleBorder(
        //   side: BorderSide(
        //     color: CustomColors.lightGrey,
        //     width: 4,
        //   ),
        // ),
        title: Padding(
          padding: EdgeInsets.only(left: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Flights',
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    .copyWith(color: Theme.of(context).primaryColor),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5),
                child: Text(
                  shownFlights.length.toString() + " options",
                  style: Theme.of(context).textTheme.headline1,
                ),
              ),
            ],
          ),
        ),
        // leading: Padding(
        //   padding: EdgeInsets.only(left: 10),
        //   child: IconButton(
        //     icon: Icon(Icons.close),
        //     color: Theme.of(context).primaryColor,
        //     iconSize: 30,
        //     onPressed: () {
        //       Navigator.pop(context);
        //     },
        //   ),
        // ),
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
                  child: Container(
                    color: Colors.white,
                    child: AnimatedButton(
                      key: Key(index.toString() +
                          (selectedFlight == shownFlights[index]["id"])
                              .toString()),
                      callback: () {
                        setState(() {
                          selectedFlight = shownFlights[index]["id"];
                        });
                      },
                      child: Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                top: 20, left: 20, right: 20, bottom: 20),
                            child: FlightTicketsOption(
                              flight: shownFlights[index],
                              selectedFlight: selectedFlight,
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: Visibility(
                              visible:
                                  selectedFlight == shownFlights[index]["id"],
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
                child: AnimatedButton(
                  callback: () {
                    callback(selectedFlight);
                    Navigator.pop(context);
                    showSuccessToast(context, "Flights Changed");
                  },
                  child: ConfirmButton(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FlightTicketsOption extends StatelessWidget {
  final Map flight;
  final int selectedFlight;
  final Key key;
  FlightTicketsOption({this.flight, this.selectedFlight, this.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        FlightTicket(
          ticketDetails: flight["outbound"],
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: FlightTicket(
            ticketDetails: flight["return"],
          ),
        ),
      ],
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
