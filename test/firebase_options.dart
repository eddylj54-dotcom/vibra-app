import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    // Provide mock options for testing
    return const FirebaseOptions(
      apiKey: 'mock-api-key',
      appId: 'mock-app-id',
      messagingSenderId: 'mock-sender-id',
      projectId: 'mock-project-id',
    );
  }
}
