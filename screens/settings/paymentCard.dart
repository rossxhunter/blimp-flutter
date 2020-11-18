import 'package:blimp/screens/details/details.dart';
import 'package:blimp/services/http.dart';
import 'package:blimp/services/user.dart';
import 'package:blimp/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PaymentCardScreen extends StatefulWidget {
  final String cardNumber;
  final String expiryDate;
  final String cardHolderName;
  final String cvvCode;
  final String brand;
  final bool isCvvFocused;
  final bool isNew;
  final String last4;
  PaymentCardScreen({
    this.cardHolderName,
    this.cardNumber,
    this.cvvCode,
    this.isCvvFocused,
    this.expiryDate,
    this.isNew,
    this.last4,
    this.brand,
  });
  @override
  State<StatefulWidget> createState() {
    return PaymentCardScreenState(
        cardHolderName: cardHolderName,
        cardNumber: cardNumber,
        cvvCode: cvvCode,
        isCvvFocused: isCvvFocused,
        expiryDate: expiryDate);
  }
}

class PaymentCardScreenState extends State<PaymentCardScreen> {
  String cardNumber;
  String expiryDate;
  String cardHolderName;
  String cvvCode;
  bool isCvvFocused;
  PaymentCardScreenState(
      {this.cardHolderName,
      this.cardNumber,
      this.cvvCode,
      this.isCvvFocused,
      this.expiryDate});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
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
            FontAwesomeIcons.times,
            color: Theme.of(context).primaryColor,
            size: 30,
          ),
        ),
        actions: widget.isNew
            ? []
            : [
                Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: AnimatedButton(
                    callback: () {
                      Navigator.pop(context, "delete");
                    },
                    child: Icon(
                      FontAwesomeIcons.trash,
                      size: 20,
                    ),
                  ),
                ),
              ],
        title: Text(
          widget.isNew
              ? "New Card"
              : widget.brand.toUpperCase() + " " + widget.last4,
          style: Theme.of(context)
              .textTheme
              .headline4
              .copyWith(color: Theme.of(context).primaryColor),
        ),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Column(
            children: [
              CreditCardWidget(
                cardNumber: cardNumber,
                expiryDate: expiryDate,
                cardHolderName: cardHolderName,
                cvvCode: cvvCode,
                showBackView: isCvvFocused,
                cardBgColor: Colors.white,
                height: 200,
                textStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontFamily: "Courier",
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                width: MediaQuery.of(context).size.width,
                animationDuration: Duration(milliseconds: 1000),
              ),
              CreditCardForm(
                themeColor: Theme.of(context).primaryColor,
                onCreditCardModelChange: onCreditCardModelChange,
                cardNumber: cardNumber,
                expiryDate: expiryDate,
                cardHolderName: cardHolderName,
                cvvCode: cvvCode,
              ),
            ],
          ),
          Positioned(
            bottom: 30,
            child: AnimatedButton(
              callback: () {
                int expiryDateMonth = int.parse(expiryDate.substring(0, 2));
                int expiryDateYear = int.parse(expiryDate.substring(3, 5));
                createNewPaymentCard(currentUser["id"], {
                  "card_number": cardNumber,
                  "card_holder_name": cardHolderName,
                  "expiry_date_month": expiryDateMonth.toString(),
                  "expiry_date_year": expiryDateYear.toString(),
                  "cvv_code": cvvCode
                }).then((newCard) {
                  Navigator.pop(context, newCard);
                });
              },
              child: GenericSaveButton(),
            ),
          ),
        ],
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}
