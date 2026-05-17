import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:trajectoria/common/helper/date/date_convert.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('id_ID', null);
  });

  test('formats short and full date', () {
    final date = DateTime(2026, 1, 1);
    expect(date.toShortDate(), '1 Jan 2026');
    expect(date.toFullDate(), '1 Januari 2026');
  });

  test('formats time ago with hours and minutes', () {
    final now = DateTime.now();
    final twoHoursFiveMinutesAgo = now.subtract(
      const Duration(hours: 2, minutes: 5),
    );

    final result = twoHoursFiveMinutesAgo.toTimeAgo();
    expect(result, '2 jam 5 menit yang lalu');
  });
}
