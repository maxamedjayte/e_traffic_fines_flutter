import 'package:e_traffic_fines/data/json.dart';
import 'package:e_traffic_fines/screens/recipe_detail.dart';
import 'package:e_traffic_fines/widgets/appbar_box.dart';
import 'package:e_traffic_fines/widgets/avatar_image.dart';
import 'package:e_traffic_fines/widgets/notification_box.dart';
import 'package:flutter/material.dart';

import '../common/api.dart';
import '../model/modals.dart';
import '../widgets/custom_image.dart';
import '../widgets/dashboardButtons.dart';
import '../widgets/transaction_item.dart';
import '../widgets/user_box.dart';

class HomeFregment extends StatefulWidget {
  const HomeFregment({Key? key}) : super(key: key);

  @override
  State<HomeFregment> createState() => _HomeFregmentState();
}

class _HomeFregmentState extends State<HomeFregment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(children: [
      getAppBar(),
      Padding(
        padding: const EdgeInsets.all(12.0),
        child: currentUser['is_staff'] == true
            ? Row(
                children: [
                  Expanded(
                    child: DashButtons(
                      head: 'All Cars Reg',
                      headValue:
                          int.parse(currentUser['allCarsCount'].toString()),
                      icon: Icons.car_rental,
                      fontColor: Colors.white,
                      dashColor: Color(0xff154360),
                    ),
                  ),
                  SizedBox(width: 6),
                  Expanded(
                    child: DashButtons(
                      head: 'The Unfixed Fines',
                      headValue:
                          int.parse(currentUser['unfixedFines'].toString()),
                      icon: Icons.sync_problem_outlined,
                      fontColor: Colors.white,
                      dashColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: DashButtons(
                      head: 'Your Cars',
                      headValue:
                          int.parse(currentUser['userCarCount'].toString()),
                      icon: Icons.car_rental,
                      fontColor: Colors.white,
                      dashColor: Color(0xff154360),
                    ),
                  ),
                ],
              ),
      ),
      const SizedBox(height: 15),
      currentUser['is_staff'] == true
          ? Column(children: [
              Container(
                  padding: EdgeInsets.only(left: 20),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Some Users",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  )),
              const SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.only(left: 15),
                child: getRecentUsers(),
              ),
            ])
          : Container(),
      SizedBox(height: 20),
      Column(
        children: [
          Container(
              padding: EdgeInsets.only(left: 20, right: 15),
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Latest Unfixed Fines",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                  Expanded(
                      child: Container(
                          alignment: Alignment.centerRight,
                          child: const Text(
                            "Today",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ))),
                  Icon(Icons.expand_more_rounded),
                ],
              )),
          SizedBox(height: 15),
          Padding(
            padding: EdgeInsets.only(left: 15),
            child: getLatestFines(),
          ),
        ],
      )
    ])));
  }
}

getAppBar() {
  return AppBarBox(
      height: 110,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomImage(
            currentUser['profileImage'].toString(),
            width: 40,
            height: 40,
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
              child: Container(
            alignment: Alignment.centerLeft,
            // color: Colors.red,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hello ${currentUser['name']},",
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                SizedBox(
                  height: 3,
                ),
                currentUser['is_staff'] == true
                    ? Text("Welcome back to your staf!",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 17))
                    : Text("Welcome back!",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 17)),
              ],
            ),
          )),
          const SizedBox(
            width: 15,
          ),
          InkWell(
              onTap: () {
                // TrafficDataService().getUsersProfile();
              },
              child: const NotificationBox())
        ],
      ));
}

getRecentUsers() {
  return FutureBuilder<List<UserProfile>>(
      future: TrafficDataService().getUserProfile(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var userProfile = snapshot.data!;
          return SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 5),
            scrollDirection: Axis.horizontal,
            child: Row(
                children: List.generate(
                    userProfile.length,
                    (index) => InkWell(
                          onTap: () {
                            print('user tapped');
                            print('object');
                          },
                          child: Container(
                              margin: const EdgeInsets.only(right: 15),
                              child: UserBox(user: userProfile[index])),
                        ))),
          );
        } else {
          return Container();
        }
      });
}

// => index == 0
//                         ? Row(
//                             children: [
//                               Container(
//                                 margin: const EdgeInsets.only(right: 15),
//                                 child: getSearchBox(),
//                               ),
//                               Container(
//                                   margin: const EdgeInsets.only(right: 15),
//                                   child: UserBox(user: userProfile[index]))
//                             ],
//                           )
//                         :
getSearchBox() {
  return Column(
    children: [
      Container(
        width: 55,
        height: 55,
        decoration:
            BoxDecoration(color: Colors.grey.shade300, shape: BoxShape.circle),
        child: const Icon(
          Icons.search_rounded,
          size: 30,
        ),
      ),
      const SizedBox(
        height: 8,
      ),
      const Text(
        "Search",
        style: TextStyle(fontWeight: FontWeight.w500),
      )
    ],
  );
}

getLatestFines() {
  return FutureBuilder<List<CarFines>>(
    future: TrafficDataService().getCarFines(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        List<CarFines> carFines = snapshot.data!;
        return Column(
            children: List.generate(
                carFines.length,
                (index) => carFines[index].fixed == false
                    ? Container(
                        margin: EdgeInsets.only(right: 15),
                        child: currentUser['is_staff'] == false
                            ? carFines[index].id.toString() ==
                                    currentUser['userId']
                                ? TransactionItem(
                                    carFines[index],
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RecipeDetail(
                                                      data: carFines[index])));
                                    },
                                  )
                                : Container()
                            : TransactionItem(
                                carFines[index],
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => RecipeDetail(
                                              data: carFines[index])));
                                },
                              ))
                    : Container()));
      } else {
        return Center(child: CircularProgressIndicator());
      }
    },
  );
}
