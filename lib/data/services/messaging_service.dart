import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class MessagingService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  static const String deviceDocId = 'valentina_device';

  Future<void> initialize() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    final token = await _messaging.getToken();
    if (token != null) {
      await _guardarToken(token);
    }

    _messaging.onTokenRefresh.listen(_guardarToken);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('Notificación recibida en primer plano: ${message.notification?.title}');
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('App abierta desde notificación: ${message.notification?.title}');
      }
    });
  }

  Future<void> _guardarToken(String token) async {
    await _db.collection('devices').doc(deviceDocId).set({
      'fcmToken': token,
      'actualizado': FieldValue.serverTimestamp(),
    });
    if (kDebugMode) {
      print('Token guardado en Firestore: $token');
    }
  }
}