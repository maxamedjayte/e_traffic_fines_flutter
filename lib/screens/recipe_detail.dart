import 'package:dotted_border/dotted_border.dart';
import 'package:e_traffic_fines/model/modals.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../common/api.dart';
import '../common/theme_helper.dart';
import '../data/json.dart';
import '../theme/colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_image.dart';
import '../widgets/favorite_box.dart';
import '../widgets/icon_box.dart';

class RecipeDetail extends StatefulWidget {
  const RecipeDetail({Key? key, required this.data}) : super(key: key);
  final CarFines data;

  @override
  State<RecipeDetail> createState() => _RecipeDetailState();
}

class _RecipeDetailState extends State<RecipeDetail> {
  bool isLoading = false;
  Dio dio = Dio();
  var dioResponse;
  paidTheMoney({required String currentPhone, required double money}) async {
    setState(() {
      isLoading = true;
    });

    try {
      if (currentPhone.startsWith('+252') && currentPhone.length == 13) {
        currentPhone = currentPhone.substring(1);
      } else if (currentPhone.startsWith('00252') &&
          currentPhone.length == 14) {
        currentPhone = currentPhone.substring(2);
      } else if (currentPhone.startsWith('0252') && currentPhone.length == 13) {
        currentPhone = currentPhone.substring(1);
      } else if (currentPhone.startsWith('061') && currentPhone.length == 10) {
        currentPhone = '252' + currentPhone.substring(1);
      } else if (currentPhone.startsWith('61') && currentPhone.length == 9) {
        currentPhone = '252' + currentPhone;
      } else {
        currentPhone = currentPhone;
      }

      dioResponse = await dio.post('https://api.waafi.com/asm', data: {
        "schemaVersion": "1.0",
        "requestId": "10111331033",
        "timestamp": "client_timestamp",
        "channelName": "WEB",
        "serviceName": "API_PURCHASE",
        "serviceParams": {
          "merchantUid": "M0910291",
          "apiUserId": "1000416",
          "apiKey": "API-675418888AHX",
          "paymentMethod": "mwallet_account",
          "payerInfo": {"accountNo": currentPhone},
          "transactionInfo": {
            "referenceId": "12334",
            "invoiceId": "7896504",
            "amount": money,
            "currency": "USD",
            "description": "Test USD"
          }
        }
      });
      if (dioResponse.statusCode == 200) {
        if (dioResponse.data["errorCode"] == "0") {
          if (await TrafficDataService().paidTheMoney(data.id)) {
            fixedProblem = true;
            setState(() {});
            Navigator.pop(context);
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Payment Error. Please, try again.'),
          ));
          setState(() {
            isLoading = false;
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Payment Error. Please, try again.'),
      ));
      setState(() {
        isLoading = false;
      });

      return;
    }
  }

  late CarFines data;
  bool showBody = false;
  late String userNumber;
  bool fixedProblem = false;
  double stackHeight = 230;

  @override
  void initState() {
    fixedProblem = widget.data.fixed;
    super.initState();

    data = widget.data;

    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        showBody = true;
      });
    });
  }

  final _formKey = GlobalKey<FormState>();

  animatedBody() {
    return AnimatedCrossFade(
      firstChild: buildBody(),
      secondChild: Container(),
      crossFadeState:
          showBody ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBgColor,
      body: animatedBody(),
      floatingActionButton: buildButtons(),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
    );
  }

  buildStack() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: stackHeight,
      child: Stack(
        children: [
          CustomImage(
            data.carImage,
            width: MediaQuery.of(context).size.width,
            height: stackHeight,
            radius: 0,
            isShadow: false,
          ),
          SafeArea(
            child: Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconBox(
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 20,
                      color: darker,
                    ),
                    bgColor: cardColor.withOpacity(.7),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: stackHeight - 40,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 40,
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                color: appBgColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
              ),
            ),
          ),
          Positioned(
            top: stackHeight - 50,
            right: 20,
            child: FavoriteBox(
              size: 18,
              isFavorited: fixedProblem,
              onTap: () {
                setState(() {
                  // data["is_favorited"] = !data["is_favorited"];
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInfoHead() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${data.carName} -- ${data.carTargo}',
              style: const TextStyle(
                  fontSize: 20, color: textColor, fontWeight: FontWeight.w600),
            ),
            fixedProblem == true
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
                        const Text(
                          'Fixed',
                          style: TextStyle(fontSize: 14),
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
                        const Text(
                          'Not Fixed',
                          style: TextStyle(fontSize: 14),
                        )
                      ],
                    ),
                  ),
          ],
        ),
        Text(
          data.ownerType,
          style: const TextStyle(fontSize: 14, color: labelColor),
        ),
      ],
    );
  }

  Widget buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          buildStack(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: buildInfoHead(),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, top: 20, right: 15),
                child: buildReivewBox(),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 15, top: 20, right: 15),
                child: Text(
                  "Ingredients",
                  style: TextStyle(
                    color: darker,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
                child: Row(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width / 2,
                        child: buildIngredientBox()),
                    SizedBox(width: 10),
                    Expanded(
                        child: data.imageArea != null
                            ? Container(
                                height: 200,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(data.imageArea!))))
                            : const Text('No Image Area')),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: const Text(
                  "Description",
                  style: TextStyle(
                    color: darker,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Text(
                  data.desc,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: labelColor,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildReivewBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: appBgColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: shadowColor.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomImage(
            data.ownerImage,
            width: 40,
            height: 40,
          ),
          const SizedBox(width: 10),
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
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 3),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(
                  5,
                  (index) => const Icon(
                    Icons.star,
                    color: yellow,
                    size: 18,
                  ),
                ),
              ),
              const SizedBox(height: 3),
              const Text(
                " upvoted",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: labelColor, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildIngredientBox() {
    return DottedBorder(
      dashPattern: const [2, 5],
      color: darker,
      strokeWidth: .5,
      radius: const Radius.circular(20),
      child: Container(
        padding: const EdgeInsets.only(top: 10, bottom: 0, right: 4, left: 4),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildIngredientItem(
                        data.fineTitle, "\$${data.penallyMoney}"),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButtons() {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    if (fixedProblem) {
                      return Container(
                          child: AlertDialog(
                        title: const Text("This Payment Already Paided"),
                      ));
                    } else {
                      return AlertDialog(
                        title: const Text("Are You Sure ?"),
                        content: currentUser['is_staff'] == true
                            ? Row(children: [
                                const Text('To Take '),
                                Text('\$ ${data.penallyMoney}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                const Text(' Car Fine'),
                              ])
                            : Row(children: [
                                const Text('To Paid This Money '),
                                Text('\$ ${data.penallyMoney}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                const Text('For Your Car Fine'),
                              ]),
                        actions: [
                          RaisedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancel')),
                          RaisedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return !isLoading
                                          ? AlertDialog(
                                              title: const Text(
                                                  'Enter User Number'),
                                              content: Form(
                                                  key: _formKey,
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Container(
                                                        decoration: ThemeHelper()
                                                            .inputBoxDecorationShaddow(),
                                                        child: TextFormField(
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          maxLength: 9,
                                                          textInputAction:
                                                              TextInputAction
                                                                  .next,
                                                          validator:
                                                              (_theNumber) {
                                                            if (_theNumber!
                                                                .isEmpty) {
                                                              return 'Enter User Number';
                                                            }
                                                          },
                                                          onSaved:
                                                              (_theNumber) {
                                                            setState(() {
                                                              userNumber =
                                                                  _theNumber!;
                                                            });
                                                          },
                                                          decoration: ThemeHelper()
                                                              .textInputDecoration(
                                                                  'User Number',
                                                                  'Enter The User Number'),
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                              actions: [
                                                TextButton(
                                                    child: const Text(
                                                        "Send Number"),
                                                    style: ButtonStyle(
                                                        foregroundColor:
                                                            MaterialStateProperty
                                                                .resolveWith(
                                                                    (state) =>
                                                                        Colors
                                                                            .green)),
                                                    onPressed: () async {
                                                      _formKey.currentState!
                                                          .save();
                                                      if (_formKey.currentState!
                                                          .validate()) {
                                                        isLoading = true;
                                                        setState(() {});
                                                        await paidTheMoney(
                                                            currentPhone:
                                                                userNumber,
                                                            money: 0.01);

                                                        setState(() {});
                                                        // }
                                                      }
                                                    }),
                                              ],
                                            )
                                          : Container(
                                              child: Text('data'),
                                            );
                                    });
                              },
                              child: const Text('Ok'))
                        ],
                      );
                    }
                  });
            },
            child: IconBox(
              bgColor: red,
              padding: 12,
              child: Row(
                children: [
                  const SizedBox(
                    width: 3,
                  ),
                  SvgPicture.asset(
                    "assets/icons/play.svg",
                    color: Colors.white,
                    width: 18,
                    height: 18,
                  ),
                  const SizedBox(
                    width: 3,
                  ),
                  currentUser['is_staff'] == true
                      ? const Text(
                          "Take The Money",
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          "Paid The Money",
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                  const SizedBox(
                    width: 3,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          currentUser['is_staff'] == true
              ? Expanded(
                  child: CustomButton(
                    radius: 15,
                    title: "Fix The Fine",
                    onTap: () {
                      Widget cancelButton = TextButton(
                        style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.resolveWith(
                                (state) => Colors.red)),
                        child: const Text("Cancel"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      );
                      Widget continueButton = TextButton(
                        child: const Text("Continue"),
                        style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.resolveWith(
                                (state) => Colors.green)),
                        onPressed: () {
                          TrafficDataService().fixTheFine(data.id);
                          fixedProblem = true;
                          setState(() {});
                          // CoolAlert.show(
                          //     context: context,
                          //     type: CoolAlertType.success,
                          //     text: 'You Succesfully Fixed The Fine');

                          Navigator.pop(context);
                        },
                      );
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Are You Sure ?"),
                              content: Row(children: [
                                const Text('To Fix This '),
                                Text('${data.carName}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                const Text(' Car Fine'),
                              ]),
                              actions: [
                                cancelButton,
                                continueButton,
                              ],
                            );
                          });
                    },
                  ),
                )
              : Expanded(
                  child: CustomButton(
                    bgColor: Colors.white,
                    radius: 15,
                    title: " ",
                    onTap: () {},
                  ),
                ),
        ],
      ),
    );
  }

  Widget buildIngredientItem(String text, String value) {
    return Row(
      children: [
        const Icon(
          Icons.fiber_manual_record,
          size: 10,
          color: primary,
        ),
        const SizedBox(
          width: 2,
        ),
        RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: text,
                style: const TextStyle(
                  color: labelColor,
                  fontSize: 13,
                ),
              ),
              const TextSpan(
                text: ": ",
                style: TextStyle(
                  color: labelColor,
                  fontSize: 14,
                ),
              ),
              TextSpan(
                text: value,
                style: const TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
