import 'package:blimp/screens/results/accommodation.dart';
import 'package:blimp/services/suggestions.dart';
import 'package:blimp/services/user.dart';
import 'package:blimp/styles/colors.dart';
import 'package:blimp/widgets/buttons.dart';
import 'package:blimp/widgets/fields.dart';
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

  List<int> selectedTravellers = [];

  void travellerSelected(bool sel, int id) {
    setState(() {
      if (sel) {
        selectedTravellers.add(id);
      } else {
        selectedTravellers.remove(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: kToolbarHeight + 40,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        centerTitle: false,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            FontAwesomeIcons.arrowLeft,
            color: Theme.of(context).primaryColor,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Booking",
              style: Theme.of(context)
                  .textTheme
                  .headline4
                  .copyWith(color: Theme.of(context).primaryColor),
            ),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  destinationName,
                  style: Theme.of(context)
                      .textTheme
                      .headline2
                      .copyWith(color: Theme.of(context).primaryColor),
                ),
                Text(
                  " (" +
                      DateFormat("d MMM").format(
                        DateTime.parse(
                            flights["outbound"]["departure"]["date"]),
                      ) +
                      " - " +
                      DateFormat("d MMM").format(
                        DateTime.parse(flights["return"]["departure"]["date"]),
                      ) +
                      ")",
                  style: Theme.of(context)
                      .textTheme
                      .headline2
                      .copyWith(color: Theme.of(context).primaryColor),
                ),
              ],
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
                            left: 30, right: 30, top: 0, bottom: 30),
                        child: Padding(
                          padding: EdgeInsets.only(top: 0),
                          child: PersonalDetailsForm(),
                        ),
                      ),
                    ),
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
                          child: TravellersSection(
                            selected: selectedTravellers,
                            requiredNum: 2,
                            callback: travellerSelected,
                          ),
                        ),
                      ),
                    ),
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
                          child: PaymentSection(
                            flights: flights,
                            accommodation: accommodation,
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

class TravellersSection extends StatelessWidget {
  final List<int> selected;
  final int requiredNum;
  final Function callback;
  TravellersSection({this.selected, this.requiredNum, this.callback});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Travellers (" +
              selected.length.toString() +
              "/" +
              requiredNum.toString() +
              ")",
          style: Theme.of(context).textTheme.headline4,
        ),
        Padding(
          padding: EdgeInsets.only(top: 20),
          child: Column(
            children: [
              ListView.builder(
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: TravellerOption(
                      traveller: currentUser["travellers"][index],
                      isSelected: selected
                          .contains(currentUser["travellers"][index]["id"]),
                      callback: callback,
                    ),
                  );
                },
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: currentUser["travellers"].length,
              ),
              NewTravellerOption(),
            ],
          ),
        ),
      ],
    );
  }
}

class NewTravellerOption extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 10.0,
            offset: Offset(0, 0),
          )
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  FontAwesomeIcons.user,
                  size: 20,
                  color: Theme.of(context).primaryColor,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    "Add new traveller",
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                // callback(!isSelected, traveller["id"]);
              },
              child: NewTravellerIcon(
                isSelected: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NewTravellerIcon extends StatelessWidget {
  final bool isSelected;
  NewTravellerIcon({this.isSelected});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected
            ? Theme.of(context).primaryColor
            : CustomColors.lightGrey,
        borderRadius: BorderRadius.circular(300),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Icon(
          FontAwesomeIcons.plus,
          color: isSelected ? Colors.white : Colors.grey,
        ),
      ),
    );
  }
}

class TravellerOption extends StatelessWidget {
  final Map traveller;
  final bool isSelected;
  final Function callback;
  TravellerOption({this.traveller, this.isSelected, this.callback});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 10.0,
            offset: Offset(0, 0),
          )
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  FontAwesomeIcons.solidUser,
                  size: 20,
                  color: Theme.of(context).primaryColor,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    traveller["fullName"],
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                callback(!isSelected, traveller["id"]);
              },
              child: SelectedIcon(
                isSelected: isSelected,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentSection extends StatelessWidget {
  final Map flights;
  final Map accommodation;
  PaymentSection({this.flights, this.accommodation});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Payment",
          style: Theme.of(context).textTheme.headline4,
        ),
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
                        flightsPrice: flights["outbound"]["price"]["amount"] +
                            flights["return"]["price"]["amount"],
                        accommodationPrice: accommodation["selectedOffer"]
                            ["price"]["amount"],
                        currency: flights["outbound"]["price"]["currency"],
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
                          StripePayment.paymentRequestWithCardForm(
                                  CardFormPaymentRequest())
                              .then((paymentMethod) {});
                        },
                        child: PaymentButton(
                          text: 'Pay with New Card',
                          icon: Icons.credit_card,
                          color: Colors.white,
                          backgroundColor: Colors.blueGrey[700],
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
                      symbol: suggestions.getCurrencySuggestions()[currency]
                          ["symbol"])
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
                        symbol: suggestions.getCurrencySuggestions()[currency]
                            ["symbol"])
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
              Text(
                "Subtotal",
                style: Theme.of(context).textTheme.headline2,
              ),
              Text(
                NumberFormat.currency(
                        name: currency,
                        symbol: suggestions.getCurrencySuggestions()[currency]
                            ["symbol"])
                    .format(flightsPrice + accommodationPrice),
                style: Theme.of(context).textTheme.headline2,
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
              Text("Booking fee"),
              Text(
                NumberFormat.currency(
                        name: currency,
                        symbol: suggestions.getCurrencySuggestions()[currency]
                            ["symbol"])
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
                            symbol: suggestions
                                .getCurrencySuggestions()[currency]["symbol"])
                        .format(50),
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(color: Colors.green),
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
                            symbol: suggestions
                                .getCurrencySuggestions()[currency]["symbol"])
                        .format(5),
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(color: Colors.green),
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
                style: Theme.of(context).textTheme.headline3,
              ),
              Text(
                NumberFormat.currency(
                        name: currency,
                        symbol: suggestions.getCurrencySuggestions()[currency]
                            ["symbol"])
                    .format((flightsPrice + accommodationPrice) * 0.05 +
                        (flightsPrice + accommodationPrice) -
                        55),
                style: Theme.of(context).textTheme.headline3,
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
                        symbol: suggestions.getCurrencySuggestions()[
                            accommodation["price"]["currency"]]["symbol"])
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
                        symbol: suggestions.getCurrencySuggestions()[
                            flights["outbound"]["price"]["currency"]]["symbol"])
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
                        symbol: suggestions.getCurrencySuggestions()[
                            flights["return"]["price"]["currency"]]["symbol"])
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
            padding: EdgeInsets.only(top: 20),
            child: CustomTextFormField(
              labelText: "Email Address",
              prefixIcon: FontAwesomeIcons.envelope,
              initialValue: currentUser["email"],
            ),
          ),
        ],
      ),
    );
  }
}
