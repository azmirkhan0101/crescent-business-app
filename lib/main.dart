import 'package:get_storage/get_storage.dart';

import 'app.dart';
import 'package:flutter/material.dart';
void main() async{

  await GetStorage.init();
  runApp(const MyApp());
}
