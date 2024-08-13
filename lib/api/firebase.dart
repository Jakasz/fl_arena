import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseSetup {
  late final FirebaseApp firebaseApp;
  initApp() {
    firebaseApp = Firebase.app();
  }

  FirebaseDatabase initFirebase() {
    initApp();

    final rtdb = FirebaseDatabase.instanceFor(
        app: firebaseApp,
        databaseURL:
            'https://pyarena-91d35-default-rtdb.europe-west1.firebasedatabase.app/');

    return rtdb;
  }
}
