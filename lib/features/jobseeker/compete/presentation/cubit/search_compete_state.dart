import 'package:trajectoria/features/jobseeker/compete/domain/entities/category.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/competitions.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/submission.dart';

abstract class SearchCompeteState {}

class SearchCompeteInitial extends SearchCompeteState {}

class SearchCompeteLoading extends SearchCompeteState {}

class SearchCompeteLoaded extends SearchCompeteState {
  final List<CompetitionEntity> competitions;
  SearchCompeteLoaded(this.competitions);
}

class SingleCompeteAndSubmissionLoaded extends SearchCompeteState {
  final CompetitionEntity competition;
  final SubmissionEntity? submission;
  final int totalCompetitionParticipants;
  SingleCompeteAndSubmissionLoaded(
    this.competition,
    this.submission,
    this.totalCompetitionParticipants,
  );
}

class SearchCategoriesLoaded extends SearchCompeteState {
  final List<CategoryEntity> categories;
  SearchCategoriesLoaded(this.categories);
}

class SearchCompeteError extends SearchCompeteState {
  final String message;
  SearchCompeteError(this.message);
}
