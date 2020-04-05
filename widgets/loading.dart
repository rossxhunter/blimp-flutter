import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SpinKitDualRing(
      color: Theme.of(context).primaryColor,
      size: 80.0,
    );
  }
}
