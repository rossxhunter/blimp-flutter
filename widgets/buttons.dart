import 'package:blimp/styles/colors.dart';
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
      return CustomColors.redGrey;
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
          color: CustomColors.redGrey,
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
          color: CustomColors.redGrey,
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

class AnimatedButton extends StatefulWidget {
  final Widget child;
  final void Function() callback;
  final Key key;
  AnimatedButton({this.child, this.callback, this.key}) : super(key: key);
  @override
  _AnimatedButtonState createState() =>
      _AnimatedButtonState(child: child, callback: callback, key: key);
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  double _scale;
  AnimationController _controller;
  final Widget child;
  final void Function() callback;
  final Key key;

  _AnimatedButtonState({this.child, this.callback, this.key});

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.1,
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {});
    ;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  Future<void> _onTapUp(TapUpDetails details) async {
    await _controller.forward();
    await _controller.reverse();
    callback();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      // onTap: () => callback(),
      child: Transform.scale(
        scale: _scale,
        child: child,
      ),
      // child: child,
    );
  }
}

class ConfirmButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
