# Digital dashboard and App for Electric Vehicle

## Objectives
1. To certify an EV to be on the road, requires the Dashboard to have the following parameters: SOC, Fault Codes, Speedometer.
2. To provide a cost-effective solution which is compatible with Electric Vehicles.
3. To monitor the vehicle parameters through a mobile application whose UI is understandable and easy to use.

## Background and Scope
1. Generally Dashboards are imported from other countries which are not very customisable With this project a dashboard can be manufactured in India thus promoting the ideal of ‘Make In India’.
2. Generic Open Source platform dashboard compatible with different electric vehicles.

## Application
1. Digital Dashboard can be integrated into an electric vehicle and used by users as the Human to Machine interface with real-time stats.
2. Mobile Application can be used by the users to know the state of the Electric Vehicle while not using it as well.

## Methodology
1. ECU is connected to the Raspberry Pi board that inflates the GUI on the display.
2. Same vehicle data can be streamed to the app via a Bluetooth on the Raspberry Pi.
3. To design GUI for the dashboard, we used Flutter software because of its compatibility with Raspberry Pi.
4. If Bluetooth is connection, the user is required to switch it on to view the available device to which the user can connect.
5. If the Bluetooth connection is successful, then the user is navigated to the main screen, where the user can monitor the status of the vehicle which is being received from the Bluetooth stream via Raspberry Pi.

## Results
All parameters such as Speedometer, Battery Percentage and fault code were displayed on Physical Dashboard.
