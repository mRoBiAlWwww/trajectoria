import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/usecases/get_categories.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/usecases/get_competition_by_category.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/usecases/get_competition_by_filters.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/usecases/get_competition_by_title.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/usecases/get_competitions.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/usecases/get_single_competition.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/usecases/get_submission.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/usecases/get_total_comp_participants.dart';
import 'package:trajectoria/features/jobseeker/compete/presentation/cubit/search_compete_state.dart';
import 'package:trajectoria/core/dependency_injection/service_locator.dart';

class SearchCompeteCubit extends Cubit<SearchCompeteState> {
  SearchCompeteCubit() : super(SearchCompeteInitial());

  Future<void> getCompetitions() async {
    emit(SearchCompeteLoading());
    var returnedData = await sl<GetCompetitionsUseCase>().call();

    returnedData.fold(
      (error) {
        emit(SearchCompeteError(error));
      },
      (data) {
        emit(SearchCompeteLoaded(data));
      },
    );
  }

  Future<void> getSingleCompetitionAndSubmission(String competitionId) async {
    emit(SearchCompeteLoading());
    var returnedCompetitionData = await sl<GetSingleCompetitionUseCase>().call(
      competitionId,
    );
    returnedCompetitionData.fold(
      (error) {
        emit(SearchCompeteError(error));
      },
      (competitionData) async {
        final returnedSubmissionData =
            await sl<GetSubmissionParticipantUseCase>().call(competitionId);

        returnedSubmissionData.fold(
          (error) {
            emit(SearchCompeteError(error));
          },
          (submissiondata) async {
            final returnedTotalParticipantsData =
                await sl<GetTotalCompParticipantsUseCase>().call(competitionId);

            returnedTotalParticipantsData.fold(
              (error) {
                emit(SearchCompeteError(error));
              },
              (totalParticipantsData) async {
                emit(
                  SingleCompeteAndSubmissionLoaded(
                    competitionData,
                    submissiondata,
                    totalParticipantsData,
                  ),
                );
              },
            );
            // emit(
            //   SingleCompeteAndSubmissionLoaded(competitionData, submissiondata),
            // );
          },
        );
      },
    );
  }

  Future<void> getCompetitionsByTitle(String keyword) async {
    emit(SearchCompeteLoading());
    var competitions = await sl<GetCompetitionByTitleUseCase>().call(keyword);
    competitions.fold(
      (error) {
        emit(SearchCompeteError(error));
      },
      (data) {
        emit(SearchCompeteLoaded(data));
      },
    );
  }

  Future<void> getCompetitionsByCategory(String categoryId) async {
    emit(SearchCompeteLoading());
    var competitions = await sl<GetCompetitionByCategoryUseCase>().call(
      categoryId,
    );
    competitions.fold(
      (error) {
        emit(SearchCompeteError(error));
      },
      (data) {
        emit(SearchCompeteLoaded(data));
      },
    );
  }

  Future<void> getCompetitionsByFilters(
    List<String> category,
    String duration,
  ) async {
    emit(SearchCompeteLoading());
    var competitions = await sl<GetCompetitionByFiltersUseCase>().call(
      category,
      duration,
    );
    competitions.fold(
      (error) {
        emit(SearchCompeteError(error));
      },
      (data) {
        emit(SearchCompeteLoaded(data));
      },
    );
  }

  Future<void> getCategories() async {
    var categories = await sl<GetCategoriesUseCase>().call();

    categories.fold(
      (error) {
        emit(SearchCompeteError(error));
      },
      (data) {
        emit(SearchCategoriesLoaded(data));
      },
    );
  }

  void reset() {
    emit(SearchCompeteInitial());
  }
}
