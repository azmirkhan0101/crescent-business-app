import 'dart:io';

import 'package:csv/csv.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
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
  AnalyticsExporter() {
    _initNotifications();
  }

  // 1. Export to CSV
  Future<void> exportToCSV(BusinessAnalyticsModel data) async {
    List<List<dynamic>> rows = [];

    // Headers
    rows.add(["Metric", "Value", "Percentage", "Trend"]);
    rows.add(["Total Redemptions", data.totalRedemptions, "", ""]);
    rows.add([
      "Profile Views",
      data.profileViews,
      "${data.profilePercentage}%",
      data.profileViewsIncrease ? "Increase" : "Decrease",
    ]);
    rows.add([
      "Website Views",
      data.websiteViews,
      "${data.websitePercentage}%",
      data.websiteViewsIncrease ? "Increase" : "Decrease",
    ]);

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
    await saveExportedFile(csvData, "business_analytics.csv");
  }

  // 2. Export to PDF
  Future<void> exportToPDF(BusinessAnalyticsModel data) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Text(
                "Business Analytics Report",
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 10),

            // --- General Metrics Table ---
            pw.Text(
              "General Overview",
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 5),
            pw.TableHelper.fromTextArray(
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              headers: ["Metric", "Value", "Percentage", "Trend"],
              data: [
                ["Total Redemptions", data.totalRedemptions, "", ""],
                [
                  "Profile Views",
                  data.profileViews,
                  "${data.profilePercentage}%",
                  data.profileViewsIncrease ? "Increase" : "Decrease",
                ],
                [
                  "Website Views",
                  data.websiteViews,
                  "${data.websitePercentage}%",
                  data.websiteViewsIncrease ? "Increase" : "Decrease",
                ],
              ],
            ),

            pw.SizedBox(height: 25),

            // --- Redemption Methods Table ---
            pw.Text(
              "Redemption Methods",
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 5),
            pw.TableHelper.fromTextArray(
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              headers: ["Method", "Count", "Percentage"],
              data: data.methods
                  .map((m) => [m.method, m.count, "${m.percentage}%"])
                  .toList(),
            ),

            pw.SizedBox(height: 25),

            // --- Top Rewards Table ---
            pw.Text(
              "Top Rewards",
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 5),
            pw.TableHelper.fromTextArray(
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              headers: ["Reward Title", "Percentage"],
              data: data.topRewards
                  .map((r) => [r.title, "${r.percentage}%"])
                  .toList(),
            ),
          ];
        },
      ),
    );

    final bytes = await pdf.save();
    await saveExportedFile(bytes, "business_analytics.pdf", isBytes: true);
  }

  //SAVE FILE USING NATIVE WAYS
  Future<void> saveExportedFile(
    dynamic content,
    String fileName, {
    bool isBytes = false,
  }) async {
    try {
      // 1. Get the temporary directory (Requires 0 permissions on both Android and iOS)
      final tempDir = await getTemporaryDirectory();
      final tempFile = File("${tempDir.path}/$fileName");

      // 2. Write the generated content to the temporary file
      if (isBytes) {
        await tempFile.writeAsBytes(content);
      } else {
        await tempFile.writeAsString(content);
      }

      // 3. Trigger the native "Save As" dialog
      // This allows the user to save the file directly to "Downloads", "Documents", "Drive", etc.
      final params = SaveFileDialogParams(sourceFilePath: tempFile.path);
      final finalPath = await FlutterFileDialog.saveFile(params: params);

      if (finalPath != null) {
        debugPrint("File successfully saved to: $finalPath");
        // showSnackBar(
        //   title: 'Success',
        //   message: 'File saved successfully.',
        //   backgroundColor: AppColors.successGreen,
        // );
        _showNotification(finalPath);
      } else {
        debugPrint("User cancelled the save dialog");
      }

      // 4. Clean up the temporary file from cache
      if (await tempFile.exists()) {
        await tempFile.delete();
      }
    } catch (e) {
      debugPrint('Error exporting file: $e');
      showSnackBar(
        title: 'Error',
        message: 'Failed to export file: $e',
        backgroundColor: AppColors.errorRed,
      );
    }
  }

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Initialize settings for Android and iOS
  Future<void> _initNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    //iOS Specific: Configure Darwin initialization settings
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
          requestAlertPermission: false,
          // Set to false to request permissions on-demand later
          requestBadgePermission: false,
          requestSoundPermission: false,
        );

    final InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsDarwin, //Link iOS settings
        );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) async {
        if (details.payload != null && details.payload!.isNotEmpty) {
          // Trigger the file opening logic when user taps the notification
          await _openDownloadedFile(details.payload!);
        }
      },
    );

    // Request permissions programmatically (Handles both iOS and Android 13+)
    await _requestPermissions();
  }

  // ✅ Helper to request permissions gracefully on both platforms
  Future<void> _requestPermissions() async {
    if (Platform.isIOS) {
      await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    } else if (Platform.isAndroid) {
      // Required for Android 13 (API level 33) and higher
      await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
    }
  }

  Future<void> _openDownloadedFile(String filePath) async {
    final result = await OpenFilex.open(filePath);

    if (result.type != ResultType.done) {
      showSnackBar(
        title: "Cannot open file",
        message: "Try opening from your device file manager.",
        backgroundColor: AppColors.warningYellow,
      );
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

    //iOS Specific: Configure iOS native notification presentation options
    const DarwinNotificationDetails darwinPlatformChannelSpecifics =
        DarwinNotificationDetails(
          presentAlert: true, // Display the banner on screen
          presentBadge: true, // Update the application badge
          presentSound: true, // Play default sound
        );

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: darwinPlatformChannelSpecifics, //Link iOS platform details
    );

    // Get only the filename for the title
    String fileName = path.split('/').last;

    await _notificationsPlugin.show(
      0, // Notification ID
      'File Saved Successfully',
      fileName, // The body shows the filename
      platformChannelSpecifics,
      payload: path, // Path passed so tapping opens the file on both platforms
    );
  }
}
