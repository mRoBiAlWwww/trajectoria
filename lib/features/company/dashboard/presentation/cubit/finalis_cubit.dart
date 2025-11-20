import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trajectoria/features/company/dashboard/domain/usecases/add_finalis.dart';
import 'package:trajectoria/features/company/dashboard/domain/usecases/delete_finalis.dart';
import 'package:trajectoria/features/company/dashboard/domain/usecases/get_finalis.dart';
import 'package:trajectoria/features/company/dashboard/presentation/cubit/finalis_state.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/submission.dart';
import 'package:trajectoria/service_locator.dart';

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

  Future<void> deleteFinalis(String finalisId) async {
    final currentState = state;

    if (currentState is! UserFinalisLoaded) {
      return;
    }

    final originalList = currentState.finalis;

    final result = await sl<DeleteFinalisUseCase>().call(finalisId);

    result.fold(
      (failure) {
        emit(UserFinalisFailure(message: failure.toString()));
        emit(currentState);
      },
      (data) {
        final updatedList = originalList
            .where((item) => item.finalisId != finalisId)
            .toList();

        emit(UserFinalisLoaded(finalis: updatedList));
      },
    );
  }
}
