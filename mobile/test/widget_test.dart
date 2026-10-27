import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqlquest/main.dart';

void main() {
  testWidgets('SQLQuest smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: SQLQuestApp(),
      ),
    );

    // Verify SQLQuest splash screen is pumped
    expect(find.text('SQLQuest'), findsOneWidget);

    // Let splash timer finish and transition to Home screen
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Verify Home screen header and bottom nav "Beranda" are loaded
    expect(find.text('Beranda'), findsNWidgets(2));

    // Verify greeting for Kevin
    expect(find.text('Hai, Kevin Kendra 👋'), findsOneWidget);
  });
}
