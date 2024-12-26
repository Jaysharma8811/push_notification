import 'dart:io';
import 'dart:math';

import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:push_notification_test/view/message_screen.dart';

class NotificationServices {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // notification permission handler function --------start
  void requestNotificationPermission() async {
    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      provisional: true,
      sound: true,
      announcement: true,
      carPlay: true,
      criticalAlert: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print("user allow permissions");
      }
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print("user allow provisional permissions");
      }
    } else {
      if (kDebugMode) {
        AppSettings.openAppSettings(type: AppSettingsType.notification);
        print("user denied permissions");
      }
    }
  }
// notification permission handler function--------end

//  init Local notification   function -------------start

  void initLocalNotifications(BuildContext context,
       RemoteMessage message) async {
    var androidInitializationSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSetting = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);
    await _flutterLocalNotificationsPlugin.initialize(initializationSetting,
        onDidReceiveNotificationResponse: (payload) {
      handleMessage(context,message);
        });
  }
  // init local notification function ------------ends

// Firebase init  function -------------start
  void firebaseInit(BuildContext context ) {
    FirebaseMessaging.onMessage.listen((message) {
      if (kDebugMode) {
        print(message.notification!.title.toString());
        print(message.notification!.body.toString());
        print(message.data.toString());
      }
      if (Platform.isAndroid) {
        if (!context.mounted) return;
        initLocalNotifications(context, message);
        showNotification(message);
      }
      if(Platform.isIOS){
        foregroundMessage();
      }

    });
  }
// firebase init function -------------end

// show Notification  function -------------start
  Future<void> showNotification(RemoteMessage message) async {

    AndroidNotificationChannel channel = AndroidNotificationChannel(
        Random.secure().nextInt(100000).toString(),
        'High Importance Notification',
        importance: Importance.max,
        description: "channel description");

    AndroidNotificationDetails androidNotificationDetails=AndroidNotificationDetails(
        channel.id,
        channel.name,
        channelDescription: "channel description",
        importance: Importance.high,
        priority: Priority.high,
        ticker: 'ticker'
    );

    const DarwinNotificationDetails darwinNotificationDetail=DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails=NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetail
    );

    Future.delayed(Duration.zero,(){
      _flutterLocalNotificationsPlugin.show(
          0,
          message.notification!.title,
          message.notification!.body,
          notificationDetails);
    });

  }
// Show Notification function -------------end

// get device token function -------------start
  Future<String> getDeviceToken() async {
    String? token = await firebaseMessaging.getToken();
    return token!;
  }
// get device token function -------------end

// get device refresh token function -------------start
  void isTokenRefresh() async {
    firebaseMessaging.onTokenRefresh.listen((event) {
      event.toString();
    });
  }
// get device refresh token function -------------end

// function to handel redirection when app is in background or terminated---start
Future<void> setUpInteractMessage(BuildContext context)async{
//     when app is terminated

RemoteMessage? initialMessage= await FirebaseMessaging.instance.getInitialMessage();

if(initialMessage !=null){
  if (!context.mounted) return;
  handleMessage(context, initialMessage);
}

// when app is in background
FirebaseMessaging.onMessageOpenedApp.listen((event){
  if (!context.mounted) return;
  handleMessage(context, event);

  });

}
// function to handel redirection when app is in background or terminated---end



//  handleMessage function -------------------start
void handleMessage(BuildContext context ,RemoteMessage message){
    if(message.data['type']=='msg'){
      Navigator.push(context,MaterialPageRoute(builder: (context)=>const MessageScreen()));
    }
}
//  handleMessage function -------------------end



// for ios to show foregroundMessage----------------start
Future foregroundMessage()async{
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      sound: true,
      badge: true
    );
}
// for ios to show foregroundMessage----------------end


}
