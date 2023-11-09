import 'package:flutter/material.dart';
import 'package:flutter_otp_module/bagel_db.dart';

import 'screens/home_screen/home_screen.dart';
import 'screens/login_screen/login_screen.dart';
import 'screens/otp_screen/otp_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter OTP Authentication',
      theme: ThemeData(
        primaryColor: const Color(0xFF2E5BFF),
      ),
      home: LoginScreen(),
      routes: <String, WidgetBuilder>{
        '/#/': (BuildContext context) => LoginScreen(),
        '/otpScreen': (BuildContext ctx) => OtpScreen(),
        '/homeScreen': (BuildContext ctx) => HomeScreen(),
      },
    );
  }
}
