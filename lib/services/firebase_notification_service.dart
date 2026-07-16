import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class FirebaseNotificationService {
  FirebaseNotificationService._();
  static final FirebaseNotificationService instance =
  FirebaseNotificationService._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

  /// Initialize Firebase Messaging and Local Notifications
  Future<void> initialize() async {
    try {
      await _requestPermission();
      await _configureForegroundPresentation(); // Prevent native double popups
      await _initializeLocalNotifications();
      await _createNotificationChannel();

      _setupMessageHandlers();

      debugPrint('Firebase Notification Service initialized successfully');
    } catch (e) {
      debugPrint('Error initializing Firebase Notification Service: $e');
    }
  }

  /// Request notification permissions
  Future<void> _requestPermission() async {
    if (Platform.isIOS) {
      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      debugPrint('Notification permission status: ${settings.authorizationStatus}');
    } else if (Platform.isAndroid &&
        (await _firebaseMessaging.getNotificationSettings()).authorizationStatus !=
            AuthorizationStatus.authorized) {
      // Android 13+
      await _firebaseMessaging.requestPermission();
    }
  }

  /// Force Firebase to turn off native UI banners in foreground so local notifications take control cleanly
  Future<void> _configureForegroundPresentation() async {
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: false, // Turn off native alert UI popup when app is open
      badge: true,
      sound: true,
    );
  }

  /// Initialize local notifications
  Future<void> _initializeLocalNotifications() async {
    // Standard monochrome status icon to prevent solid white squares on Android
    const androidSettings = AndroidInitializationSettings('ic_stat_notification');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  /// Create notification channel (Android 8+)
  Future<void> _createNotificationChannel() async {
    if (Platform.isAndroid) {
      const androidChannel = AndroidNotificationChannel(
        'default_channel',
        'Default Notifications',
        description: 'General notifications for Crescent Change',
        importance: Importance.high,
      );
      await _localNotifications
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(androidChannel);
    }
  }

  /// Setup foreground/background message handlers
  void _setupMessageHandlers() {
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);
    _handleInitialMessage();
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  /// Foreground messages
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    debugPrint('Foreground message received: ${message.messageId}');
    if (message.notification != null) {
      await _showLocalNotification(message);
    }
  }

  /// Show local notification
  Future<void> _showLocalNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Default Notifications',
      channelDescription: 'General notifications for Crescent Change',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      icon: 'ic_stat_notification', // Fixed drawable resource pointer
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _localNotifications.show(
      message.hashCode,
      message.notification?.title ?? 'Crescent Change',
      message.notification?.body ?? '',
      notificationDetails,
      payload: jsonEncode(message.data),
    );
  }

  /// Handle notification tap (background)
  void _handleNotificationTap(RemoteMessage message) {
    debugPrint('Notification tapped: ${message.messageId}');
    _navigateBasedOnPayload(message.data);
  }

  /// Handle app launch from terminated state
  Future<void> _handleInitialMessage() async {
    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      debugPrint('App opened from notification: ${initialMessage.messageId}');
      _navigateBasedOnPayload(initialMessage.data);
    }
  }

  /// Local notification tap
  void _onNotificationTapped(NotificationResponse response) {
    if (response.payload != null) {
      try {
        final data = jsonDecode(response.payload!) as Map<String, dynamic>;
        _navigateBasedOnPayload(data);
      } catch (e) {
        debugPrint('Error parsing notification payload: $e');
      }
    }
  }

  /// Navigate based on payload
  void _navigateBasedOnPayload(Map<String, dynamic> data) {
    final type = data['type'] as String?;
    final route = data['route'] as String?;
    debugPrint('Notification payload - type: $type, route: $route');

    if (route != null && route.isNotEmpty) {
      Get.toNamed(route);
    } else {
      switch (type) {
        case 'donation':
          break;
        case 'reward':
          break;
        case 'profile':
          break;
        default:
          debugPrint('Unknown notification type: $type');
      }
    }
  }

  Future<String?> getToken() async {
    try {
      return await _firebaseMessaging.getToken();
    } catch (e) {
      debugPrint('Error getting FCM token: $e');
      return null;
    }
  }

  void onTokenRefresh(Function(String) callback) {
    _firebaseMessaging.onTokenRefresh.listen(callback);
  }

  Future<void> deleteToken() async {
    await _firebaseMessaging.deleteToken();
  }

  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
  }
}

/// Background handler must be a top-level function
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Background message received: ${message.messageId}');
  // Silent background handler. The OS automatically draws the system banner for data or notifications.
}