// Widget tests for the GymMate AI onboarding navigation flow.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gymmate_ai/src/app.dart';

void main() {
  testWidgets('App starts on onboarding and progresses through setup', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: GymMateApp()));
    await tester.pumpAndSettle();

    expect(find.text('GymMate AI'), findsOneWidget);
    expect(find.text('The AI Companion That Grows With You.'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));

    await tester.enterText(find.byType(TextFormField).first, 'Alex');
    await tester.enterText(find.byType(TextFormField).last, 'Taylor');
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text('Birthday'), findsOneWidget);
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).first, '180');
    await tester.enterText(find.byType(TextFormField).last, '75');
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Gain Muscle'));
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).first, 'Titan Fitness');
    await tester.tap(find.text('Finish Setup'));
    await tester.pumpAndSettle();

    expect(find.text('Permissions'), findsOneWidget);
    expect(find.text('Enable the key permissions that power your automatic training journey.'), findsOneWidget);
  });
}
