import 'package:flutter_test/flutter_test.dart';
import 'package:trajectoria/core/bloc/bottom_navigation_cubit.dart';
import 'package:trajectoria/features/authentication/presentation/cubit/google_cubit.dart';
import 'package:trajectoria/features/authentication/presentation/cubit/user_role_cubit.dart';

void main() {
  group('RoleCubit', () {
    test('starts empty and updates role', () {
      final cubit = RoleCubit();
      expect(cubit.state, '');

      cubit.setRole('Jobseeker');
      expect(cubit.state, 'Jobseeker');

      cubit.clearRole();
      expect(cubit.state, '');
    });
  });

  group('LoginFlowCubit', () {
    test('starts false and can toggle', () {
      final cubit = LoginFlowCubit();
      expect(cubit.state, isFalse);

      cubit.setGooglePopupFlow(true);
      expect(cubit.state, isTrue);
    });
  });

  group('BottomNavCubit', () {
    test('starts at index 0 and updates', () {
      final cubit = BottomNavCubit();
      expect(cubit.state, 0);

      cubit.changeSelectedIndexJobseeker(2);
      expect(cubit.state, 2);
    });

    test('company index guard works', () {
      final cubit = BottomNavCubit();

      cubit.changeSelectedIndexCompany(2);
      expect(cubit.state, 0);

      cubit.changeSelectedIndexCompany(1);
      expect(cubit.state, 1);
    });
  });
}
