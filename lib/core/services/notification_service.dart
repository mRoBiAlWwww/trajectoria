import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trajectoria/core/dependency_injection/service_locator.dart';
import 'package:trajectoria/features/authentication/domain/usecases/add_token_notification.dart';
import 'package:trajectoria/features/jobseeker/compete/presentation/pages/competition_result.dart';
import 'package:trajectoria/main.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    final data = message.data;
    final announcementId = data['announcement_id']?.toString();

    if (announcementId != null && announcementId.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();

      final List<String> pendingList =
          prefs.getStringList('pending_announcements') ?? [];

      if (!pendingList.contains(announcementId)) {
        pendingList.add(announcementId);
        await prefs.setStringList('pending_announcements', pendingList);
      }
    }
  } catch (e) {
    throw Exception("❌ BACKGROUND ERROR saat simpan Prefs: $e");
  }

  // tampilkan notifikasi
  try {
    await NotificationService.instance.setupFlutterNotifications();
    await NotificationService.instance.showNotification(message);
  } catch (e) {
    throw Exception("❌ BACKGROUND ERROR saat tampil notif: $e");
  }
}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final _messaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();
  bool _isFlutterLocalNotificationsInitialized = false;
  Map<String, dynamic>? _pendingPayload;

  Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await _requestPermission();
    await setupFlutterNotifications();
    await _setupMessageHandlers();

    final token = await _messaging.getToken();
    debugPrint("FCM Token : $token");

    subscribeToTopic('all_devices');

    await saveTokenToDatabase();

    // Listen jika token berubah (refresh)
    _messaging.onTokenRefresh.listen((newToken) async {
      await saveTokenToDatabase();
      debugPrint("Token Refreshed: $newToken");
    });

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _pendingPayload = initialMessage.data;
    }
  }

  Future<void> saveTokenToDatabase() async {
    final token = await _messaging.getToken();
    if (token != null) {
      try {
        sl<AddTokenNotificationUseCase>().call(token);
        debugPrint("FCM Token : $token");
      } catch (e) {
        debugPrint("Gagal simpan token (mungkin belum login): $e");
      }
    }
  }

  void checkPendingNotification() {
    if (_pendingPayload != null) {
      _handleBackgroundMessage(
        _pendingPayload!["type"],
        _pendingPayload!["competition_id"],
        _pendingPayload!["submission_id"],
        _pendingPayload!["announcement_id"],
      );
      _pendingPayload = null;
    }
  }

  Future<void> _requestPermission() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
    );
  }

  Future<void> setupFlutterNotifications() async {
    if (_isFlutterLocalNotificationsInitialized) {
      return;
    }

    // android setup
    const channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    const initializationSettingsAndroid = AndroidInitializationSettings(
      "@mipmap/ic_launcher",
    );

    //final initialization
    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    // flutter notification setup
    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        try {
          final data = jsonDecode(details.payload!);
          _handleBackgroundMessage(
            data["type"],
            data["competition_id"],
            data["submission_id"],
            data["announcement_id"],
          );
        } catch (e) {
          debugPrint("Error decoding notification payload: $e");
        }
      },
    );

    _isFlutterLocalNotificationsInitialized = true;
  }

  Future<void> showNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      String textMessage = message.data['full_body'];

      final BigTextStyleInformation longTextMessage = BigTextStyleInformation(
        textMessage,
        htmlFormatBigText: true,
        contentTitle: notification.title,
        htmlFormatContentTitle: true,
        summaryText: 'Pengumuman',
      );

      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription:
                'This channel is used for important notifications.',
            importance: Importance.high,
            priority: Priority.high,
            icon: "@mipmap/ic_launcher",
            styleInformation: longTextMessage,
          ),
        ),
        payload: jsonEncode(message.data),
      );
    }
  }

  Future<void> _setupMessageHandlers() async {
    // foreground message
    FirebaseMessaging.onMessage.listen((message) {
      showNotification(message);

      //
      // // --- LOGIKA LANGSUNG SIMPAN (FOREGROUND) ---
      // final announcementId = message.data['announcement_id'];
      // if (announcementId != null) {
      //   final context = navigatorKey.currentContext;
      //   if (context != null) {
      //     context.read<HydratedAnnouncement>().addAnnouncementId(
      //       announcementId,
      //     );
      //     debugPrint(
      //       "Foreground: ID $announcementId langsung disimpan ke Bloc.",
      //     );
      //   }
      // }
    });

    // background message
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleBackgroundMessage(
        message.data["type"],
        message.data["competition_id"],
        message.data["submission_id"],
        message.data["announcement_id"],
      );
    });
  }

  void _handleBackgroundMessage(
    String message,
    String competitionId,
    String submissionId,
    String announcementId,
  ) {
    if (message == "report_submission") {
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => CompetitionResultPage(
            submissionId: submissionId,
            competitionId: competitionId,
          ),
        ),
      );
    }
  }

  Future<void> subscribeToTopic(String topic) async {
    await FirebaseMessaging.instance.subscribeToTopic(topic);
    debugPrint("Subscribed to $topic");
  }

  Future<void> hardLogout() async {
    try {
      // 1. Unsubscribe Topic
      await _messaging.unsubscribeFromTopic('all_devices');
      debugPrint("Unsubscribe topic command sent.");

      // 2. Hapus Token
      await _messaging.deleteToken();
      debugPrint("FCM Token deleted locally.");

      // 3. Reset variable internal
      _isFlutterLocalNotificationsInitialized = false;
      _pendingPayload = null;
    } catch (e) {
      debugPrint("Error saat hard logout notification: $e");
    }
  }
}
