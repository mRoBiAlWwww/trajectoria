import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trajectoria/core/dependency_injection/service_locator.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/usecases/add_bookmark.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/usecases/delete_bookmark.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/usecases/is_bookmarked.dart';
import 'package:trajectoria/features/jobseeker/compete/presentation/cubit/competiton_feature_state.dart';

class CompetitonFeatureCubit extends Cubit<CompetitonFeatureState> {
  CompetitonFeatureCubit() : super(CompetitonFeatureInitial());

  Future<void> addBookmark(String competitionId) async {
    emit(CompetitonFeatureLoading());
    var returnedData = await sl<AddBookmarkUseCase>().call(competitionId);

    returnedData.fold(
      (error) {
        emit(CompetitonFeatureError(error));
      },
      (message) {
        emit(ManageBookmarksSuccess(message));
      },
    );
  }

  Future<void> deleteBookmark(String competitionId) async {
    emit(CompetitonFeatureLoading());
    var returnedData = await sl<DeleteBookmarkUseCase>().call(competitionId);
    returnedData.fold(
      (error) {
        emit(CompetitonFeatureError(error));
      },
      (message) {
        emit(ManageBookmarksSuccess(message));
      },
    );
  }

  Future<bool> isBookmark(String competitionId) async {
    emit(CompetitonFeatureLoading());
    var returnedData = await sl<IsBookmarkedUseCase>().call(competitionId);
    return returnedData.fold(
      (error) {
        emit(CompetitonFeatureError(error));
        return false;
      },
      (message) {
        emit(ManageBookmarksSuccess(message.toString()));
        return message;
      },
    );
  }

  void reset() {
    emit(CompetitonFeatureInitial());
  }
}
