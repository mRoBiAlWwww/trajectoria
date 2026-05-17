import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trajectoria/core/dependency_injection/service_locator.dart';
import 'package:trajectoria/features/authentication/domain/usecases/get_current_user.dart';
import 'package:trajectoria/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:trajectoria/features/authentication/presentation/cubit/auth_state.dart';

import '../../helpers/test_helpers.dart';

class MockGetCurrentUserUseCase extends Mock
    implements GetCurrentUserUseCase {}

void main() {
  late MockGetCurrentUserUseCase mockGetCurrentUserUseCase;

  setUp(() async {
    mockGetCurrentUserUseCase = MockGetCurrentUserUseCase();
    await sl.reset();
    sl.registerSingleton<GetCurrentUserUseCase>(mockGetCurrentUserUseCase);
  });

  blocTest<AuthStateCubit, AuthState>(
    'emits UnAuthenticated when no user',
    build: () {
      when(() => mockGetCurrentUserUseCase.call())
          .thenAnswer((_) async => const Left('Unauthenticated'));
      return AuthStateCubit();
    },
    act: (cubit) => cubit.appStarted(),
    wait: const Duration(milliseconds: 2100),
    expect: () => [isA<UnAuthenticated>()],
  );

  blocTest<AuthStateCubit, AuthState>(
    'emits AuthFailure on error',
    build: () {
      when(() => mockGetCurrentUserUseCase.call())
          .thenAnswer((_) async => const Left('Oops'));
      return AuthStateCubit();
    },
    act: (cubit) => cubit.appStarted(),
    wait: const Duration(milliseconds: 2100),
    expect: () => [isA<AuthFailure>()],
  );

  blocTest<AuthStateCubit, AuthState>(
    'emits AuthSuccess on success',
    build: () {
      when(() => mockGetCurrentUserUseCase.call())
          .thenAnswer((_) async => Right(buildCompanyEntity()));
      return AuthStateCubit();
    },
    act: (cubit) => cubit.appStarted(),
    wait: const Duration(milliseconds: 2100),
    expect: () => [isA<AuthSuccess>()],
  );
}
