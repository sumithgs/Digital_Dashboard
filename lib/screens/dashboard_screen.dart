import 'package:flutter/material.dart';

import '../widget/change_theme_button.dart';
import '../widget/circular_gauge.dart';
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
      ),
      body: StreamBuilder(
          stream: _channel.stream,
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              final response = jsonDecode(snapshot.data.toString());
              //print(response['SPEED'].toDouble());
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularGauge(
                    value: response['BATTERY'].toDouble(),
                  ),
                  SizedBox(
                    width: (mediaquery.size.width) * 0.4,
                    height: (mediaquery.size.height) * 1,
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
                      innerCirclePadding: 0,
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
                  SizedBox(
                    width: (mediaquery.size.width) * 0.21,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Fault',
                          style: Theme.of(context).textTheme.subtitle1?.apply(
                                color: response['FAULT_VALUE'] == 1
                                    ? Colors.red
                                    : Colors.grey[600],
                              ),
                        ),
                        Icon(
                          Icons.battery_alert_outlined,
                          color: response['FAULT_VALUE'] == 1
                              ? Colors.red
                              : Colors.grey[600],
                          size: 40,
                        ),
                        Column(
                          children: [
                            Text(
                              'Average Speed',
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            Text(
                              '40 Kmph',
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            Text(
                              'Total Distance',
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            Text(
                              '${response['TOTAL_DISTANCE']} Kms',
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          ],
                        )
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
