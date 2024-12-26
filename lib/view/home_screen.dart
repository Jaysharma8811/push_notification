import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:push_notification_test/view/services/notification_services.dart';

class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() =>_HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  NotificationServices notificationServices=NotificationServices();

  @override
  void initState() {
    notificationServices.requestNotificationPermission();
    notificationServices.foregroundMessage();
    notificationServices.firebaseInit(context);
    notificationServices.setUpInteractMessage(context);
    notificationServices.getDeviceToken().then((value){
      if(kDebugMode){
        print("Device Token: $value");
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return  const Scaffold(
      body: Center(
        child: Text("this is home screen"),
      ),
    );
  }
}