import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trajectoria/features/company/dashboard/domain/usecases/add_finalis.dart';
import 'package:trajectoria/features/company/dashboard/domain/usecases/delete_finalis.dart';
import 'package:trajectoria/features/company/dashboard/domain/usecases/get_finalis.dart';
import 'package:trajectoria/features/company/dashboard/presentation/cubit/finalis_state.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/submission.dart';
import 'package:trajectoria/core/dependency_injection/service_locator.dart';

class UserFinalisCubit extends Cubit<UserFinalisState> {
  UserFinalisCubit() : super(UserFinalisInitial());

  Future<void> addToFinalis(
    SubmissionEntity finalis,
    String name,
    String imageUrl,
  ) async {
    emit(UserFinalisLoading());
    final result = await sl<AddFinalisUseCase>().call(finalis, name, imageUrl);
    result.fold(
      (failure) {
        emit(UserFinalisFailure(message: failure.toString()));
      },
      (data) {
        emit(UserFinalisSuccess(success: data));
      },
    );
  }

  Future<void> getFinalis(String competitionId) async {
    emit(UserFinalisLoading());
    final result = await sl<GetFinalisUseCase>().call(competitionId);
    result.fold(
      (failure) {
        emit(UserFinalisFailure(message: failure.toString()));
      },
      (data) {
        emit(UserFinalisLoaded(finalis: data));
      },
    );
  }

  Future<void> deleteFinalis(String submissionId, String competitionId) async {
    if (state is UserFinalisLoaded) {
      final currentList = (state as UserFinalisLoaded).finalis;

      final newList = currentList
          .where((item) => item.submissionId != submissionId)
          .toList();

      emit(UserFinalisLoaded(finalis: newList));

      final result = await sl<DeleteFinalisUseCase>().call(submissionId);

      result.fold((error) {
        getFinalis(competitionId);
      }, (success) {});
    }
  }
}
