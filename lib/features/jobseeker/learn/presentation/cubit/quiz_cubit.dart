import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:trajectoria/features/jobseeker/learn/domain/entities/module.dart';
import 'package:trajectoria/features/jobseeker/learn/domain/usecases/add_finished_subchapter.dart';
import 'package:trajectoria/features/jobseeker/learn/domain/usecases/add_user_score.dart';
import 'package:trajectoria/features/jobseeker/learn/domain/usecases/add_finished_module.dart';
import 'package:trajectoria/features/jobseeker/learn/domain/usecases/get_quiz.dart';
import 'package:trajectoria/features/jobseeker/learn/presentation/cubit/quiz_state.dart';
import 'package:trajectoria/service_locator.dart';

class QuizCubit extends Cubit<QuizState> {
  QuizCubit() : super(QuizInitial());

  Future<void> getQuizzes(
    String courseId,
    int chapterOrder,
    String subChapterId,
    String moduleId,
  ) async {
    emit(QuizLoading());

    var returnedData = await sl<GetQuizUseCase>().call(
      courseId,
      chapterOrder,
      subChapterId,
      moduleId,
    );

    returnedData.fold(
      (error) {
        emit(QuizFailure());
      },
      (data) {
        debugPrint(data.toString());
        emit(QuizzesLoaded(data));
      },
    );
  }

  Future<void> submitQuizAction(ModuleEntity module, double score) async {
    emit(QuizLoading());

    var changeStatusResult = await sl<AddFinishedModuleStatusUseCase>().call(
      module.moduleId,
    );

    changeStatusResult.fold((error) {
      emit(QuizFailure());
      return null;
    }, (data) => data);

    if (module.orderIndex == 3) {
      var changeStatusResult = await sl<AddFinishedSubchapterStatusUseCase>()
          .call(module.subchapterId);

      changeStatusResult.fold((error) {
        emit(QuizFailure());
        return null;
      }, (data) => data);
    }

    var addScoreResult = await sl<AddUserScoreUseCase>().call(score);

    final scoreData = addScoreResult.fold((error) {
      emit(QuizFailure());
      return null;
    }, (data) => data);

    emit(SuccessfulProcess(scoreData));
  }
}
