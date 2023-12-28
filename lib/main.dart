import 'package:e_traffic_fines/screens/splash_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  Color _primaryColor = Color(0xff3498db);
  Color _accentColor = Color(0xffaed6f1);

  // Design color
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-Traffic',
      theme: ThemeData(
        primaryColor: _primaryColor,
        accentColor: _accentColor,
        scaffoldBackgroundColor: Colors.grey.shade100,
        primarySwatch: Colors.grey,
        brightness: Brightness.light,
      ),
      home: SplashScreen(title: 'E-Traffic'),
    );
  }
}
