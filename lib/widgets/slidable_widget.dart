import 'package:e_traffic_fines/model/modals.dart';
import 'package:e_traffic_fines/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SlidableWidget extends StatelessWidget {
  const SlidableWidget(
      {Key? key,
      required this.child,
      this.onFinish,
      this.onIgnore,
      this.controller,
      required this.data})
      : super(key: key);
  final Widget child;
  final SlidableController? controller;
  final GestureTapCallback? onFinish;
  final GestureTapCallback? onIgnore;
  final CarFines data;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: key,
      groupTag: controller,
      child: child,
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 1 / 2,
        children: [
          SlidableAction(
            onPressed: (context) {
              onIgnore;
            },
            backgroundColor: red,
            foregroundColor: Colors.white,
            icon: Icons.date_range,
            label: data.dateTimeReg.toString().split('Z')[0],
          ),
          SlidableAction(
            onPressed: (context) {
              onFinish;
            },
            backgroundColor: green,
            foregroundColor: Colors.white,
            icon: Icons.money_off,
            label: '${data.penallyMoney}',
          ),
        ],
      ),
    );
  }
}
