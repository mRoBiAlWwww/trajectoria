import 'package:trajectoria/features/jobseeker/compete/domain/entities/competitions.dart';

class CreateCompetitionState {
  final CompetitionEntity competition;
  final bool isLoading;
  final String? error;

  CreateCompetitionState({
    required this.competition,
    this.isLoading = false,
    this.error,
  });

  CreateCompetitionState copyWith({
    CompetitionEntity? competition,
    bool? isLoading,
    String? error,
  }) {
    return CreateCompetitionState(
      competition: competition ?? this.competition,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
