import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart'; // Importar mockito para MockUser

// Importa los mocks que acabamos de crear
import 'mocks.dart'; // Importación relativa

// --- Widgets de ejemplo para la prueba ---
// En tu app real, estos estarían en sus propios archivos.

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    // AuthGate normalmente escucharía los cambios de estado de autenticación
    // Aquí usamos Provider para simular el stream de FirebaseAuth.instance.authStateChanges()
    final user = context.watch<User?>();
    if (user != null) {
      return const HomePage();
    } else {
      return const LoginPage();
    }
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Login Page')));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Home Page')));
}

// --- Prueba de Widget ---

void main() {
  group('AuthGate', () {
    // StreamController para simular el stream de authStateChanges()
    late Stream<User?> authStream;

    setUp(() {
      // 1. Configura los mocks de Firebase ANTES de cada prueba.
      setupFirebaseAuthMocks();

      // 2. Mockea el stream de FirebaseAuth. Por defecto, simula que no hay usuario.
      // Puedes cambiar esto en cada `testWidgets` para simular un login.
      authStream = Stream.value(null);
    });

    testWidgets('Muestra LoginPage cuando el usuario no está autenticado', (tester) async {
      // Construye la app con el AuthGate
      await tester.pumpWidget(
        StreamProvider<User?>.value(
          value: authStream, // Provee el stream mockeado
          initialData: null,
          child: const MaterialApp(
            home: AuthGate(),
          ),
        ),
      );

      // Espera a que los widgets se estabilicen
      await tester.pumpAndSettle();

      // VERIFICACIÓN
      // Esperamos encontrar el widget de la página de login.
      expect(find.byType(LoginPage), findsOneWidget);

      // Y nos aseguramos de que la página de inicio no se muestre.
      expect(find.byType(HomePage), findsNothing);
    });

    // Ejemplo de cómo probar cuando un usuario está autenticado
    testWidgets('Muestra HomePage cuando el usuario está autenticado', (tester) async {
      // Mock de un usuario autenticado
      final mockUser = MockUser(); // Necesitarás un mock de User si no lo tienes
      authStream = Stream.value(mockUser);

      await tester.pumpWidget(
        StreamProvider<User?>.value(
          value: authStream,
          initialData: null,
          child: const MaterialApp(
            home: AuthGate(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(HomePage), findsOneWidget);
      expect(find.byType(LoginPage), findsNothing);
    });
  });
}

// Necesitarás una clase MockUser si no la tienes ya
class MockUser extends Mock implements User {
  @override
  String get uid => 'some_uid';
  @override
  String? get email => 'test@example.com';
  // Añadir implementaciones mínimas para los métodos abstractos de User
  @override
  Future<void> delete() => Future.value();
  @override
  Future<String> getIdToken([bool forceRefresh = false]) => Future.value('test_token');
  @override
  Future<IdTokenResult> getIdTokenResult([bool forceRefresh = false]) => Future.value(MockIdTokenResult());
  @override
  Future<UserCredential> linkWithCredential(AuthCredential credential) => Future.value(MockUserCredential());
  @override
  Future<UserCredential> reauthenticateWithCredential(AuthCredential credential) => Future.value(MockUserCredential());
  @override
  Future<void> reload() => Future.value();
  @override
  Future<void> sendEmailVerification([ActionCodeSettings? actionCodeSettings]) => Future.value();
  @override
  Future<void> updateEmail(String newEmail) => Future.value();
  @override
  Future<void> updatePassword(String newPassword) => Future.value();
  @override
  Future<void> updatePhoneNumber(PhoneAuthCredential credential) => Future.value();
  @override
  Future<void> updatePhotoURL(String? photoURL) => Future.value();
  @override
  Future<void> updateDisplayName(String? displayName) => Future.value();
  @override
  Future<User> unlink(String providerId) => Future.value(MockUser()); // Corregido
  @override
  Future<UserCredential> verifyBeforeUpdateEmail(String newEmail, [ActionCodeSettings? actionCodeSettings]) => Future.value(MockUserCredential());
  @override
  List<UserInfo> get providerData => [];
  @override
  String? get phoneNumber => null;
  @override
  String? get photoURL => null;
  @override
  String? get displayName => null;
  @override
  bool get emailVerified => false;
  @override
  bool get isAnonymous => false;
  // @override // <-- Eliminamos el @override para providerId
  // String get providerId => 'firebase'; // <-- Eliminamos la sobreescritura
  @override
  UserMetadata get metadata => MockUserMetadata(); // Corregido
}

class MockIdTokenResult extends Mock implements IdTokenResult {
  @override
  String? get token => 'test_id_token';
}

class MockUserCredential extends Mock implements UserCredential {
  @override
  User? get user => MockUser();
}

class MockUserMetadata extends Mock implements UserMetadata {}
