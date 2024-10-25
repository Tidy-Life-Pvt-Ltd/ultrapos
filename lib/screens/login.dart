import 'package:flutter/material.dart';
import 'package:project_ultra/model/loginresponse.dart';
import 'package:project_ultra/router.dart';
import 'package:project_ultra/services/api.dart';
import 'package:project_ultra/utils/constants.dart';
import 'package:project_ultra/utils/customcolor.dart';
import 'package:project_ultra/utils/shared_prefs.dart';
import 'package:project_ultra/utils/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/assets.dart';
import '../widgets/customtext.dart';
import '../utils/validator.dart';
import '../widgets/buttonsection.dart';
import '../widgets/progressdialoge.dart';
import '../widgets/sizedbox.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  void _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'altrabright@hotmail.com',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      print('Could not launch email');
    }
  }

  void _launchPhone() async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: '037641114',
    );
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      print('Could not launch phone');
    }
  }


  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController compGroupCodeController = TextEditingController();

  String hintUsername = Constants.hintUsername;
  String hintPassword = Constants.hintPassword;
  String hintCompanyGroupCode = Constants.hintCompanyGroupCode;

  FocusNode focusNodeUsername = FocusNode();
  FocusNode focusNodePassword = FocusNode();
  FocusNode focusNodeCompanyGroupCode = FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _dialogeKey = GlobalKey<FormState>();

  bool _passworVissible = false;
  String companyCode = "";

  void initState() {
    super.initState();
    setState(() {
      focusNodeUsername.addListener(() {
        setState(() {
          hintUsername =
              focusNodeUsername.hasFocus ? '' : Constants.hintUsername;
        });
      });
    });
    setState(() {
      focusNodePassword.addListener(() {
        setState(() {
          hintPassword =
              focusNodePassword.hasFocus ? '' : Constants.hintPassword;
        });
      });
    });

    focusNodeCompanyGroupCode.addListener(() {
      setState(() {
        hintCompanyGroupCode = focusNodeCompanyGroupCode.hasFocus
            ? ''
            : Constants.hintCompanyGroupCode;
      });
    });
  }

  void getBranches() async {
    try {
      APIService apiService = new APIService();
      final result = await apiService.getBranches(compGroupCodeController.text);
      if (result.status == true) {
        if (result.branchList != null && result.branchList!.length > 0) {
          companyCode = result.branchList![0].companyCode!;
          //SnackBarSection.showSnackBarWithoutTitle(context, companyCode);
          // ToastMessage.showSnackBarWithoutTitle(context,result.message! );
          await Preference.setString(
              "BranchesName", result.branchList![0].companyName);
          login();
        } else {
          Navigator.of(context, rootNavigator: true).pop();
          ToastMessage.showSnackBarWithoutTitle(context, Constants.noBranches);
          // SnackBarSection.showSnackBarWithoutTitle(
          //     context, Constants.noBranches);
        }
      } else {
        Navigator.of(context, rootNavigator: true).pop();

        ToastMessage.showSnackBarWithoutTitle(
            context, Constants.errorUsernameandPassword);
        // SnackBarSection.showSnackBarWithoutTitle(
        //     context, Constants.errorUsernameandPassword);
      }
    } catch (error) {
      print(error);
      Navigator.of(context, rootNavigator: true).pop();
      ToastMessage.showSnackBarWithoutTitle(context, Constants.labelError);

      // SnackBarSection.showSnackBarWithoutTitle(
      //     context, Constants.labelError);
    }
  }

  void login() async {
    try {
      LoginRequest loginRequest = new LoginRequest(
          username: userNameController.text,
          password: passwordController.text,
          comanyCode: companyCode);
      APIService apiService = new APIService();
      final result = await apiService.login(loginRequest);
      if (result != null && result.status == true) {
        print('---- ENTER THESE LINE -----------');
        // Navigator.of(context, rootNavigator: true).pop();
        setLogin();
      } else {
        Navigator.of(context, rootNavigator: true).pop();
        ToastMessage.showSnackBarWithoutTitle(
            context, Constants.errorUsernameandPassword);

        // SnackBarSection.showSnackBarWithoutTitle(
        //     context, Constants.errorUsernameandPassword);
      }
    } catch (error) {
      print(error);
      Navigator.of(context, rootNavigator: true).pop();
      ToastMessage.showSnackBarWithoutTitle(context, Constants.labelError);

      // SnackBarSection.showSnackBarWithoutTitle(
      //     context, Constants.labelError);
    }
  }

  Future<void> setLogin() async {
    print('------------------- LOGINNNNNNNNNNNNNNNNN');
    await Preference.setBool("isLogin", true);
    await Preference.setString("comapnyCode", companyCode);
    await Preference.setString("GroupCode", compGroupCodeController.text);
    Navigator.pushNamed(context, AppRoutes.homeScreen);
    // Navigator.of(context)
    //     .push(_createRoute());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.blue1,
        title: Text('Login',
        style: TextStyle(
          color: Colors.white
        ),),
        automaticallyImplyLeading: false,

        actions: [
          IconButton(
            icon: Icon(Icons.info,color: Colors.white,),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
              /*    Future.delayed(Duration(seconds: 2), () {
                    Navigator.of(context).pop(); // Close the dialog
                  });*/
                  return AlertDialog(
                    backgroundColor: Colors.white,
                    contentPadding: EdgeInsets.zero,
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: CustomColors.blue1,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              "The App is Powered By",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset(
                                'assets/images/altrabright.jpeg',
                                width: 70,
                                height: 150,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "ULTRAPOS SOFTWARE",

                                    style: TextStyle(fontWeight: FontWeight.bold,letterSpacing: 1.0
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _launchEmail;
                                        print("------------->email----------------");
                                      });
                                    },
                                    child: Text(
                                      "altrabright@hotmail.com",
                                      style: TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                        decorationColor: Colors.blue,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "Customer Care Support:",
                                    style: TextStyle(
                                      color: Colors.black87,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _launchPhone();
                                        print("------------->phone----------------");
                                      });
                                    },
                                    child: Text(
                                      "037641114, 0558688399",
                                      style: TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                        decorationColor: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(0)),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      backgroundColor: CustomColors.white,
      body: Center(
        child: Container(
          child: containerContent(),
        ),
      ),
    );
  }


  Widget containerContent() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: CustomColors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    appicon,
                    height: height / 4.32,
                    width: width / 2.57,
                  ),
                  SizedBoxSection(height: height / 69.2, width: 0),
                  CustomTextForm(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: userNameController,
                    labelText: Constants.hintUsername,
                    hintText: hintUsername,
                    focusNode: focusNodeUsername,
                    validator: FieldValidators.usernameValidator,
                    labelStyle: TextStyle(
                        color: focusNodeUsername.hasFocus
                            ? CustomColors.borderColorEnabled
                            : CustomColors.hintColor),
                  ),
                  SizedBox(
                    height: height / 34.6,
                    width: 0,
                  ),
                  CustomTextForm(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: passwordController,
                    focusNode: focusNodePassword,
                    validator: FieldValidators.passwordValidator,
                    obscureText: _passworVissible,
                    labelText: Constants.hintPassword,
                    hintText: hintPassword,
                    labelStyle: TextStyle(
                        color: focusNodePassword.hasFocus
                            ? CustomColors.borderColorEnabled
                            : CustomColors.hintColor),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passworVissible
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: CustomColors.hintColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _passworVissible = !_passworVissible;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: height / 34.6,
                    width: width / 36,
                  ),
                  CustomTextForm(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: compGroupCodeController,
                    labelText: Constants.hintCompanyGroupCode,
                    hintText: hintCompanyGroupCode,
                    focusNode: focusNodeCompanyGroupCode,
                    validator: FieldValidators.companyCodeValidator,
                    labelStyle: TextStyle(
                        color: focusNodeCompanyGroupCode.hasFocus
                            ? CustomColors.borderColorEnabled
                            : CustomColors.hintColor),
                  ),
                  SizedBoxSection(height: height / 13.84, width: 0),
                  ButtonSection(
                    height: height / 17.3,
                    width: double.infinity,
                    brdRadius: BorderRadius.circular(20),
                    thick: 2,
                    txt: Constants.labelLogin,
                    txtColr: CustomColors.white,
                    fontFamily: "",
                    btAction: () {
                      if (_formKey.currentState!.validate()) {
                        ProgressDialog.showLoadingDialog(context, _dialogeKey);
                        getBranches();

                        // Show the AlertDialog here

                        // Navigator.pushReplacementNamed(context, AppRoutes.homeScreen);
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => BottomNavigationPage()),
                        // );
                      }
                    },
                  ),

                  SizedBoxSection(height: height / 23.06, width: 0),
                  Image.asset(
                    altrabright,
                    width: width / 3,
                    height: height / 6.92,
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.bottomCenter,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
