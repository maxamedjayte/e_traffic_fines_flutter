import 'package:e_traffic_fines/model/modals.dart';
import 'package:e_traffic_fines/widgets/custom_image.dart';
import 'package:flutter/material.dart';

import 'avatar_image.dart';

class UserBox extends StatelessWidget {
  UserBox(
      {Key? key,
      required this.user,
      this.isSVG = false,
      this.width = 55,
      this.height = 55,
      this.isNamed = true,
      this.fontSize = 14,
      this.fontWeight = FontWeight.w500})
      : super(key: key);
  UserProfile user;
  double width;
  double height;
  double fontSize;
  FontWeight fontWeight;
  bool isSVG;
  bool isNamed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomImage(
          user.prfileImage,
          width: 50,
          height: 50,
        ),
        const SizedBox(
          height: 8,
        ),
        if (isNamed)
          Text(
            user.fullName,
            style: TextStyle(fontSize: fontSize, fontWeight: fontWeight),
          )
      ],
    );
  }
}
