/*
MD5: B5:B9:80:B4:1A:83:F5:6C:94:13:60:72:76:F9:0F:1D
SHA1: 90:AC:1F:6F:68:5A:03:C3:86:5D:4B:51:A5:5A:F8:8A:31:60:D5:F2
SHA-256: 0A:FB:28:D8:9B:41:FF:AF:BE:98:4D:D0:9B:2C:73:BF:84:77:98:01:7A:D9:25:D7:D6:96:FB:E7:80:2C:86:EE
*/

import 'dart:async';
import 'dart:typed_data';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';

class PushNotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;
  static StreamController<String> _messageStreamController =
      StreamController.broadcast();

  static Stream<String> get messageStream => _messageStreamController.stream;

  static Future _onBackgroundHandler(RemoteMessage message) async {
    print("onBackgroundHandler ${message.data}");
    messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    playNotificationSound();
    _messageStreamController.add(message.data["product"] ?? "No title");
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    print("onMessageHandler ${message.data}");

    messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    playNotificationSound();
    _messageStreamController.add(message.data["product"] ?? "No title");
  }

  static Future _onMessageOpenAppHandler(RemoteMessage message) async {
    print("onMessageOpenAppHandler ${message.data}");
    messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    playNotificationSound();
    _messageStreamController.add(message.data["product"] ?? "No title");
  }

  static Future inicializeApp() async {
    //Push Notification
    await Firebase.initializeApp();
    token = await FirebaseMessaging.instance.getToken();

    FirebaseMessaging.onBackgroundMessage(_onBackgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenAppHandler);

    print("Toke device: $token");
    //Local Notification
  }

  static void playNotificationSound() async {
    //final player = AudioCache();
    //player.play('sounds/notificacion.mp3');
    Soundpool pool = Soundpool(streamType: StreamType.notification);
    int soundId = await rootBundle.load("assets/yape.mp3").then(
      (ByteData soundData) {
        return pool.load(soundData);
      },
    );
    await pool.play(soundId);
  }

  static close() {
    _messageStreamController.close();
  }
}
