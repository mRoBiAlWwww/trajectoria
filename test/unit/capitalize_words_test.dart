import 'package:flutter_test/flutter_test.dart';
import 'package:trajectoria/common/helper/parser/capitalize.dart';

void main() {
  group('capitalizeWords', () {
    test('capitalizes each word', () {
      expect(capitalizeWords('hello world'), 'Hello World');
    });

    test('preserves multiple spaces', () {
      expect(capitalizeWords('hello  WORLD'), 'Hello  World');
    });

    test('returns empty string for empty input', () {
      expect(capitalizeWords(''), '');
    });
  });
}
