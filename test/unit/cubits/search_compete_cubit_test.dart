import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trajectoria/core/dependency_injection/service_locator.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/usecases/get_competitions.dart';
import 'package:trajectoria/features/jobseeker/compete/presentation/cubit/search_compete_cubit.dart';
import 'package:trajectoria/features/jobseeker/compete/presentation/cubit/search_compete_state.dart';

import '../../helpers/test_helpers.dart';

class MockGetCompetitionsUseCase extends Mock
    implements GetCompetitionsUseCase {}

void main() {
  late MockGetCompetitionsUseCase mockGetCompetitionsUseCase;

  setUp(() async {
    mockGetCompetitionsUseCase = MockGetCompetitionsUseCase();
    await sl.reset();
    sl.registerSingleton<GetCompetitionsUseCase>(mockGetCompetitionsUseCase);
  });

  blocTest<SearchCompeteCubit, SearchCompeteState>(
    'emits loaded when getCompetitions succeeds',
    build: () {
      when(() => mockGetCompetitionsUseCase.call()).thenAnswer(
        (_) async => Right([buildCompetitionEntity()]),
      );
      return SearchCompeteCubit();
    },
    act: (cubit) => cubit.getCompetitions(),
    expect: () => [
      isA<SearchCompeteLoading>(),
      isA<SearchCompeteLoaded>(),
    ],
  );

  blocTest<SearchCompeteCubit, SearchCompeteState>(
    'emits error when getCompetitions fails',
    build: () {
      when(() => mockGetCompetitionsUseCase.call())
          .thenAnswer((_) async => const Left('error'));
      return SearchCompeteCubit();
    },
    act: (cubit) => cubit.getCompetitions(),
    expect: () => [
      isA<SearchCompeteLoading>(),
      isA<SearchCompeteError>(),
    ],
  );
}
