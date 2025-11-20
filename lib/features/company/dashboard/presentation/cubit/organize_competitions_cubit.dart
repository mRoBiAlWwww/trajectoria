import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trajectoria/features/company/dashboard/domain/usecases/analyzed.dart';
import 'package:trajectoria/features/company/dashboard/domain/usecases/create_competition.dart';
import 'package:trajectoria/features/company/dashboard/domain/usecases/delete_competition_by_id.dart';
import 'package:trajectoria/features/company/dashboard/domain/usecases/draft_competition.dart';
import 'package:trajectoria/features/company/dashboard/domain/usecases/get_competition_by_id.dart';
import 'package:trajectoria/features/company/dashboard/domain/usecases/get_competitions.dart';
import 'package:trajectoria/features/company/dashboard/domain/usecases/get_competitions_by_title.dart';
import 'package:trajectoria/features/company/dashboard/domain/usecases/get_draft_competitions.dart';
import 'package:trajectoria/features/company/dashboard/domain/usecases/scoring.dart';
import 'package:trajectoria/features/company/dashboard/presentation/cubit/organize_competition_state.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/competitions.dart';
import 'package:trajectoria/service_locator.dart';

class OrganizeCompetitionCubit extends Cubit<OrganizeCompetitionState> {
  OrganizeCompetitionCubit() : super(OrganizeCompetitionInitial());

  Future<void> submitCompetition(CompetitionEntity competitionData) async {
    emit(OrganizeCompetitionLoading());
    final result = await sl<CreateCompetitionUseCase>().call(competitionData);
    result.fold(
      (failure) {
        emit(OrganizeCompetitionFailure(message: failure.toString()));
      },
      (success) {
        emit(OrganizeCompetitionSuccess(success: success));
      },
    );
  }

  Future<void> draftCompetition(CompetitionEntity competitionData) async {
    emit(OrganizeCompetitionLoading());
    final result = await sl<DraftCompetitionUseCase>().call(competitionData);
    result.fold(
      (failure) {
        emit(OrganizeCompetitionFailure(message: failure.toString()));
      },
      (success) {
        emit(OrganizeCompetitionSuccess(success: success));
      },
    );
  }

  Future<void> getDraftCompetitions() async {
    emit(OrganizeCompetitionLoading());
    final result = await sl<GetDraftCompetitionsUseCase>().call();
    result.fold(
      (failure) {
        emit(OrganizeCompetitionFailure(message: failure.toString()));
      },
      (data) {
        emit(OrganizeDraftCompetitionLoaded(data: data));
      },
    );
  }

  Future<void> getCompetitions() async {
    emit(OrganizeCompetitionLoading());
    final result = await sl<GetCompetitionsCompanyUseCase>().call();
    result.fold(
      (failure) {
        emit(OrganizeCompetitionFailure(message: failure.toString()));
      },
      (data) {
        emit(OrganizeCompetitionsLoaded(data: data));
      },
    );
  }

  Future<void> getCompetitionById(String competitionId) async {
    emit(OrganizeCompetitionLoading());
    final result = await sl<GetCompetitionByIdCompanyUseCase>().call(
      competitionId,
    );
    result.fold(
      (failure) {
        emit(OrganizeCompetitionFailure(message: failure.toString()));
      },
      (data) {
        emit(OrganizeCompetitionLoaded(data: data));
      },
    );
  }

  Future<void> getCompetitionsByTitle(String competitionId) async {
    emit(OrganizeCompetitionLoading());
    final result = await sl<GetCompetitionByKeywordCompanyUseCase>().call(
      competitionId,
    );
    result.fold(
      (failure) {
        emit(OrganizeCompetitionFailure(message: failure.toString()));
      },
      (data) {
        emit(OrganizeCompetitionsLoaded(data: data));
      },
    );
  }

  Future<void> deleteCompetitionById(String competitionId) async {
    emit(OrganizeCompetitionLoading());
    final result = await sl<DeleteCompetitionByIdUseCase>().call(competitionId);
    result.fold(
      (failure) {
        emit(OrganizeCompetitionFailure(message: failure.toString()));
      },
      (data) {
        emit(OrganizeCompetitionSuccess(success: data));
      },
    );
  }

  Future<void> analyzed(
    String problemStatement,
    String submissionId,
    List<String> fileUrls,
  ) async {
    emit(OrganizeCompetitionLoading());
    final result = await sl<AnalyzedUseCase>().call(
      problemStatement,
      submissionId,
      fileUrls,
    );
    result.fold(
      (failure) {
        emit(OrganizeCompetitionFailure(message: failure.toString()));
      },
      (data) {
        emit(OrganizeAISummaryLoaded(data: data));
      },
    );
  }

  Future<void> scoring(
    int totalScore,
    String feedback,
    String submissionId,
  ) async {
    final result = await sl<ScoringUseCase>().call(
      totalScore,
      feedback,
      submissionId,
    );
    result.fold(
      (failure) {
        emit(OrganizeCompetitionFailure(message: failure.toString()));
      },
      (data) {
        emit(OrganizeCompetitionSuccess(success: data));
      },
    );
  }
}
