import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trajectoria/common/widgets/searchbar/searchbar.dart';

import '../helpers/test_helpers.dart';

void main() {
  testWidgets('SearchBarWidget updates controller', (tester) async {
    final controller = TextEditingController();

    await tester.pumpWidget(
      DefaultAssetBundle(
        bundle: FakeAssetBundle(),
        child: MaterialApp(
          home: Scaffold(
            body: SearchBarWidget(
              controller: controller,
              hint: 'Cari',
            ),
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'hello');
    await tester.pump();

    expect(controller.text, 'hello');
  });
}
