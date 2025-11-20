// import 'package:bloc/bloc.dart';
// import 'package:trajectoria/features/authentication/domain/entities/user.dart';
// import 'package:trajectoria/features/authentication/domain/usecases/get_user.dart';
// import 'package:trajectoria/service_locator.dart';
// part 'splash_state.dart';

// class SplashCubit extends Cubit<SplashState> {
//   SplashCubit() : super(DisplaySplash());

//   void appStarted() async {
//     await Future.delayed(const Duration(seconds: 2));
//     var user = await sl<GetCurrentUserUseCase>().call();
//     final data = user.getOrElse(() => null);
//     // var data = null;
//     if (data != null) {
//       emit(Authenticated(data));
//     } else {
//       emit(UnAuthenticated());
//     }
//   }
// }

// // class SplashCubit extends Cubit<SplashState> {
// //   SplashCubit() : super(DisplaySplash());
// //   void appStarted() async {
// //     await Future.delayed(const Duration(seconds: 2));
// //     var Jobseeker = await sl<GetJobseekerUseCase>().call();
// //     final dataJobseeker = Jobseeker.getOrElse(() => null);
// //     if (dataJobseeker != null) {
// //       emit(Authenticated(dataJobseeker));
// //       return;
// //     }
// //     var Company = await sl<GetCompanyUseCase>().call();
// //     final dataCompany = Company.getOrElse(() => null);
// //     if (dataCompany != null) {
// //       emit(Authenticated(dataCompany));
// //       return;
// //     } else {
// //       emit(UnAuthenticated());
// //     }
// //   }
// // }
