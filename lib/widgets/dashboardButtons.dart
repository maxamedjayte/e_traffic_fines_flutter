import 'package:flutter/material.dart';

class DashButtons extends StatelessWidget {
  final String head;
  final int headValue;
  final Color? dashColor;
  final IconData icon;
  final Color? fontColor;

  const DashButtons(
      {Key? key,
      required this.head,
      required this.headValue,
      this.dashColor,
      required this.icon,
      this.fontColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 15),
      decoration: BoxDecoration(
        color: dashColor == null ? Theme.of(context).primaryColor : dashColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                color: dashColor == null
                    ? Colors.white
                    : Theme.of(context).accentColor,
                size: 40,
              ),
              Text(headValue.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .headline3!
                      .copyWith(color: fontColor, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Text(head,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: fontColor == null ? Colors.white : fontColor)),
          ),
        ],
      ),
    );
  }
}
