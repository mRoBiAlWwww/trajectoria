import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trajectoria/common/widgets/button/basic_app_buton.dart';
import 'package:trajectoria/common/widgets/button/rounded_or_not_button.dart';

void main() {
  testWidgets('BasicAppButton triggers onPressed', (tester) async {
    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BasicAppButton(
            backgroundColor: Colors.black,
            content: const Text('Go'),
            onPressed: () => tapped = true,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(tapped, isTrue);
  });

  testWidgets('RoundedOrNotButton triggers onPressed', (tester) async {
    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RoundedOrNotButton(
            text: 'Go',
            onPressed: () => tapped = true,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(tapped, isTrue);
    expect(find.text('Go'), findsOneWidget);
  });
}
