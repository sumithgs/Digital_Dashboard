import 'package:flutter/material.dart';
import '../widget/change_theme_button.dart';
import '../widget/circular_gauge.dart';
import '../widget/speedgauge.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'package:bluez/bluez.dart';

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
        leading: const Icon(
          Icons.arrow_back,
          color: Colors.green,
          size: 50,
        ),
        actions: const [
          Icon(
            Icons.arrow_forward,
            color: Colors.green,
            size: 50,
          ),
          // ChangeThemeButtonWidget(),
        ],
      ),
      body: StreamBuilder(
          stream: _channel.stream,
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              final response = jsonDecode(snapshot.data.toString());
              //print(response['SPEED'].toDouble());
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircularGauge(
                        value: 80,
                      ),
                      SizedBox(
                        width: (mediaquery.size.width) * 0.55,
                        height: (mediaquery.size.height) * 0.7,
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
                          speed: 30,
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
                      Container(
                        width: (mediaquery.size.width) * 0.1,
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              margin: const EdgeInsets.only(
                                bottom: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                border: Border.all(
                                    color: Theme.of(context).iconTheme.color!),
                              ),
                              child: const Text(
                                'R',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              margin: const EdgeInsets.only(
                                bottom: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                border: Border.all(
                                    color: Theme.of(context).iconTheme.color!),
                              ),
                              child: const Text(
                                'N',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                border: Border.all(
                                    color: Theme.of(context).iconTheme.color!),
                              ),
                              child: const Text(
                                'D',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.battery_alert_outlined,
                        color: Colors.red,
                        size: 40,
                      ),
                      const Icon(
                        Icons.battery_2_bar,
                        color: Colors.red,
                        size: 40,
                      ),
                      Text(
                        'Estimated Range',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      Text(
                        '40 Km',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      Text(
                        'Total Distance',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      Text(
                        '100 Kms',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      IconButton(
                          onPressed: () async {
                            var client = BlueZClient();
                            client.adapterAdded
                                .listen((adapter) => onAdapterAdded(adapter));
                            client.adapterRemoved
                                .listen((adapter) => onAdapterRemoved(adapter));
                            client.deviceAdded
                                .listen((device) => onDeviceAdded(device));
                            client.deviceRemoved
                                .listen((device) => onDeviceRemoved(device));
                            await client.connect();
                          },
                          icon: const Icon(Icons.bluetooth)),
                      ChangeThemeButtonWidget(),
                    ],
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

void onAdapterAdded(BlueZAdapter adapter) {
  print('Adapter [${adapter.address}] ${_getAdapterProperties(adapter, [
        'Alias',
        'Class',
        'Discoverable',
        'Discovering',
        'Pairable',
        'Powered',
        'UUIDs'
      ])}');
  adapter.propertiesChanged
      .listen((properties) => onAdapterPropertiesChanged(adapter, properties));
}

void onAdapterPropertiesChanged(BlueZAdapter adapter, List<String> properties) {
  print(
      'Adapter [${adapter.address}] ${_getAdapterProperties(adapter, properties)}');
}

void onAdapterRemoved(BlueZAdapter adapter) {
  print('Adapter [${adapter.address}] (removed)');
}

String _getAdapterProperties(BlueZAdapter adapter, List<String> properties) {
  return properties
      .map((property) => '$property=${_getAdapterProperty(adapter, property)}')
      .join(', ');
}

String _getAdapterProperty(BlueZAdapter adapter, String property) {
  switch (property) {
    case 'Alias':
      return adapter.alias;
    case 'Class':
      return adapter.deviceClass.toString();
    case 'Discovering':
      return adapter.discovering.toString();
    case 'Discoverable':
      return adapter.discoverable.toString();
    case 'Pairable':
      return adapter.pairable.toString();
    case 'Powered':
      return adapter.powered.toString();
    case 'UUIDs':
      return adapter.uuids.join(',');
    default:
      return '?';
  }
}

void onDeviceAdded(BlueZDevice device) {
  print('Device [${device.address}] ${_getDeviceProperties(device, [
        'Alias',
        'Connected',
        'Name',
        'RSSI'
      ])}');
  device.propertiesChanged
      .listen((properties) => onDevicePropertiesChanged(device, properties));
}

void onDevicePropertiesChanged(BlueZDevice device, List<String> properties) {
  print(
      'Device [${device.address}] ${_getDeviceProperties(device, properties)}');
}

void onDeviceRemoved(BlueZDevice device) {
  print('Device [${device.address}] (removed)');
}

String _getDeviceProperties(BlueZDevice device, List<String> properties) {
  return properties
      .map((property) => '$property=${_getDeviceProperty(device, property)}')
      .join(', ');
}

String _getDeviceProperty(BlueZDevice device, String property) {
  switch (property) {
    case 'Alias':
      return device.alias;
    case 'Connected':
      return device.connected.toString();
    case 'Name':
      return device.name;
    case 'RSSI':
      return device.rssi.toString();
    default:
      return '?';
  }
}
