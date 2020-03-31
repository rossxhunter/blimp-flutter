import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// class CircularCheckbox extends StatefulWidget {
//   final String text;
//   final int optionIndex;
//   final int activeOption;
//   CircularCheckbox({this.text, this.optionIndex, this.activeOption});

//   @override
//   State<StatefulWidget> createState() {
//     return CircularCheckboxState(
//         text: text, optionIndex: optionIndex, activeOption: activeOption);
//   }
// }

class CircularCheckbox extends StatelessWidget {
  final String text;
  final int optionIndex;
  final int activeOption;
  final onChanged;
  CircularCheckbox(
      {this.text, this.optionIndex, this.activeOption, this.onChanged});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(optionIndex);
      },
      child: Container(
        decoration: BoxDecoration(
          color: _getColor(context),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Text(
            text,
            style: _getTextStyle(context),
          ),
        ),
      ),
    );
  }

  TextStyle _getTextStyle(BuildContext context) {
    if (optionIndex == activeOption) {
      return Theme.of(context).textTheme.button;
    } else {
      return Theme.of(context)
          .textTheme
          .bodyText1
          .copyWith(color: Theme.of(context).primaryColor);
    }
  }

  Color _getColor(BuildContext context) {
    if (optionIndex == activeOption) {
      return Theme.of(context).primaryColor;
    } else {
      return Color.fromRGBO(230, 230, 230, 0.6);
    }
  }
}

class SwitchButton extends StatelessWidget {
  final Function callback;
  SwitchButton({this.callback});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        callback();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(230, 230, 230, 0.8),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Icon(
            Icons.swap_vert,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}

class AddButton extends StatelessWidget {
  final Function callback;
  AddButton({this.callback});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(230, 230, 230, 0.8),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Icon(
            Icons.add,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
