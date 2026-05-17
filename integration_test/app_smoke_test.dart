import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:trajectoria/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:trajectoria/features/splash/presentation/pages/splash.dart';

class FakeAuthStateCubit extends AuthStateCubit {
  @override
  Future<void> appStarted() async {
    // No-op for integration smoke test.
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('App shows splash screen', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AuthStateCubit>(
          create: (_) => FakeAuthStateCubit(),
          child: const SplashPage(),
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 250));

    expect(find.byType(SplashPage), findsOneWidget);
    expect(find.text('trajectoria'), findsOneWidget);
  });
}
