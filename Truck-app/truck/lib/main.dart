import 'package:flutter/material.dart';
import 'package:truck_app/db/hive_client.dart';
import 'package:truck_app/screens/login_screen.dart';
import 'package:truck_app/screens/truck_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveClient().init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final bool isUserLoggedIn = HiveClient().currentUserBox.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Truck App',
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      //   useMaterial3: true,
      // ),
      home: isUserLoggedIn ? const TruckScreen() : const LoginScreen(),
    );
  }
}
