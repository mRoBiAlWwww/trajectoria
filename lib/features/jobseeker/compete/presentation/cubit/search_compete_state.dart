import 'package:trajectoria/features/jobseeker/compete/domain/entities/category.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/competitions.dart';

abstract class SearchCompeteState {}

class SearchCompeteInitial extends SearchCompeteState {}

class SearchCompeteLoading extends SearchCompeteState {}

class SearchCompeteLoaded extends SearchCompeteState {
  final List<CompetitionEntity> competitions;
  SearchCompeteLoaded(this.competitions);
}

class SearchCompeteSingleLoaded extends SearchCompeteState {
  final CompetitionEntity competition;
  SearchCompeteSingleLoaded(this.competition);
}

class SearchCategoriesLoaded extends SearchCompeteState {
  final List<CategoryEntity> categories;
  SearchCategoriesLoaded(this.categories);
}

class SearchCompeteError extends SearchCompeteState {
  final String message;
  SearchCompeteError(this.message);
}
