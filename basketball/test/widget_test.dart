// This is a basic Flutter widget test for CourtKing app.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:basketball/main.dart';
import 'package:basketball/core/app_theme.dart';
import 'package:basketball/screens/screen_01_registration.dart';

void main() {
  testWidgets('Registration screen displays correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        title: 'CourtKing',
        debugShowCheckedModeBanner: false,
        theme: CourtKingTheme.themeData,
        home: const Screen01Registration(),
      ),
    );

    // Wait for the widget to render
    await tester.pumpAndSettle();

    // Verify that the registration screen loads with correct elements.
    expect(find.text('CourtKing'), findsOneWidget);
    expect(find.text('REGISTER TO PLAY'), findsOneWidget);
    expect(find.text('PLAYER TAG'), findsOneWidget);
    expect(find.text('REGION'), findsOneWidget);
    expect(find.text('Create Player & Enter Arena'), findsOneWidget);
    expect(find.text('#KING99'), findsOneWidget);
    expect(find.text('North America'), findsOneWidget);
  });

  testWidgets('Registration form interaction', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        title: 'CourtKing',
        debugShowCheckedModeBanner: false,
        theme: CourtKingTheme.themeData,
        home: const Screen01Registration(),
      ),
    );

    await tester.pumpAndSettle();

    // Verify initial player tag
    expect(find.text('#KING99'), findsOneWidget);

    // Tap the player tag field and enter new text
    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();
    
    await tester.enterText(find.byType(TextField), '#TEST123');
    await tester.pumpAndSettle();

    // Verify the text was entered
    expect(find.text('#TEST123'), findsOneWidget);
  });
}