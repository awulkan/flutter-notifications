import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    new FlutterLocalNotificationsPlugin();

Future onSelectNotification(String payload) async {
  if (payload != null) {
    debugPrint('notification payload: ' + payload);
  }
  print(payload);
}

Future<void> onDidReceiveLocalNotification(int id, String title, String body, String payload) async {
  print(payload);
}

void main() async {
  // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  var initializationSettingsAndroid =
      new AndroidInitializationSettings('app_icon');
  var initializationSettingsIOS = IOSInitializationSettings(
      onDidReceiveLocalNotification: onDidReceiveLocalNotification);
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: onSelectNotification);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

Future<void> instantNotification() async {
  print('Notifying');
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'your channel id', 'your channel name', 'your channel description',
    importance: Importance.Max,
    priority: Priority.High,
    ticker: 'ticker',
    icon: 'app_icon'
  );
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
    androidPlatformChannelSpecifics,
    iOSPlatformChannelSpecifics
  );
  await flutterLocalNotificationsPlugin.show(
    0,
    'Example title',
    'Notification body text',
    platformChannelSpecifics,
    payload: 'item x'
  );
}

Future<void> scheduleDailyNotification() async {
  print('Scheduling daily');
  Time time = new Time(17, 22, 0);
  var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
    'repeatDailyAtTime channel id',
    'repeatDailyAtTime channel name',
    'repeatDailyAtTime description',
    importance: Importance.Max,
    priority: Priority.High,
    icon: 'app_icon'
  );
  var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
  var platformChannelSpecifics = new NotificationDetails(
    androidPlatformChannelSpecifics,
    iOSPlatformChannelSpecifics
  );
  await flutterLocalNotificationsPlugin.showDailyAtTime(
    0,
    'Daily title',
    'Daily notification body',
    time,
    platformChannelSpecifics
  );
}

Future<void> scheduleFutureNotification() async {
  print('Scheduling 5 seconds');
  var scheduledNotificationDateTime = new DateTime.now().add(new Duration(seconds: 5));
  var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
    'your other channel id',
    'your other channel name',
    'your other channel description');
  var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
  NotificationDetails platformChannelSpecifics = new NotificationDetails(
    androidPlatformChannelSpecifics,
    iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.schedule(
    0,
    'scheduled title',
    'scheduled body',
    scheduledNotificationDateTime,
    platformChannelSpecifics);
}

Future<void> repeatNotification() async {
  print('Repeat every minute');
  // Show a notification every minute with the first appearance happening a minute after invoking the method
  var androidPlatformChannelSpecifics =
      new AndroidNotificationDetails(
        'repeating channel id',
        'repeating channel name',
        'repeating description');
  var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
  var platformChannelSpecifics = new NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.periodicallyShow(
    0,
    'repeating title',
    'repeating body',
    RepeatInterval.EveryMinute,
    platformChannelSpecifics);
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FloatingActionButton(
              onPressed: instantNotification,
              tooltip: 'Notify',
              child: Icon(Icons.notifications),
            ),
            Padding(
              padding: EdgeInsets.only(left: 30),
              child: FloatingActionButton(
                onPressed: scheduleDailyNotification,
                tooltip: 'Schedule',
                child: Icon(Icons.calendar_today),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 30),
              child: FloatingActionButton(
                onPressed: scheduleFutureNotification,
                tooltip: 'Schedule',
                child: Icon(Icons.timer),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 30),
              child: FloatingActionButton(
                onPressed: repeatNotification,
                tooltip: 'Schedule',
                child: Icon(Icons.loop),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
