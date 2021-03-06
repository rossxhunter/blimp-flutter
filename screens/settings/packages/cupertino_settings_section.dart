import 'package:blimp/screens/settings/packages/settings_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const Color mediumGrayColor = Color(0xFFC7C7CC);
const Color itemPressedColor = Color(0xFFD9D9D9);
const Color borderColor = Color(0xFFBCBBC1);
const Color borderLightColor = Color.fromRGBO(49, 44, 51, 1);
const Color backgroundGray = Color(0xFFEFEFF4);
const Color groupSubtitle = Color(0xFF777777);
const Color iosTileDarkColor = Color.fromRGBO(28, 28, 30, 1);
const Color iosPressedTileColorDark = Color.fromRGBO(44, 44, 46, 1);
const Color iosPressedTileColorLight = Color.fromRGBO(230, 229, 235, 1);

class CupertinoSettingsSection extends StatelessWidget {
  const CupertinoSettingsSection(
    this.items, {
    this.header,
    this.footer,
  }) : assert(items != null);

  final List<Widget> items;

  final Widget header;
  final Widget footer;

  @override
  Widget build(BuildContext context) {
    final List<Widget> columnChildren = [];
    if (header != null) {
      columnChildren.add(DefaultTextStyle(
        style: TextStyle(
          color: CupertinoColors.inactiveGray,
          fontSize: 13.5,
          letterSpacing: -0.5,
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: 15.0,
            right: 15.0,
            bottom: 10.0,
          ),
          child: header,
        ),
      ));
    }

    List<Widget> itemsWithDividers = [];
    for (int i = 0; i < items.length; i++) {
      final leftPadding =
          (items[i] as SettingsTile).leading == null ? 15.0 : 54.0;
      if (i < items.length - 1) {
        itemsWithDividers.add(items[i]);
        itemsWithDividers.add(Divider(
          height: 0.3,
          indent: leftPadding,
        ));
      } else {
        itemsWithDividers.add(items[i]);
      }
    }

    columnChildren.add(
      Container(
        padding: EdgeInsets.only(top: 0, bottom: 0),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.light
              ? CupertinoColors.white
              : iosTileDarkColor,
          border: Border(
            top: const BorderSide(
              color: borderColor,
              width: 0.3,
            ),
            bottom: const BorderSide(
              color: borderColor,
              width: 0.3,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: itemsWithDividers,
        ),
      ),
    );

    if (footer != null) {
      columnChildren.add(DefaultTextStyle(
        style: TextStyle(
          color: groupSubtitle,
          fontSize: 13.0,
          letterSpacing: -0.08,
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: 15.0,
            right: 15.0,
            top: 7.5,
          ),
          child: footer,
        ),
      ));
    }

    return Padding(
      padding: EdgeInsets.only(
        top: header == null ? 35.0 : 22.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: columnChildren,
      ),
    );
  }
}
