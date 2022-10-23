import 'package:flutter/material.dart';
import 'package:hel/screens/license.dart';
import 'package:hel/screens/rcbook.dart';
//import 'package:ui_app/screens/testing_custom_gauge.dart';

class DrawerScreen extends StatelessWidget {
  static const routeName = '/drawerscreen';
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          ListTile(
            leading: Icon(
              Icons.wallet,
              color: Theme.of(context).iconTheme.color,
            ),
            title: Text(
              'RC Book',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            onTap: () {
              //Navigator.of(context).pushNamed(RcScreen.routeName);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RcScreen(),
                ),
              );
            },
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DlScreen(),
                ),
              );
            },
            leading: Icon(
              Icons.directions_car,
              color: Theme.of(context).iconTheme.color,
            ),
            title: Text(
              'Driver License',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
        ],
      ),
    );
  }
}
