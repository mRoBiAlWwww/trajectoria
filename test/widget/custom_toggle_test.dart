import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trajectoria/common/widgets/toogle/custom_toggle.dart';

void main() {
  testWidgets('CustomToggle calls onChanged with toggled value',
      (tester) async {
    bool? received;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomToggle(
            value: false,
            onChanged: (value) => received = value,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(CustomToggle));
    await tester.pump();

    expect(received, isTrue);
  });
}
