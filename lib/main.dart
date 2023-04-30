import 'package:flutter/material.dart';
import 'package:notificaciones/pages/Home_page.dart';
import 'package:notificaciones/pages/message_page.dart';
import 'package:notificaciones/services/push_notificacion_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PushNotificationService.inicializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final navigatorKey = GlobalKey<NavigatorState>();
  final messengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();

    PushNotificationService.messageStream.listen((message) {
      print("MyApp: $message");

      //Navegación faild
      //Navigator.pushNamed(context, "message");

      //Navegación ok
      final snackBar = SnackBar(content: Text("$message"));
      messengerKey.currentState?.showSnackBar(snackBar);

      navigatorKey.currentState?.pushNamed("message", arguments: message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: "home",
      //Navegación
      navigatorKey: navigatorKey,
      scaffoldMessengerKey: messengerKey,
      //
      routes: {
        "home": (_) => HomePage(),
        "message": (_) => MessagePage(),
      },
    );
  }
}
