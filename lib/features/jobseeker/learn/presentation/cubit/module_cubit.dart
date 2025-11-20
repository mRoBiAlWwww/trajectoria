import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trajectoria/features/jobseeker/learn/data/datasources/learn_service.dart';
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

    var returnedModules = await sl<GetModulesUseCase>().call(
      courseId,
      chapterOrder,
      subChapterId,
    );

    final modulesData = returnedModules.fold((error) {
      emit(ModuleFailure());
      return null;
    }, (data) => data);

    if (modulesData == null) return;

    var returnedUser = await sl<LearnService>().getFinishedModules();

    final userData = returnedUser.fold((error) {
      emit(ModuleFailure());
      return null;
    }, (data) => data);

    if (userData == null) return;

    emit(ModulesAndFinishedModulesLoaded(modulesData, userData));
  }
}
