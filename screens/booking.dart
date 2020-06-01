import 'package:blimp/services/suggestions.dart';
import 'package:blimp/styles/colors.dart';
import 'package:blimp/widgets/buttons.dart';
import 'package:blimp/widgets/icons.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:recase/recase.dart';
import 'package:stripe_payment/stripe_payment.dart';

class BookingPage extends StatefulWidget {
  final Map flights;
  final Map accommodation;
  final String destinationName;
  BookingPage({this.destinationName, this.flights, this.accommodation});
  @override
  State<StatefulWidget> createState() {
    return BookingPageState(
        destinationName: destinationName,
        flights: flights,
        accommodation: accommodation);
  }
}

class BookingPageState extends State<BookingPage> {
  final Map flights;
  final Map accommodation;
  final String destinationName;
  BookingPageState({this.destinationName, this.flights, this.accommodation});
  FocusNode focusNode = FocusNode();

  initState() {
    super.initState();

    StripePayment.setOptions(StripeOptions(
        publishableKey: "pk_test_K12DQ53LJmA1a3iVswAArWMw00IU5SbUD1"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              destinationName,
              style: Theme.of(context)
                  .textTheme
                  .headline3
                  .copyWith(color: Colors.white),
            ),
            Text(
              DateFormat("d MMM").format(
                    DateTime.parse(flights["outbound"]["departure"]["date"]),
                  ) +
                  " - " +
                  DateFormat("d MMM").format(
                    DateTime.parse(flights["return"]["departure"]["date"]),
                  ),
              style: Theme.of(context)
                  .textTheme
                  .headline2
                  .copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(focusNode);
          },
          child: Padding(
            padding: EdgeInsets.only(top: 0),
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Container(
                color: CustomColors.greyBackground,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.white,
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 30, right: 30, top: 30, bottom: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Personal Details",
                                style: Theme.of(context).textTheme.headline4),
                            Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: PersonalDetailsForm(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.only(top: 10),
                    //   child: Container(
                    //     width: double.infinity,
                    //     color: Colors.white,
                    //     child: Padding(
                    //       padding: EdgeInsets.only(
                    //         left: 30,
                    //         right: 30,
                    //         top: 30,
                    //         bottom: 30,
                    //       ),
                    //       child: Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           Text("Flights",
                    //               style: Theme.of(context)
                    //                   .textTheme
                    //                   .headline4),
                    //           Padding(
                    //             padding: EdgeInsets.only(top: 20),
                    //             child: FlightPriceDetails(flights: flights),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // Padding(
                    //   padding: EdgeInsets.only(top: 10),
                    //   child: Container(
                    //     width: double.infinity,
                    //     color: Colors.white,
                    //     child: Padding(
                    //       padding: EdgeInsets.only(
                    //         left: 30,
                    //         right: 30,
                    //         top: 30,
                    //         bottom: 30,
                    //       ),
                    //       child: Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           Text("Accommodation",
                    //               style: Theme.of(context)
                    //                   .textTheme
                    //                   .headline4),
                    //           Padding(
                    //             padding: EdgeInsets.only(top: 20),
                    //             child: AccommodationPriceDetails(
                    //                 accommodation: accommodation),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Container(
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 30,
                            right: 30,
                            top: 30,
                            bottom: 30,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Payment",
                                  style: Theme.of(context).textTheme.headline4),
                              Padding(
                                padding: EdgeInsets.only(top: 20),
                                child: Column(
                                  children: [
                                    Form(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(20),
                                            child: PaymentBreakdown(
                                              flightsPrice: flights["outbound"]
                                                      ["price"]["amount"] +
                                                  flights["return"]["price"]
                                                      ["amount"],
                                              accommodationPrice:
                                                  accommodation["price"]
                                                      ["amount"],
                                              currency: flights["outbound"]
                                                  ["price"]["currency"],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 10),
                                            child: AnimatedButton(
                                              child: PaymentButton(
                                                  text: 'Pay with VISA 4292',
                                                  color: Colors.white,
                                                  icon: FontAwesomeIcons.ccVisa,
                                                  backgroundColor: Colors.blue),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 10),
                                            child: AnimatedButton(
                                              callback: () {
                                                StripePayment
                                                        .paymentRequestWithCardForm(
                                                            CardFormPaymentRequest())
                                                    .then((paymentMethod) {});
                                              },
                                              child: PaymentButton(
                                                text: 'Pay with New Card',
                                                icon: Icons.credit_card,
                                                color: Colors.white,
                                                backgroundColor:
                                                    Colors.blueGrey[700],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // PayButton(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PaymentBreakdown extends StatelessWidget {
  final double flightsPrice;
  final double accommodationPrice;
  final String currency;
  PaymentBreakdown({this.flightsPrice, this.accommodationPrice, this.currency});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Flights"),
            Text(
              NumberFormat.currency(
                      name: currency,
                      symbol: getCurrencySuggestions()[currency]["symbol"])
                  .format(flightsPrice),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Accommodation"),
              Text(
                NumberFormat.currency(
                        name: currency,
                        symbol: getCurrencySuggestions()[currency]["symbol"])
                    .format(accommodationPrice),
              ),
            ],
          ),
        ),
        Divider(color: Colors.grey),
        Padding(
          padding: EdgeInsets.only(top: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Subtotal"),
              Text(
                NumberFormat.currency(
                        name: currency,
                        symbol: getCurrencySuggestions()[currency]["symbol"])
                    .format(flightsPrice + accommodationPrice),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Booking fee"),
              Text(
                NumberFormat.currency(
                        name: currency,
                        symbol: getCurrencySuggestions()[currency]["symbol"])
                    .format((flightsPrice + accommodationPrice) * 0.05),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Blimp Credit"),
              Text(
                "- " +
                    NumberFormat.currency(
                            name: currency,
                            symbol: getCurrencySuggestions()[currency]
                                ["symbol"])
                        .format(50),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Search Savvy Level 3"),
              Text(
                "- " +
                    NumberFormat.currency(
                            name: currency,
                            symbol: getCurrencySuggestions()[currency]
                                ["symbol"])
                        .format(5),
              ),
            ],
          ),
        ),
        Divider(color: Colors.grey),
        Padding(
          padding: EdgeInsets.only(top: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total",
                style: Theme.of(context).textTheme.headline2,
              ),
              Text(
                NumberFormat.currency(
                        name: currency,
                        symbol: getCurrencySuggestions()[currency]["symbol"])
                    .format((flightsPrice + accommodationPrice) * 0.05 +
                        (flightsPrice + accommodationPrice) -
                        55),
                style: Theme.of(context).textTheme.headline2,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PaymentButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  final Color backgroundColor;
  PaymentButton({this.text, this.icon, this.color, this.backgroundColor});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                text,
                style: Theme.of(context)
                    .textTheme
                    .headline2
                    .copyWith(color: color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AccommodationPriceDetails extends StatelessWidget {
  final Map accommodation;
  AccommodationPriceDetails({this.accommodation});
  @override
  Widget build(BuildContext context) {
    return DataTable(
      // dataRowHeight: 80,

      columns: <DataColumn>[
        DataColumn(
          label: Text(
            'Hotel',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        // DataColumn(
        //   label: Text(
        //     'Quanity',
        //     style: TextStyle(fontStyle: FontStyle.italic),
        //   ),
        // ),
        DataColumn(
          label: Text(
            'Total Price',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      ],
      rows: <DataRow>[
        DataRow(
          cells: <DataCell>[
            DataCell(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(accommodation["name"]),
                  Text(accommodation["nights"].toString() + " nights"),
                ],
              ),
            ),
            DataCell(
              Text(
                NumberFormat.currency(
                        name: accommodation["price"]["currency"],
                        symbol: getCurrencySuggestions()[accommodation["price"]
                            ["currency"]]["symbol"])
                    .format(accommodation["price"]["amount"]),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class FlightPriceDetails extends StatelessWidget {
  final Map flights;
  FlightPriceDetails({this.flights});
  @override
  Widget build(BuildContext context) {
    return DataTable(
      dataRowHeight: 80,
      columns: <DataColumn>[
        DataColumn(
          label: Text(
            'Flight',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        // DataColumn(
        //   label: Text(
        //     'Quanity',
        //     style: TextStyle(fontStyle: FontStyle.italic),
        //   ),
        // ),
        DataColumn(
          label: Text(
            'Total',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      ],
      rows: <DataRow>[
        DataRow(
          cells: <DataCell>[
            DataCell(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(flights["outbound"]["departure"]["airportCode"] +
                      " -> " +
                      flights["outbound"]["arrival"]["airportCode"]),
                  Text(
                    DateFormat("d MMM").format(
                          DateTime.parse(
                              flights["outbound"]["departure"]["date"]),
                        ) +
                        ", " +
                        flights["outbound"]["departure"]["time"],
                  ),
                  Text(
                    ReCase(flights["outbound"]["class"]).titleCase,
                  ),
                ],
              ),
            ),
            DataCell(
              Text(
                NumberFormat.currency(
                        name: flights["outbound"]["price"]["currency"],
                        symbol: getCurrencySuggestions()[flights["outbound"]
                            ["price"]["currency"]]["symbol"])
                    .format(flights["outbound"]["price"]["amount"]),
              ),
            ),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(flights["return"]["departure"]["airportCode"] +
                      " -> " +
                      flights["return"]["arrival"]["airportCode"]),
                  Text(
                    DateFormat("d MMM").format(
                          DateTime.parse(
                              flights["return"]["departure"]["date"]),
                        ) +
                        ", " +
                        flights["return"]["departure"]["time"],
                  ),
                  Text(
                    ReCase(flights["return"]["class"]).titleCase,
                  ),
                ],
              ),
            ),
            DataCell(
              Text(
                NumberFormat.currency(
                        name: flights["return"]["price"]["currency"],
                        symbol: getCurrencySuggestions()[flights["return"]
                            ["price"]["currency"]]["symbol"])
                    .format(flights["return"]["price"]["amount"]),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class PayButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedButton(
      callback: () => null,
      child: Container(
        width: 200000,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock,
                  color: Colors.white,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    "Pay Now",
                    style: Theme.of(context)
                        .textTheme
                        .button
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PersonalDetailsForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Form(
      // autovalidate: true,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 0),
            child: TextFormField(
              autocorrect: false,
              // autovalidate: true,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter your first name';
                }
                return null;
              },
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.person,
                ),
                labelText: 'First Name',
                border: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: CustomColors.lightGrey,
                    width: 4,
                    style: BorderStyle.solid,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Padding(
              padding: EdgeInsets.only(left: 0),
              child: TextFormField(
                autocorrect: false,
                // autovalidate: false,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.people,
                  ),
                  labelText: 'Last Name',
                  border: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: CustomColors.lightGrey,
                      width: 4,
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Padding(
              padding: EdgeInsets.only(left: 0),
              child: TextFormField(
                autocorrect: false,
                // autovalidate: true,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter your email';
                  } else if (!EmailValidator.validate(value)) {
                    return 'Invalid email';
                  }
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.email,
                  ),
                  labelText: 'Email Address',
                  border: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: CustomColors.lightGrey,
                      width: 4,
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
