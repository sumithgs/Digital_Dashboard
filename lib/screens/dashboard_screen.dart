import 'package:flutter/material.dart';

import '../widget/change_theme_button.dart';
import '../widget/speedgauge.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _channel = WebSocketChannel.connect(
    Uri.parse('wss://miniproject-msrit.herokuapp.com/ws2'),
  );
  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: const [
          ChangeThemeButtonWidget(),
        ],
        toolbarTextStyle: Theme.of(context).textTheme.bodyText1,
        titleTextStyle: Theme.of(context).textTheme.headline1,
      ),
      body: StreamBuilder(
          stream: _channel.stream,
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              final response = jsonDecode(snapshot.data.toString());
              //print(response['SPEED'].toDouble());
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: (mediaquery.size.width) * 0.5,
                    padding: const EdgeInsets.all(10),
                    height: (mediaquery.size.height) * 0.9,
                    child: SpeedometerView(
                      unitOfMeasurementTextStyle: TextStyle(
                        color: Theme.of(context).textTheme.headline2?.color,
                        fontSize:
                            Theme.of(context).textTheme.headline2?.fontSize,
                      ),
                      minMaxTextStyle: TextStyle(
                        color: Theme.of(context).textTheme.bodyText1?.color,
                        fontSize:
                            Theme.of(context).textTheme.bodyText1?.fontSize,
                      ),
                      divisionCircleColors: Theme.of(context).primaryColor,
                      innerCirclePadding: 16,
                      speedTextStyle: TextStyle(
                        color: Theme.of(context).textTheme.headline1?.color,
                        fontSize:
                            Theme.of(context).textTheme.headline1?.fontSize,
                      ),
                      speed: response['SPEED'].toDouble(),
                      minSpeed: 0,
                      maxSpeed: 120,
                      alertSpeedArray: const [
                        0.0,
                        20.0,
                        40.0,
                        60.0,
                        80.0,
                        100.0,
                        120.0,
                      ],
                      alertColorArray: const [
                        Colors.green,
                        Colors.green,
                        Colors.orange,
                        Colors.orange,
                        Colors.red,
                        Colors.red,
                        Colors.red,
                      ],
                    ),
                  ),
                ],
              );
            }
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).iconTheme.color,
              ),
            );
          }),
    );
  }
}
