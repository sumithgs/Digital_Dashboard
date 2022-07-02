import 'package:flutter/material.dart';

class DlScreen extends StatelessWidget {
  const DlScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Driver's License"),
      ),
      body: Center(
        child: Container(
          width: (mediaquery.size.width) * 0.7,
          height: (mediaquery.size.height) * 0.7,
          padding: const EdgeInsets.all(8),
          child: Image.asset("assets/images/rc.png"),
        ),
      ),
    );
  }
}
