import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart'; // Mantener para TestWidgetsFlutterBinding
import 'package:mockito/mockito.dart'; // Usar mockito para la clase Mock
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// Un mock simple para FirebaseAppPlatform
class MockFirebaseApp extends Mock implements FirebaseAppPlatform {
  @override
  String get name => 'testApp';

  @override
  FirebaseOptions get options => const FirebaseOptions(
        apiKey: 'test_api_key',
        appId: 'test_app_id',
        messagingSenderId: 'test_messaging_sender_id',
        projectId: 'test_project_id',
      );

  // Implementaciones mínimas para los métodos abstractos de FirebaseAppPlatform
  @override
  Future<void> delete() => Future.value();
  @override
  bool get isAutomaticDataCollectionEnabled => false;
  @override
  Future<void> setAutomaticDataCollectionEnabled(bool enabled) => Future.value();
  @override
  Future<void> setAutomaticResourceManagementEnabled(bool enabled) => Future.value();
}

// Implementación mock de FirebasePlatform
class MockFirebasePlatform extends Mock
    with MockPlatformInterfaceMixin
    implements FirebasePlatform {
  MockFirebasePlatform() {
    // Asegura que Flutter esté inicializado para las pruebas de widgets
    TestWidgetsFlutterBinding.ensureInitialized();
    // Registra esta instancia como la implementación de la plataforma
    FirebasePlatform.instance = this;
  }

  @override
  Future<FirebaseAppPlatform> initializeApp({
    String? name,
    FirebaseOptions? options,
  }) async {
    // Devuelve una instancia de nuestro MockFirebaseApp
    return MockFirebaseApp();
  }

  @override
  List<FirebaseAppPlatform> get apps => [MockFirebaseApp()];

  @override
  FirebaseAppPlatform app([String name = '[DEFAULT]']) {
    return MockFirebaseApp();
  }
}

/// Función de utilidad para configurar los mocks de Firebase
/// Debe llamarse en el `setUp` de tus pruebas de widgets.
void setupFirebaseAuthMocks() {
  // Inicializa el binding de Flutter para las pruebas de widgets
  TestWidgetsFlutterBinding.ensureInitialized();
  // Configura el mock de FirebasePlatform
  MockFirebasePlatform();
}