import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:wa_status_saver/ads/app_lifecycle_reactor.dart';
import 'package:wa_status_saver/ads/app_open_ad_manager.dart';
import 'package:wa_status_saver/pages/homepage.dart';
import 'package:wa_status_saver/status_saver.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeService();

  MobileAds.instance.initialize();
  runApp(const MyHomePage(title: "WhatsApp Status Saver"));
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'my_foreground', 
    'MY FOREGROUND SERVICE', 
    description:
        'This channel is used for important notifications.', 
    importance: Importance.low, 
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (Platform.isIOS || Platform.isAndroid) {
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        iOS: DarwinInitializationSettings(),
        android: AndroidInitializationSettings('app_icon'),
      ),
    );
  }

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,

      notificationChannelId: 'my_foreground',
      initialNotificationTitle: 'Whatsapp Status Saver',
      initialNotificationContent: 'Checking for New Statuses',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );
}

// to ensure this is executed
// run app from xcode, then from xcode menu, select Simulate Background Fetch

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();

  // For flutter prior to version 3.0.0
  // We have to register the plugin manually

  /// OPTIONAL when use custom notification
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  // bring to foreground
  Timer.periodic(const Duration(minutes: 1), (timer) async {
    StatusSaver.downloadStatusAuto();
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        flutterLocalNotificationsPlugin.show(
          888,
          'Whatsapp Status Saver',
          'Checking for New Status',
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'my_foreground',
              'Whatsapp Status Saver',
              icon: 'app_icon',
              ongoing: true,
            ),
          ),
        );

        // if you don't using custom notification, uncomment this
        service.setForegroundNotificationInfo(
          title: "Checking for New Statuses",
          content: StatusSaver.checkNewStatus()
              ? "New Status Available"
              : "No New Status Available",
        );
      }
    }
  });
}

void appPermissionManager() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  if (prefs.getBool('noti') == null || prefs.getBool('noti') == false) {
    PermissionStatus status = await Permission.notification.request();
    if (status.isGranted) {
      await prefs.setBool('noti', true);
      Fluttertoast.showToast(
        msg: "Notifications Enables",
        toastLength: Toast.LENGTH_LONG,
      );
    } else {
      await prefs.setBool('noti', false);
      Fluttertoast.showToast(
        msg: "Open settings to enable notification permission",
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }
  // if (prefs.getBool('batt') == null || prefs.getBool('batt') == false) {
  //   OptimizeBattery.isIgnoringBatteryOptimizations().then((onValue) async {
  //     if (onValue) {
  //       await prefs.setBool('batt', true);
  //     } else {
  //       await prefs.setBool('batt', false);
  //       OptimizeBattery.openBatteryOptimizationSettings();
  //     }
  //   });
  // }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late AppLifecycleReactor _appLifecycleReactor;

  @override
  void initState() {
    super.initState();

    AppOpenAdManager appOpenAdManager = AppOpenAdManager()..loadAppOpenAd();
    _appLifecycleReactor =
        AppLifecycleReactor(appOpenAdManager: appOpenAdManager);
    _appLifecycleReactor.listenToAppStateChanges();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: widget.title,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal.shade200),
      ),
      home: const HomePage(),
    );
  }
}
