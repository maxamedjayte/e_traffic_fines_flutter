import 'package:e_traffic_fines/model/modals.dart';
import 'package:e_traffic_fines/theme/colors.dart';
import 'package:e_traffic_fines/widgets/custom_image.dart';
import 'package:flutter/material.dart';

class BookmarkItem extends StatelessWidget {
  const BookmarkItem(
      {Key? key, required this.data, this.width = 300, this.onTap})
      : super(key: key);
  final CarFines data;
  final double width;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(left: 15),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15),
            bottomLeft: Radius.circular(15),
          ),
          boxShadow: [
            BoxShadow(
              color: shadowColor.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          children: [
            CustomImage(
              data.carImage,
              radius: 10,
              height: 100,
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.carName + ' -- ' + data.carTargo,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    data.carTargo,
                    style: const TextStyle(fontSize: 14, color: labelColor),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      CustomImage(
                        data.ownerImage,
                        width: 30,
                        height: 30,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.ownerName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: textColor,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              data.ownerType,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: labelColor,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      data.fixed == true
                          ? Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.check_box,
                                    color: textColor,
                                    size: 16,
                                  ),
                                  const SizedBox(
                                    width: 3,
                                  ),
                                  Text(
                                    'Fixed',
                                    style: const TextStyle(fontSize: 14),
                                  )
                                ],
                              ),
                            )
                          : Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.check_box,
                                    color: textColor,
                                    size: 16,
                                  ),
                                  const SizedBox(
                                    width: 3,
                                  ),
                                  Text(
                                    'Not Fixed',
                                    style: const TextStyle(fontSize: 14),
                                  )
                                ],
                              ),
                            ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
