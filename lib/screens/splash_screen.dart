import 'dart:async';

import 'package:e_traffic_fines/common/api.dart';
import 'package:e_traffic_fines/screens/home.dart';
import 'package:e_traffic_fines/screens/sing_in.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<bool> _getUsersFromSharedPrev() async {
    var isLoggedIn = false;
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    String? userId = _prefs.getString('userId');
    if (userId == null) {
      isLoggedIn = false;
    } else {
      isLoggedIn = true;
      await TrafficDataService().getTheUserInfo(userId: userId);
      await TrafficDataService().getDashboardCounts();

      setState(() {});
    }
    return isLoggedIn;
  }

  bool _isVisible = false;

  _SplashScreenState() {
    Timer(const Duration(milliseconds: 2000), () async {
      await _getUsersFromSharedPrev()
          ? Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => HomeScreen()),
              (route) => false)
          : Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => SingInScreen()),
              (route) => false);

      // Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(builder: (context) => HomeScreen()),
      //     (route) => false);
    });

    Timer(Duration(milliseconds: 10), () {
      setState(() {
        _isVisible =
            true; // Now it is showing fade effect and navigating to Login page
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).accentColor,
            Theme.of(context).primaryColor
          ],
          begin: const FractionalOffset(0, 0),
          end: const FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      child: AnimatedOpacity(
        opacity: _isVisible ? 1.0 : 0,
        duration: Duration(milliseconds: 1200),
        child: Center(
          child: Container(
            height: 140.0,
            width: 140.0,
            child: Center(
              child: ClipOval(
                child: Icon(
                  Icons.traffic_outlined,
                  size: 128,
                ), //put your logo here
              ),
            ),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 2.0,
                    offset: Offset(5.0, 3.0),
                    spreadRadius: 2.0,
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
