import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:organization/services/firebase_notification_service.dart';

import 'app.dart';
import 'package:flutter/material.dart';

import 'core/api_service.dart';
import 'firebase_options.dart';
void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseNotificationService.instance.initialize();
  await dotenv.load(fileName: ".env");
  await Get.putAsync(() {
    return ApiService().init();
  });
  await GetStorage.init();
  runApp( MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp()) );
}
