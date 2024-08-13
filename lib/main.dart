import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_arena/pages/home_page.dart';
import 'package:fl_arena/provider/fb_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyBWYhW1v5ihah_48rKZvQoXLTumzCxvhq8",
            appId: "1:827209140628:web:4db30ac6d56775b8832781",
            databaseURL:
                "https://pyarena-91d35-default-rtdb.europe-west1.firebasedatabase.app",
            messagingSenderId: "827209140628",
            projectId: 'pyarena-91d35'));
  } on Exception catch (e) {
    print(e.toString());
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL:
            'https://pyarena-91d35-default-rtdb.europe-west1.firebasedatabase.app/');
    return ChangeNotifierProvider(
      create: (context) => FbProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: const Color.fromRGBO(1, 11, 19, 0.9),
        ),
        home: HomePage(),
      ),
    );
  }
}
