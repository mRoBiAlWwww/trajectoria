import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:trajectoria/features/jobseeker/compete/presentation/cubit/hydrated_history_cubit.dart';
import 'package:trajectoria/features/jobseeker/compete/presentation/cubit/hydrated_history_state.dart';

import '../../helpers/test_helpers.dart';

void main() {
  setUpAll(() async {
    final dir = await Directory.systemTemp.createTemp();
    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: dir,
    );
  });

  test('adds competition and prevents duplicates', () {
    final cubit = HydratedHistoryCubit();
    final comp = buildCompetitionEntity(id: 'c1');

    cubit.addCompetition(comp);
    cubit.addCompetition(comp);

    final state = cubit.state as HydratedHistoryStored;
    expect(state.competitions.length, 1);
  });

  test('serializes and restores history', () {
    final cubit = HydratedHistoryCubit();
    final comp = buildCompetitionEntity(id: 'c1');
    cubit.addCompetition(comp);

    final json = cubit.toJson(cubit.state);
    final restored = cubit.fromJson(json!);

    expect(restored, isA<HydratedHistoryStored>());
    final stored = restored as HydratedHistoryStored;
    expect(stored.competitions.first.competitionId, 'c1');
  });
}
