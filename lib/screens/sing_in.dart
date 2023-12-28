import 'package:e_traffic_fines/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/api.dart';

class SingInScreen extends StatefulWidget {
  const SingInScreen({Key? key}) : super(key: key);

  @override
  _SingInScreenState createState() => _SingInScreenState();
}

class _SingInScreenState extends State<SingInScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  bool isLoading = false;
  double defaultFontSize = 14;
  String defaultFontFamily = 'Roboto-Light.ttf';
  double defaultIconSize = 17;
  late String _email;
  late String _password;
  String? error = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Color(0xfff7760a)
        body: !isLoading
            ? SingleChildScrollView(
                child: Container(
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(
                              'assets/images/category/background-image.jpg'))),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      Container(
                        margin: const EdgeInsets.only(left: 20, right: 20),
                        padding:
                            const EdgeInsets.only(top: 12, left: 20, right: 20),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(12)),
                        child: Form(
                          key: _formKey,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    Container(
                                      decoration:
                                          BoxDecoration(border: Border.all()),
                                      width: 100,
                                      height: 100,
                                      child: SvgPicture.asset(
                                        "assets/icons/scan.svg",
                                        color: Colors.red,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    const Text(
                                      'E-Traffic Fines',
                                      style: TextStyle(fontSize: 30),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 2),
                                // Text("Enter Your Crd To Login",
                                //     style: GoogleFonts.lobster(
                                //         fontSize: 30,
                                //         fontWeight: FontWeight.normal)),
                                const SizedBox(height: 5),
                                Text(
                                  '$error',
                                  style: TextStyle(color: Colors.red),
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  validator: (_val) {
                                    if (_val!.isEmpty) {
                                      return "Enter Username";
                                    }
                                  },
                                  onSaved: (_em) {
                                    setState(() {
                                      _email = _em!;
                                    });
                                  },
                                  showCursor: true,
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(3.0)),
                                    ),
                                    filled: true,
                                    prefixIcon: Icon(
                                      Icons.mail,
                                      color: Color(0xFF666666),
                                      size: defaultIconSize,
                                    ),
                                    fillColor: Color(0xFFF2F3F5),
                                    hintStyle: TextStyle(
                                        color: Color(0xFF666666),
                                        fontFamily: defaultFontFamily,
                                        fontSize: defaultFontSize),
                                    hintText: "Username",
                                  ),
                                ),
                                SizedBox(height: 20),
                                TextFormField(
                                  obscureText: true,
                                  validator: (_pass) {
                                    if (_pass!.isEmpty) {
                                      return "Enter Password";
                                    } else {
                                      if (_pass.length < 3)
                                        return "Password Is less";
                                    }
                                  },
                                  onSaved: (_pass) {
                                    setState(() {
                                      _password = _pass!;
                                    });
                                  },
                                  decoration: InputDecoration(
                                      filled: true,
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        color: Color(0xFF666666),
                                        size: defaultIconSize,
                                      ),
                                      fillColor: Color(0xFFF2F3F5),
                                      hintStyle: TextStyle(
                                          color: Color(0xFF666666),
                                          fontFamily: defaultFontFamily,
                                          fontSize: defaultFontSize),
                                      hintText: "Password",
                                      labelText: "Password",
                                      border: OutlineInputBorder()),
                                ),
                                SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                        onPressed: () {},
                                        child: Text("Create Account")),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Row(
                                  children: [
                                    Expanded(
                                        child: InkWell(
                                      onTap: () async {
                                        final SharedPreferences _prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        var userLoggedIn = false;
                                        _formKey.currentState!.save();
                                        if (_formKey.currentState!.validate()) {
                                          isLoading = true;
                                          setState(() {});

                                          try {
                                            userLoggedIn =
                                                await TrafficDataService()
                                                    .singInTheUser(
                                                        username: _email,
                                                        password: _password);
                                            if (userLoggedIn) {
                                              await TrafficDataService()
                                                  .getTheUserInfo(
                                                      userId: _prefs.getString(
                                                          'userId')!);
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          HomeScreen()));
                                            } else {
                                              isLoading = false;
                                              setState(() {});
                                              // CoolAlert.show(
                                              //     context: context,
                                              //     type: CoolAlertType.error,
                                              //     text:
                                              //         'Username or password are wrong');
                                            }
                                          } catch (e) {
                                            setState(() {
                                              isLoading = false;
                                              print(e.toString());
                                            });
                                          }
                                        }
                                      },
                                      child: Container(
                                        margin:
                                            EdgeInsets.only(top: 0, bottom: 5),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(5),
                                              topRight: Radius.circular(5),
                                              bottomLeft: Radius.circular(5),
                                              bottomRight: Radius.circular(5)),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.8),
                                              spreadRadius: 7,
                                              blurRadius: 9,
                                              offset: Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                FontAwesomeIcons.doorOpen,
                                                color: Colors.white,
                                              ),
                                              SizedBox(width: 19),
                                              Text(
                                                "Sing In ",
                                                style: TextStyle(
                                                    fontSize: 22,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    )),
                                  ],
                                ),
                                SizedBox(height: 10),
                                SizedBox(height: 30),
                              ]),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Center(child: CircularProgressIndicator()));
  }
}

class FacebookGoogleLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  gradient: new LinearGradient(
                      colors: [
                        Colors.black12,
                        Colors.black54,
                      ],
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(1.0, 1.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
                width: 100.0,
                height: 1.0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0, right: 15.0),
                child: Text(
                  "Or",
                  style: TextStyle(
                      color: Color(0xFF2c2b2b),
                      fontSize: 16.0,
                      fontFamily: "WorkSansMedium"),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: new LinearGradient(
                      colors: [
                        Colors.black54,
                        Colors.black12,
                      ],
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(1.0, 1.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
                width: 100.0,
                height: 1.0,
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 10.0, right: 40.0),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(15.0),
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFf7418c),
                  ),
                  child: new Icon(
                    FontAwesomeIcons.facebookF,
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: GestureDetector(
                onTap: () => {},
                child: Container(
                  padding: const EdgeInsets.all(15.0),
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFf7418c),
                  ),
                  child: new Icon(
                    FontAwesomeIcons.google,
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ));
  }
}
