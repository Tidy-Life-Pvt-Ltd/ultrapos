import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:project_ultra/model/branchresponse.dart';
import 'package:project_ultra/screens/home_page.dart';
import 'package:project_ultra/screens/pdc_screen.dart';
import 'package:project_ultra/screens/pos_screen.dart';
import 'package:project_ultra/screens/purchase.dart';
import 'package:project_ultra/screens/sales.dart';
import '../utils/assets.dart';
import '../utils/constants.dart';
import '../utils/customcolor.dart';
import '../utils/divider.dart';
import '../utils/shared_prefs.dart';
import '../utils/text_home.dart';

class BottomNavigationPage extends StatefulWidget {
  @override
  BottomNavigationPageState createState() => BottomNavigationPageState();
}

class BottomNavigationPageState extends State<BottomNavigationPage> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List<BranchResponse> branchList = [];
  BranchResponse branchResponse =
      BranchResponse(companyName: "0", companyCode: "Please selcet Company");
  int selectedIndex = 0;

  final widgetOptions = [
    HomePage(),
    SalesScreen(),
    PurchaseScreen(),
    POSScreen(),
    PdcScreen(),
  ];
  String apptitle = "";

  void showModal(int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.21,
        child: index == 1 ? salesModal(index) : purchaseModal(index),
      ),
    );
  }

  void onTabTapped(int index) {
    if (index == 1 || index == 2)
      showModal(index);
    else {
      index == 3
          ? apptitle = "POS"
          : index == 4
              ? apptitle = "PDC"
              : "";
      setState(() {
        selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double height= MediaQuery.of(context).size.height;
    double width= MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: widgetOptions.elementAt(selectedIndex),
      ),
      bottomNavigationBar: Container(
          child: SizedBox(
              height: MediaQuery.of(context).size.height / 10,
              child: new BottomNavigationBar(
                  selectedItemColor: CustomColors.red,
                  unselectedItemColor: CustomColors.hintColorDark,
                  onTap: onTabTapped,
                  backgroundColor: CustomColors.lightWhite1,
                  currentIndex: selectedIndex,
                  type: BottomNavigationBarType.fixed,
                  selectedLabelStyle:
                      TextStyle(fontFamily: "stsbold", fontSize: 14),
                  unselectedLabelStyle: TextStyle(
                      color: CustomColors.hintColor,
                      fontFamily: "stsregular",
                      fontSize: 13),
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.home,
                      ),
                      label: Constants.labelHome,
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.shopping_cart_outlined),
                      label: Constants.labelSales,
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.card_travel),
                      label: Constants.labelPurchase,
                    ),
                    BottomNavigationBarItem(
                      icon: Image.asset(
                        pos,
                        width: width/15,
                        height: height/28.83,
                      ),
                      label: Constants.labelPos,
                    ),
                    BottomNavigationBarItem(
                      icon: Image.asset(pdc, width: width/15,
                        height: height/28.83,),
                      activeIcon: Image.asset(
                        pdc,
                        width: width/15,
                        height: height/28.83,
                        color: CustomColors.red,
                      ),
                      label: Constants.labelPdc,
                    ),
                  ]))),
    );
  }

  Widget salesModal(int index) {
    double height= MediaQuery.of(context).size.height;
    double width= MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          height: height/16.87,
            padding: EdgeInsets.symmetric(vertical: width/36),
            width: MediaQuery.of(context).size.width,
            decoration: new BoxDecoration(
                gradient: new LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [CustomColors.bluelight1, CustomColors.bluelight],
            )),
            child: CustomTextField(
                size: 18,
                txt: "Select your option",
                colr: CustomColors.white,
                fontWeight: FontWeight.bold,
                font: "stsbold")),
        new GestureDetector(
            onTap: () {
              print('------- SALES I -------');
              apptitle = "Sales";
              setSalesTypeData("s", "C");
              setState(() {
                selectedIndex = index;
              });
              //SalesScreen();
              Navigator.pop(context);
            },
            child: new Container(
                color: CustomColors.white,
                padding:
                    EdgeInsets.symmetric(vertical: width/36, horizontal: height/138.4),
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w700),
                    children: [
                      WidgetSpan(
                          child: Image.asset(
                            sales,
                            width: width/15,
                            height: height/28.83,
                            color: CustomColors.blue1,
                          ),
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: CustomColors.blue1)),
                      TextSpan(
                        text: "  Sales",
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ))),
        DividerSec(thick: 0.9, from: 2, colr: CustomColors.blue1),
        new GestureDetector(
            onTap: () {
              print('------- SALES II -------');
              apptitle = "Sales Return";
              setSalesTypeData("sr", "C");

              setState(() {
                selectedIndex = index;
              });
              //SalesScreen();
              Navigator.pop(context);
            },
            child: new Container(
                alignment: Alignment.centerLeft,
                color: CustomColors.white,
                padding:
                    EdgeInsets.symmetric(vertical: width/36, horizontal: height/138.4),
                width: MediaQuery.of(context).size.width,
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w700),
                    children: [
                      WidgetSpan(
                          child: Image.asset(
                            salesReturn,
                            width: width/15,
                            height: height/28.83,
                            color: CustomColors.blue1,
                          ),
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: CustomColors.blue1)),
                      TextSpan(
                        text: "  Sales Return",
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ))),
      ],
    );
  }

  Widget purchaseModal(int index) {
    double height= MediaQuery.of(context).size.height;
    double width= MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
            height: height/16.87,
            padding:  EdgeInsets.symmetric(vertical: width/36),
            width: MediaQuery.of(context).size.width,
            decoration: new BoxDecoration(
                gradient: new LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [CustomColors.bluelight1, CustomColors.bluelight],
            )),
            child: CustomTextField(
                size: 18,
                txt: "Select your option",
                colr: CustomColors.white,
                fontWeight: FontWeight.bold,
                font: "stsbold")),
        new GestureDetector(
            onTap: () {
              print('------- PURCHASE I -------');
              apptitle = "Purchase";
              setSalesTypeData("p", "S");
              //SalesScreen();
              setState(() {
                selectedIndex = index;
              });

              Navigator.pop(context);
            },
            child: new Container(
                color: CustomColors.white,
                padding:
                    EdgeInsets.symmetric(vertical: width/36, horizontal: height/138.4),
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w700),
                    children: [
                      WidgetSpan(
                          child: Image.asset(
                            purchase,
                            width: width/15,
                            height: height/28.83,
                            color: CustomColors.blue1,
                          ),
                          style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: CustomColors.blue1)),
                      TextSpan(
                        text: "  Purchase",
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ))),
        DividerSec(thick: 0.9, from: 2, colr: CustomColors.blue1),
        new GestureDetector(
            onTap: () {
              print('-----------purchase return');

              apptitle = "Purchase Return";
              setSalesTypeData("pr", "S");

              setState(() {
                selectedIndex = index;
              });

              Navigator.pop(context);
              if (selectedIndex == 2) {
                SalesScreen();
              }
            },
            child: new Container(
                color: CustomColors.white,
                alignment: Alignment.centerLeft,
                padding:
                    EdgeInsets.symmetric(vertical: width/36, horizontal: height/138.4),
                width: MediaQuery.of(context).size.width,
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w700),
                    children: [
                      WidgetSpan(
                          child: Image.asset(
                            purchasereturn,
                            width: width/15,
                            height: height/28.83,
                            color: CustomColors.blue1,
                          ),
                          style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: CustomColors.blue1)),
                      const TextSpan(
                        text: "  Purchase Return",
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ))),
      ],
    );
  }

  Future<void> setSalesTypeData(String type, String searchParam) async {
    await Preference.setString("type", type);
    await Preference.setString("searchParam", searchParam);
  }
}
