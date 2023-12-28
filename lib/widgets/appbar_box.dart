import 'package:e_traffic_fines/theme/colors.dart';
import 'package:flutter/material.dart';

class AppBarBox extends StatelessWidget {
  AppBarBox({Key? key, required this.child, this.height = 90})
      : super(key: key);
  Widget child;
  double height;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        padding: EdgeInsets.only(left: 20, right: 20, top: 35),
        decoration: BoxDecoration(
            color: appBarColor,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40)),
            boxShadow: [
              BoxShadow(
                  color: shadowColor.withOpacity(0.1),
                  blurRadius: .5,
                  spreadRadius: .5,
                  offset: Offset(0, 1))
            ]),
        child: child);
  }
}
