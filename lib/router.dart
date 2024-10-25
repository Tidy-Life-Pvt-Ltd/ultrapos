
import 'package:flutter/material.dart';
import 'package:project_ultra/screens/bottom_navigation_bar.dart';
import 'package:project_ultra/screens/home_page.dart';
import 'package:project_ultra/screens/login.dart';
import 'package:project_ultra/screens/pdc_screen.dart';
import 'package:project_ultra/screens/pos_screen.dart';
import 'package:project_ultra/screens/purchase.dart';
import 'package:project_ultra/screens/sales.dart';


class AppRoutes {
  static const String loginScreen = 'login_screen';
  static const String homeScreen = 'home_screen';
  static const String sales = 'sales_screen';
  static const String purchase = 'purchase_screen';
  static const String pos = 'pos_screen';
  static const String pdc = 'pdc_screen';
}

Route<dynamic>? getRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.loginScreen:
      return _buildLoginScreen();
    case AppRoutes.homeScreen:
      return _buildHomeScreen();
    case AppRoutes.sales:
      return _buildSales();
    case AppRoutes.purchase:
      return _buildPurchase();
    case AppRoutes.pos:
      return _buildPOS();
    case AppRoutes.pdc:
      return _buildPDC();
  }
}

Route<dynamic> _buildLoginScreen() {
  return MaterialPageRoute(
      builder: (BuildContext context) => PageBuilder.buildLoginScreen());
}

Route<dynamic> _buildHomeScreen() {
  return MaterialPageRoute(
      builder: (BuildContext context) => PageBuilder.buildHomeScreen());
}

Route<dynamic> _buildSales() {
  return MaterialPageRoute(
      builder: (BuildContext context) => PageBuilder.buildSales());
}

Route<dynamic> _buildPurchase() {
  return MaterialPageRoute(
      builder: (BuildContext context) => PageBuilder.buildPurchase());
}

Route<dynamic> _buildPOS() {
  return MaterialPageRoute(
      builder: (BuildContext context) => PageBuilder.buildPOS());
}

Route<dynamic> _buildPDC() {
  return MaterialPageRoute(
      builder: (BuildContext context) => PageBuilder.buildPDC());
}

class PageBuilder{
  static Widget buildLoginScreen() {
    return const Login();
  }

  static Widget buildHomeScreen() {
    return BottomNavigationPage();
  }

  static Widget buildSales() {
    return  const SalesScreen();
  }

  static Widget buildPurchase() {
    return  const PurchaseScreen();
  }


  static Widget buildPOS() {
    return  const POSScreen();
  }


  static Widget buildPDC() {
    return  const PdcScreen();
  }


}