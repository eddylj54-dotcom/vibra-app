import 'package:flutter_test/flutter_test.dart';
import 'package:vibra/features/auth/widgets/auth_gate.dart';
import 'package:vibra/main.dart';

// Import the Firebase mocks
import 'mocks.dart';

void main() {
  // Setup Firebase mocks before any tests run
  setupFirebaseAuthMocks();

  testWidgets('App starts and shows AuthGate', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that AuthGate is being shown.
    expect(find.byType(AuthGate), findsOneWidget);
  });
}
