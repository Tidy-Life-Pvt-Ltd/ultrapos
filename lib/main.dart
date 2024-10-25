import 'package:flutter/material.dart';
import 'package:project_ultra/router.dart';
import 'package:project_ultra/screens/bottom_navigation_bar.dart';
import 'package:project_ultra/screens/home_page.dart';
import 'package:project_ultra/screens/login.dart';
import 'package:project_ultra/utils/shared_prefs.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Preference.init();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    bool isLogin=false;
    Preference.getBool("isLogin")!=null?isLogin=Preference.getBool("isLogin")!:isLogin=false;
    return  MaterialApp(
      onGenerateRoute: getRoute,
      home: isLogin==false?const Login(): BottomNavigationPage(),
      // home: Login(),
      debugShowCheckedModeBanner: false,
    );
  }
}
