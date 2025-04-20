
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Hintergrundnachricht: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(EasyLogPushApp());
}

class EasyLogPushApp extends StatefulWidget {
  @override
  State<EasyLogPushApp> createState() => _EasyLogPushAppState();
}

class _EasyLogPushAppState extends State<EasyLogPushApp> {
  late FirebaseMessaging messaging;

  @override
  void initState() {
    super.initState();
    messaging = FirebaseMessaging.instance;

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Nachricht empfangen: ${message.notification?.title}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message.notification?.title ?? 'Neue Nachricht')),
      );
    });

    messaging.getToken().then((token) {
      print("📱 FCM Token: $token");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EasyLog Push',
      home: Scaffold(
        appBar: AppBar(title: Text('Push Notification Demo')),
        body: Center(child: Text('Warte auf Nachricht...')),
      ),
    );
  }
}
