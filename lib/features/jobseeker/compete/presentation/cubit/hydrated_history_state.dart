import 'package:trajectoria/features/jobseeker/compete/domain/entities/competitions.dart';

abstract class HydratedHistoryState {}

class HydratedHistoryInitial extends HydratedHistoryState {}

class HydratedHistoryLoading extends HydratedHistoryState {}

class HydratedHistoryStored extends HydratedHistoryState {
  final List<CompetitionEntity> competitions;
  HydratedHistoryStored(this.competitions);
}

class HydratedHistoryError extends HydratedHistoryState {
  final String message;
  HydratedHistoryError(this.message);
}
