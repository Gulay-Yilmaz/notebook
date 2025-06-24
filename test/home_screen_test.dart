import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notebook/screens/home_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('HomeScreen displays correctly with default values', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(
          themeChange: () {},
          isDark: false,
        ),
      ),
    );

    // AppBar Title
    expect(find.text('Not Defteri'), findsOneWidget);

    // Search input
    expect(find.byType(TextField), findsNWidgets(2)); // one for search, one for new note

    // "Yeni Not" TextField label
    expect(find.widgetWithText(TextField, 'Yeni Not'), findsOneWidget);

    // "Ara..." TextField label
    expect(find.widgetWithText(TextField, 'Ara...'), findsOneWidget);

    // "Eşleşen not bulunamadı." if no notes
    await tester.pump(); // re-render
    expect(find.text('Eşleşen not bulunamadı.'), findsOneWidget);
  });

  testWidgets('Add note button triggers note addition logic', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(
          themeChange: () {},
          isDark: false,
        ),
      ),
    );

    final newNoteField = find.widgetWithText(TextField, 'Yeni Not');
    final addButton = find.byIcon(Icons.add);

    await tester.enterText(newNoteField, 'Test notu');
    await tester.tap(addButton);
    await tester.pumpAndSettle();

  });

  testWidgets('Theme toggle button is present and tappable', (WidgetTester tester) async {
    bool toggled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(
          themeChange: () {
            toggled = true;
          },
          isDark: false,
        ),
      ),
    );

    final themeToggleButton = find.byIcon(Icons.dark_mode);
    expect(themeToggleButton, findsOneWidget);

    await tester.tap(themeToggleButton);
    expect(toggled, isTrue);
  });
}
