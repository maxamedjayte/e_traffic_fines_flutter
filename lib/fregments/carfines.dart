import 'package:e_traffic_fines/model/modals.dart';
import 'package:e_traffic_fines/widgets/bookmark_item.dart';
import 'package:e_traffic_fines/widgets/custom_round_textbox.dart';
import 'package:e_traffic_fines/widgets/slidable_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_svg/svg.dart';

import '../common/api.dart';
import '../data/json.dart';
import '../screens/recipe_detail.dart';
import '../theme/colors.dart';
import '../widgets/icon_box.dart';

class CarFinesFregment extends StatefulWidget {
  const CarFinesFregment({Key? key}) : super(key: key);

  @override
  State<CarFinesFregment> createState() => _CarFinesFregmentState();
}

class _CarFinesFregmentState extends State<CarFinesFregment> {
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getCarFines();
    // isLoading = false;
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBgColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: appBarColor,
            pinned: true,
            snap: true,
            floating: true,
            title: getAppBar(),
          ),
          SliverToBoxAdapter(
            child: buildSearchBlcok(),
          ),
          SliverToBoxAdapter(
            child: carFineList(),
          ),
        ],
      ),
    );
  }

  Widget getAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          currentUser['is_staff'] == true
              ? "Registred CarFines"
              : 'Your Car Fines',
          style: TextStyle(
            color: textColor,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        currentUser['is_staff'] == true
            ? InkWell(
                onTap: () {
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => FixCarFine()));
                },
                child: IconBox(
                  child: SvgPicture.asset(
                    "assets/icons/scan.svg",
                    color: red,
                  ),
                  radius: 50,
                ),
              )
            : Container(),
      ],
    );
  }

  Widget buildSearchBlcok() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 20),
      child: Row(
        children: const [
          Expanded(
            child: CustomRoundTextBox(
              hint: "Search",
              prefix: Icon(Icons.search, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget carFineList() {
    return Container(
      height: MediaQuery.of(context).size.height - 200,
      child: FutureBuilder<List<CarFines>>(
          future: TrafficDataService().getCarFines(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    if (currentUser['is_staff'] == true) {
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: 5,
                        ),
                        child: SlidableWidget(
                          data: snapshot.data![index],
                          key: UniqueKey(),
                          child: BookmarkItem(
                            width: double.infinity,
                            data: snapshot.data![index],
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RecipeDetail(
                                    data: snapshot.data![index],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    } else {
                      if (snapshot.data![index].theOwner == currentUser['id']) {
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: 5,
                          ),
                          child: SlidableWidget(
                            data: snapshot.data![index],
                            key: UniqueKey(),
                            child: BookmarkItem(
                              width: double.infinity,
                              data: snapshot.data![index],
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RecipeDetail(
                                      data: snapshot.data![index],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    }
                  });
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
