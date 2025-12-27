import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart';
import 'package:trajectoria/core/bloc/bottom_navigation_cubit.dart';
import 'package:trajectoria/core/config/theme/app_theme.dart';
import 'package:trajectoria/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:trajectoria/features/authentication/presentation/cubit/google_cubit.dart';
import 'package:trajectoria/features/authentication/presentation/cubit/user_role_cubit.dart';
import 'package:trajectoria/features/company/dashboard/presentation/cubit/jobseeker_submission_cubit.dart';
import 'package:trajectoria/features/company/dashboard/presentation/cubit/organize_competitions_cubit.dart';
import 'package:trajectoria/features/jobseeker/compete/presentation/cubit/hydrated_history_cubit.dart';
import 'package:trajectoria/features/jobseeker/compete/presentation/cubit/search_compete_cubit.dart';
import 'package:trajectoria/features/jobseeker/learn/presentation/cubit/chapter_cubit.dart';
import 'package:trajectoria/features/jobseeker/learn/presentation/cubit/finished_chapter_module_cubit.dart';
import 'package:trajectoria/features/jobseeker/learn/presentation/cubit/hydrated_course_cubit.dart';
import 'package:trajectoria/features/jobseeker/profile/presentation/cubit/profile_cubit.dart';
import 'package:trajectoria/features/splash/presentation/pages/splash.dart';
import 'package:trajectoria/core/services/notification_service.dart';
import 'package:trajectoria/core/dependency_injection/service_locator.dart';
import 'firebase_options.dart';

final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  NotificationService.instance.initialize();
  await initializeDependencies();
  await initializeDateFormatting('id', null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthStateCubit>(create: (context) => AuthStateCubit()),
        BlocProvider<RoleCubit>(create: (context) => RoleCubit()),
        BlocProvider<HydratedHistoryCubit>(
          create: (context) => HydratedHistoryCubit(),
        ),
        BlocProvider<HydratedSelectedCourseCubit>(
          create: (context) => HydratedSelectedCourseCubit(),
        ),
        // BlocProvider<HydratedAnnouncement>(
        //   create: (context) => HydratedAnnouncement(),
        //   lazy: false,
        // ),
        BlocProvider<LoginFlowCubit>(create: (context) => LoginFlowCubit()),
        BlocProvider(create: (context) => OrganizeCompetitionCubit()),
        BlocProvider(create: (context) => JobseekerSubmissionCubit()),
        BlocProvider(create: (context) => FinishedChapterAndModuleCubit()),
        BlocProvider(create: (context) => ChapterCubit()),
        BlocProvider(create: (context) => BottomNavCubit()),
        BlocProvider(create: (context) => SearchCompeteCubit()),
        BlocProvider(create: (context) => ProfileCubit()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Trejectoria',
        theme: AppTheme.appTheme,
        debugShowCheckedModeBanner: false,
        home: const SplashPage(),
        navigatorObservers: [routeObserver],
      ),
    );
  }
}
