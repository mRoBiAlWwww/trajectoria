import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trajectoria/core/dependency_injection/service_locator.dart';
import 'package:trajectoria/features/jobseeker/profile/domain/usecases/get_bookmarks.dart';
import 'package:trajectoria/features/jobseeker/profile/presentation/cubit/profile_cubit.dart';

import '../../helpers/test_helpers.dart';

class MockGetBookmarksUseCase extends Mock implements GetBookmarksUseCase {}

void main() {
  late MockGetBookmarksUseCase mockGetBookmarksUseCase;

  setUp(() async {
    mockGetBookmarksUseCase = MockGetBookmarksUseCase();
    await sl.reset();
    sl.registerSingleton<GetBookmarksUseCase>(mockGetBookmarksUseCase);
  });

  blocTest<ProfileCubit, ProfileState>(
    'emits bookmarks when getBookmarks succeeds',
    build: () {
      when(() => mockGetBookmarksUseCase.call()).thenAnswer(
        (_) async => Right([buildCompetitionEntity()]),
      );
      return ProfileCubit();
    },
    act: (cubit) => cubit.getBookmarks(),
    expect: () => [
      isA<ProfileLoading>(),
      isA<BookmarksLoaded>(),
    ],
  );

  blocTest<ProfileCubit, ProfileState>(
    'emits failure when getBookmarks fails',
    build: () {
      when(() => mockGetBookmarksUseCase.call())
          .thenAnswer((_) async => const Left('error'));
      return ProfileCubit();
    },
    act: (cubit) => cubit.getBookmarks(),
    expect: () => [
      isA<ProfileLoading>(),
      isA<ProfileFailure>(),
    ],
  );
}
