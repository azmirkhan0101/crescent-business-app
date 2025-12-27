import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';

import '../../data/models/analytics/business_analytics_model.dart';

class AnalyticsExporter {

  // 1. Export to CSV
  Future<void> exportToCSV(BusinessAnalyticsModel data) async {

    print("Model to export: $data");

    if (await _requestPermission()) {
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

      String csvData = const ListToCsvConverter().convert(rows);
      await _saveFile(csvData, "business_analytics.csv");
    }
  }

  // 2. Export to PDF
  Future<void> exportToPDF(BusinessAnalyticsModel data) async {
    if (await _requestPermission()) {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text("Business Analytics Report", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                pw.Divider(),
                pw.Text("Total Redemptions: ${data.totalRedemptions}"),
                pw.Text("Profile Views: ${data.profileViews} (${data.profilePercentage}%)"),
                pw.Text("Website Views: ${data.websiteViews} (${data.websitePercentage}%)"),
                pw.SizedBox(height: 20),
                pw.Text("Top Rewards", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.Bullet(text: data.topRewards.map((e) => "${e.title}: ${e.percentage}%").join("\n")),
              ],
            );
          },
        ),
      );

      final bytes = await pdf.save();
      await _saveFile(bytes, "business_analytics.pdf", isBytes: true);
    }
  }

  // Helper: Save file to storage
  Future<void> _saveFile(dynamic content, String fileName, {bool isBytes = false}) async {
    Directory? directory;
    if (Platform.isAndroid) {
      directory = await getDownloadsDirectory();
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    if (directory == null) {
      print("Could not get the downloads directory.");
      return;
    }

    final file = File("${directory.path}/$fileName");

    try {
      if (isBytes) {
        await file.writeAsBytes(content);
      } else {
        await file.writeAsString(content);
      }
      _showNotification(file.path);
    } catch (e) {
      print("Error saving file: $e");
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
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        if (details.payload != null) {
          // Opens the file when the notification is tapped
          //OpenFilex.open(details.payload);
        }
      },
    );
  }

  void _showNotification(String path) async {
    // Define notification details for Android
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'export_channel_id', // ID
      'File Exports',      // Name
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

    await _notificationsPlugin.show(
      0, // Notification ID
      'File Saved Successfully',
      '$fileName', // The body shows the filename
      platformChannelSpecifics,
      payload: path, // We pass the path so tapping the notification can open the file
    );
  }
}
