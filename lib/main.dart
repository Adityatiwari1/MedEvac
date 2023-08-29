import 'package:project/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'database/mongo_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MongoService.connect();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final MongoService mongoService = MongoService();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider<MongoService>.value(
      value: mongoService,
      child: const MaterialApp(
        // Your app configuration
        home: Loginscreen(
        ),
      ),
    );
  }
}
