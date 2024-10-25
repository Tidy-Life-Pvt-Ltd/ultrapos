import 'package:flutter/material.dart';
import 'package:project_ultra/screens/login.dart';
import 'package:project_ultra/utils/shared_prefs.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  CustomAppBar({required this.title,this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      automaticallyImplyLeading: false,
      actions: [
        ...?actions,
        PopupMenuButton<String>(
          onSelected: (value) async{
            if (value == 'logout') {
              await Preference.setBool("isLogin", true);
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Login()));
            }
          },
          icon: Icon(Icons.more_vert),
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem<String>(
                height: 30,
                value: 'logout',
                child: Text('Log Out'),
              ),
            ];
          },
        ),
      ],
    );
  }

  // This sets the height of the AppBar
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
