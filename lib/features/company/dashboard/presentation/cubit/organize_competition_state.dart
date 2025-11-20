import 'package:trajectoria/features/jobseeker/compete/domain/entities/competitions.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/insightAI.dart';

abstract class OrganizeCompetitionState {}

class OrganizeCompetitionInitial extends OrganizeCompetitionState {}

class OrganizeCompetitionLoading extends OrganizeCompetitionState {}

class OrganizeCompetitionSuccess extends OrganizeCompetitionState {
  final String success;
  OrganizeCompetitionSuccess({required this.success});
}

class OrganizeCompetitionsLoaded extends OrganizeCompetitionState {
  final List<CompetitionEntity> data;
  OrganizeCompetitionsLoaded({required this.data});
}

class OrganizeCompetitionLoaded extends OrganizeCompetitionState {
  CompetitionEntity data;
  OrganizeCompetitionLoaded({required this.data});
}

class OrganizeDraftCompetitionLoaded extends OrganizeCompetitionState {
  final List<CompetitionEntity> data;
  OrganizeDraftCompetitionLoaded({required this.data});
}

class OrganizeAISummaryLoaded extends OrganizeCompetitionState {
  final InsightAIEntity data;
  OrganizeAISummaryLoaded({required this.data});
}

class OrganizeCompetitionFailure extends OrganizeCompetitionState {
  final String message;
  OrganizeCompetitionFailure({required this.message});
}
