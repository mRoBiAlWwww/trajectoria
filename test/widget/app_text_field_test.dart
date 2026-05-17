import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trajectoria/common/widgets/textfield/auth_text_field.dart';

void main() {
  testWidgets('AppTextField toggles password visibility', (tester) async {
    final controller = TextEditingController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppTextField(
            controller: controller,
            hintText: 'Password',
            isFormValid: true,
            isPassword: true,
          ),
        ),
      ),
    );

    TextField textField = tester.widget(find.byType(TextField));
    expect(textField.obscureText, isTrue);

    await tester.tap(find.byIcon(Icons.visibility_off));
    await tester.pump();

    textField = tester.widget(find.byType(TextField));
    expect(textField.obscureText, isFalse);
  });

  testWidgets('AppTextField shows plain text when not a password field',
      (tester) async {
    final controller = TextEditingController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppTextField(
            controller: controller,
            hintText: 'Email',
            isFormValid: true,
          ),
        ),
      ),
    );

    final textField = tester.widget<TextField>(find.byType(TextField));
    expect(textField.obscureText, isFalse);
    expect(find.byIcon(Icons.visibility_off), findsNothing);
    expect(find.byIcon(Icons.visibility), findsNothing);
  });
}
