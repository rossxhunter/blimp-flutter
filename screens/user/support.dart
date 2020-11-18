import 'package:blimp/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SupportPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SupportPageState();
  }
}

class SupportPageState extends State<SupportPage> {
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
            FontAwesomeIcons.arrowLeft,
            color: Theme.of(context).primaryColor,
          ),
        ),
        title: Text(
          "Support",
          style: Theme.of(context)
              .textTheme
              .headline4
              .copyWith(color: Theme.of(context).primaryColor),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 20),
          child: WebView(
            initialUrl: 'https://tawk.to/chat/5fb28c72c52f660e8973f7bf/default',
            javascriptMode: JavascriptMode.unrestricted,
            onPageStarted: (url) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return LoadingIndicator();
                },
              );
            },
            onPageFinished: (url) {
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }
}
