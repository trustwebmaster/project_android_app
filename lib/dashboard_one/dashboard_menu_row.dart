import 'package:flutter/material.dart';
import 'package:pharmifind/designs/label_below_icon.dart';

class DashboardMenuRow extends StatelessWidget {
  final firstLabel;
  final firstOnPressed;
  final IconData firstIcon;
  final firstIconCircleColor;

  final thirdLabel;
  final thirdOnPressed;
  final IconData thirdIcon;
  final thirdIconCircleColor;

  final fourthLabel;
  final fourthOnPressed;
  final IconData fourthIcon;
  final fourthIconCircleColor;

  const DashboardMenuRow(
      {Key key,
      this.firstLabel,
      this.firstOnPressed,
      this.firstIcon,
      this.firstIconCircleColor,
      this.thirdLabel,
      this.thirdOnPressed,
      this.thirdIcon,
      this.thirdIconCircleColor,
      this.fourthLabel,
      this.fourthOnPressed,
      this.fourthIcon,
      this.fourthIconCircleColor})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          LabelBelowIcon(
            icon: firstIcon,
            onPressed: firstOnPressed,
            label: firstLabel,
            circleColor: firstIconCircleColor,
          ),
          LabelBelowIcon(
            icon: thirdIcon,
            onPressed: thirdOnPressed,
            label: thirdLabel,
            circleColor: thirdIconCircleColor,
          ),
          LabelBelowIcon(
            icon: fourthIcon,
            onPressed: fourthOnPressed,
            label: fourthLabel,
            circleColor: fourthIconCircleColor,
          ),
        ],
      ),
    );
  }
}
