import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trajectoria/features/authentication/domain/entities/jobseeker_entity.dart';
import 'package:trajectoria/features/authentication/domain/usecases/get_current_user.dart';
import 'package:trajectoria/features/jobseeker/learn/domain/usecases/get_modules.dart';
import 'package:trajectoria/features/jobseeker/learn/presentation/cubit/module_state.dart';
import 'package:trajectoria/service_locator.dart';

class ModuleCubit extends Cubit<ModuleState> {
  ModuleCubit() : super(ModuleInitial());

  Future<void> getModulesAndFinishedModules(
    String courseId,
    int chapterOrder,
    String subChapterId,
  ) async {
    emit(ModuleLoading());

    final modulesResult = await sl<GetModulesUseCase>().call(
      courseId,
      chapterOrder,
      subChapterId,
    );

    return modulesResult.fold(
      (error) {
        emit(ModuleFailure());
      },
      (modules) async {
        final userResult = await sl<GetCurrentUserUseCase>().call();
        userResult.fold(
          (error) {
            emit(ModuleFailure());
          },
          (user) {
            final finishedModules = user is JobSeekerEntity
                ? user.finishedModule
                : <String>[];

            emit(ModulesAndFinishedModulesLoaded(modules, finishedModules));
          },
        );
      },
    );
  }
}
