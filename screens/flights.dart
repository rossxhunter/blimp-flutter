import 'package:blimp/styles/colors.dart';
import 'package:blimp/widgets/flight_ticket.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
  int _selectedFlight = 0;

  FlightsScreenState({this.allFlights});

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
        title: Text(
          'Flights',
          style: Theme.of(context).textTheme.headline3,
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
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
            color: CustomColors.greyBackground,
            child: ListView.builder(
              itemCount: allFlights.length,
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
                                  ticketDetails: allFlights[index]["outbound"],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: FlightTicket(
                                    ticketDetails: allFlights[index]["return"],
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
