import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/usecases/get_categories.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/usecases/get_competition_by_category.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/usecases/get_competition_by_filters.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/usecases/get_competition_by_title.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/usecases/get_competitions.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/usecases/get_single_competition.dart';
import 'package:trajectoria/features/jobseeker/compete/presentation/cubit/search_compete_state.dart';
import 'package:trajectoria/service_locator.dart';

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

  Future<void> getSingleCompetition(String competitionId) async {
    emit(SearchCompeteLoading());
    var returnedData = await sl<GetSingleCompetitionUseCase>().call(
      competitionId,
    );
    returnedData.fold(
      (error) {
        emit(SearchCompeteError(error));
      },
      (data) {
        emit(SearchCompeteSingleLoaded(data));
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
