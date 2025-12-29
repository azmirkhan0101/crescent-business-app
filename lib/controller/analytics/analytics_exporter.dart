import 'dart:io';
import 'dart:math';

import 'package:csv/csv.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:open_filex/open_filex.dart';
import 'package:organization/core/show_snackbar.dart';
import 'package:organization/utils/app_color.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart' as OpenAppSettings;
import 'package:permission_handler/permission_handler.dart';

import '../../data/models/analytics/business_analytics_model.dart';

class AnalyticsExporter {

  Future<Directory?>? getExportDirectory() async {
    try {
      // Android: request permission (same as your original code)
      if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        final sdkVersion = androidInfo.version.sdkInt;

        if (sdkVersion >= 30) {
          // Android 11+ requires MANAGE_EXTERNAL_STORAGE
          var status = await Permission.manageExternalStorage.status;
          if (!status.isGranted) {
            status = await Permission.manageExternalStorage.request();
          }

          if (status.isPermanentlyDenied) {
            await OpenAppSettings.openAppSettings();
            showSnackBar(title: 'Permission Required', message: 'Please grant storage permission in app settings', backgroundColor: AppColors.errorRed);
            return null;
          }

          if (!status.isGranted) {
            showSnackBar(title: 'Error', message: 'Storage permission denied. Cannot save PDF.', backgroundColor: AppColors.errorRed);
            return null;
          }
        } else {
          // For older Android versions
          var status = await Permission.storage.status;
          if (!status.isGranted) {
            status = await Permission.storage.request();
          }

          if (status.isPermanentlyDenied) {
            await OpenAppSettings.openAppSettings();
            showSnackBar(title: 'Permission Required', message: 'Please grant storage permission in app settings', backgroundColor: AppColors.warningYellow);
            return null;
          }

          if (!status.isGranted) {
            showSnackBar(title: 'Error', message: 'Storage permission denied. Cannot save PDF.', backgroundColor: AppColors.errorRed);
            return null;
          }
        }
      }

      Directory? directory;

      if (Platform.isAndroid) {
        //Android: use public storage directory
        final externalDir = await getExternalStorageDirectory();
        if (externalDir == null) {
          showSnackBar(title: 'Error', message: 'Cannot access external storage', backgroundColor: AppColors.errorRed);
          return null;
        }

        // Extract the root path (/storage/emulated/0)
        final rootPath = externalDir.path.split('/Android')[0];
        directory = Directory('$rootPath/Invoices');

        debugPrint('Root path: $rootPath');
        debugPrint('Target directory: ${directory.path}');
      } else if (Platform.isIOS) {
        // ✅ iOS: Save to user-visible Documents directory
        // This directory is accessible via the Files app under “On My iPhone/<AppName>/”
        final docsDir = await getApplicationDocumentsDirectory();
        directory = Directory('${docsDir.path}/Invoices');

        debugPrint('iOS visible directory: ${directory.path}');
      } else {
        directory = await getTemporaryDirectory();
        directory = Directory('${directory.path}/Invoices');
      }

      // Create directory if it doesn't exist
      if (!await directory.exists()) {
        try {
          await directory.create(recursive: true);
          debugPrint('Directory created: ${directory.path}');
        } catch (e) {
          debugPrint('Error creating directory: $e');
          showSnackBar(title: 'Error', message: 'Failed to create directory: $e', backgroundColor: AppColors.errorRed);
          return null;
        }
      }

      // Check if directory is writable
      try {
        final testFile = File('${directory.path}/test.txt');
        await testFile.writeAsString('test');
        await testFile.delete();
        debugPrint('Directory is writable');
      } catch (e) {
        debugPrint('Directory is not writable: $e');
        showSnackBar(title: 'Error', message: 'Cannot write to directory: $e', backgroundColor: AppColors.errorRed);
        return null;
      }
      if( directory != null ){
        return directory;
      }else{
        return null;
      }
    } catch (e) {
      showSnackBar(title: 'Error', message: 'Failed to save PDF to storage: $e', backgroundColor: AppColors.errorRed);
      return null;
    }
  }

  // 1. Export to CSV
  Future<void> exportToCSV(BusinessAnalyticsModel data) async {

    Directory? directory = await getExportDirectory();
    if( directory == null ){
      return;
    }else{
      List<List<dynamic>> rows = [];

      // Headers
      rows.add(["Metric", "Value", "Percentage", "Trend"]);
      rows.add(["Total Redemptions", data.totalRedemptions, "", ""]);
      rows.add(["Profile Views", data.profileViews, "${data.profilePercentage}%", data.profileViewsIncrease ? "Increase" : "Decrease"]);
      rows.add(["Website Views", data.websiteViews, "${data.websitePercentage}%", data.websiteViewsIncrease ? "Increase" : "Decrease"]);

      rows.add([]); // Spacer
      rows.add(["Redemption Methods", "Count", "Percentage"]);
      for (var method in data.methods) {
        rows.add([method.method, method.count, "${method.percentage}%"]);
      }

      rows.add([]); // Spacer
      rows.add(["Top Rewards", "Percentage"]);
      for (var tops in data.topRewards) {
        rows.add([tops.title, "${tops.percentage}%"]);
      }

      String csvData = const ListToCsvConverter().convert(rows);
      await _saveFile(csvData, "business_analytics.csv", directory: directory );
    }
  }

  // 2. Export to PDF
  Future<void> exportToPDF(BusinessAnalyticsModel data) async {

    Directory? directory = await getExportDirectory();
    if( directory == null ){
      return;
    }else{
      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return [
              pw.Header(level: 0, child: pw.Text("Business Analytics Report", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold))),
              pw.SizedBox(height: 10),

              // --- General Metrics Table ---
              pw.Text("General Overview", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 5),
              pw.TableHelper.fromTextArray(
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                headers: ["Metric", "Value", "Percentage", "Trend"],
                data: [
                  ["Total Redemptions", data.totalRedemptions, "", ""],
                  ["Profile Views", data.profileViews, "${data.profilePercentage}%", data.profileViewsIncrease ? "Increase" : "Decrease"],
                  ["Website Views", data.websiteViews, "${data.websitePercentage}%", data.websiteViewsIncrease ? "Increase" : "Decrease"],
                ],
              ),

              pw.SizedBox(height: 25),

              // --- Redemption Methods Table ---
              pw.Text("Redemption Methods", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 5),
              pw.TableHelper.fromTextArray(
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                headers: ["Method", "Count", "Percentage"],
                data: data.methods.map((m) => [m.method, m.count, "${m.percentage}%"]).toList(),
              ),

              pw.SizedBox(height: 25),

              // --- Top Rewards Table ---
              pw.Text("Top Rewards", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 5),
              pw.TableHelper.fromTextArray(
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                headers: ["Reward Title", "Percentage"],
                data: data.topRewards.map((r) => [r.title, "${r.percentage}%"]).toList(),
              ),
            ];
          },
        ),
      );

      final bytes = await pdf.save();
      await _saveFile(bytes, "business_analytics.pdf", isBytes: true, directory: directory);
    }
  }

  // Helper: Save file to storage
  Future<void> _saveFile(dynamic content, String fileName, {bool isBytes = false, required Directory directory}) async {

    final file = File("${directory.path}/$fileName");

    try {
      if (isBytes) {
        await file.writeAsBytes(content);
      } else {
        await file.writeAsString(content);
      }
      _showNotification(file.path);
    } catch (e) {
    }
  }

  // Helper: Permissions
  Future<bool> _requestPermission() async {
    var status = await Permission.storage.request();
    if (status.isDenied) {
      status = await Permission.manageExternalStorage.request();
    }
    return status.isGranted;
  }

  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  AnalyticsExporter() {
    _initNotifications();
  }

  // Initialize settings for Android and iOS
  Future<void> _initNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) async{
        if (details.payload != null && details.payload!.isNotEmpty) {
          /// Trigger the file opening logic
          await _openDownloadedFile(details.payload!);
        }
      },
    );
  }

  Future<void> _openDownloadedFile(String filePath) async {
    final result = await OpenFilex.open(filePath);

    if (result.type != ResultType.done) {
      // Handle errors (e.g., file not found or no app to open it)
      showSnackBar(title: "Cannot open file", message: "Try opening from file manager.", backgroundColor: AppColors.warningYellow);
    }
  }

  void _showNotification(String path) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'export_channel_id',
      'File Exports',
      channelDescription: 'Notifications for saved CSV and PDF files',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    // Get only the filename for the title
    String fileName = path.split('/').last;
    //String fileName = path;

    await _notificationsPlugin.show(
      0, // Notification ID
      'File Saved Successfully',
      '$fileName', // The body shows the filename
      platformChannelSpecifics,
      payload: path, // We pass the path so tapping the notification can open the file
    );
  }
}
