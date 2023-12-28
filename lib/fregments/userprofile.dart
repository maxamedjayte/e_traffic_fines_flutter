import 'package:e_traffic_fines/common/head.dart';
import 'package:e_traffic_fines/common/theme_helper.dart';
import 'package:e_traffic_fines/data/json.dart';
import 'package:e_traffic_fines/screens/sing_in.dart';
import 'package:e_traffic_fines/widgets/avatar_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/custom_image.dart';

class UserProfileFregment extends StatefulWidget {
  const UserProfileFregment({Key? key}) : super(key: key);

  @override
  State<UserProfileFregment> createState() => _UserProfileFregmentState();
}

class _UserProfileFregmentState extends State<UserProfileFregment> {
  final _currentUser = currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Stack(children: [
      Container(
        height: 150,
        child: HeaderWidget(150, false, Icons.house_rounded),
      ),
      Container(
        alignment: Alignment.center,
        child: _currentUser['id'] != ''
            ? Column(
                children: [
                  SizedBox(height: 50),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(width: 5, color: Colors.white),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 20,
                          offset: const Offset(5, 5),
                        ),
                      ],
                    ),
                    child: CustomImage(
                      _currentUser['profileImage'].toString(),
                      width: 100,
                      height: 100,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    _currentUser['name'].toString(),
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    _currentUser['job'].toString(),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding:
                              const EdgeInsets.only(left: 8.0, bottom: 4.0),
                          alignment: Alignment.topLeft,
                          child: const Text(
                            "User Information",
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Card(
                          child: Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.all(15),
                            child: Column(
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    ...ListTile.divideTiles(
                                      color: Colors.grey,
                                      tiles: [
                                        ListTile(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 4),
                                          leading: Icon(Icons.person),
                                          title: Text(
                                            _currentUser['name'].toString(),
                                          ),
                                          subtitle: Text(
                                              "${_currentUser['username'].toString()}   ---  ******"),
                                        ),
                                        ListTile(
                                          leading: Icon(Icons.email),
                                          title: Text("Email"),
                                          subtitle: Text(''),
                                        ),
                                        ListTile(
                                          leading: Icon(Icons.phone),
                                          title: Text("Phone"),
                                          subtitle: Text(_currentUser['number']
                                              .toString()),
                                        ),
                                        ListTile(
                                          leading: Icon(Icons.person),
                                          title: Text("About Me"),
                                          subtitle: Text(
                                            _currentUser['info'].toString(),
                                          ),
                                        ),
                                        Container(
                                            decoration: ThemeHelper()
                                                .buttonBoxDecoration(context),
                                            child: ListTile(
                                              onTap: () async {
                                                final SharedPreferences _prefs =
                                                    await SharedPreferences
                                                        .getInstance();

                                                _prefs.remove('userId');
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: ((context) =>
                                                            SingInScreen())));
                                              },
                                              leading: Icon(
                                                  Icons.logout_outlined,
                                                  color: Colors.white),
                                              title: Text("LogOut",
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              subtitle: Text("Sing Out The App",
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ))
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              )
            : Center(
                child: Container(
                    margin: EdgeInsets.only(top: 200),
                    decoration: ThemeHelper().buttonBoxDecoration(context),
                    width: MediaQuery.of(context).size.width - 30,
                    height: 100,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: []))),
      )
    ])));
  }
}
