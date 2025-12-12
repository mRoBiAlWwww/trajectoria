import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trajectoria/features/company/dashboard/domain/usecases/get_competition_by_id.dart';
import 'package:trajectoria/features/company/dashboard/presentation/cubit/create_competition_state.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/competitions.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/file_items.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/rubrik.dart';
import 'package:trajectoria/service_locator.dart';

class CreateCompetitionCubit extends Cubit<CreateCompetitionState> {
  DateTime? pickedDate;
  TimeOfDay? pickedTime;
  DateTime? deadlineDate;
  TimeOfDay? deadlineTime;

  CreateCompetitionCubit()
    : super(
        CreateCompetitionState(
          competition: CompetitionEntity(
            competitionId: "",
            companyName: "",
            companyId: "",
            title: "",
            description: "",
            problemStatement: "",
            deadline: Timestamp.now(),
            rewardDescription: "",
            submissionType: "",
            status: "draft",
            categoryId: "DDrpyORpBqBi3kNE7kHt",
            createdAt: Timestamp.now(),
            competitionImage: "",
            guidebook: [],
            rubrik: [],
          ),
        ),
      );

  void setTitle(String value) {
    emit(state.copyWith(competition: state.competition.copyWith(title: value)));
  }

  void setDescription(String value) {
    emit(
      state.copyWith(
        competition: state.competition.copyWith(description: value),
      ),
    );
  }

  void setCompanyName(String value) {
    emit(
      state.copyWith(
        competition: state.competition.copyWith(companyName: value),
      ),
    );
  }

  void setProblemStatement(String value) {
    emit(
      state.copyWith(
        competition: state.competition.copyWith(problemStatement: value),
      ),
    );
  }

  void setSubmissionType(String value) {
    emit(
      state.copyWith(
        competition: state.competition.copyWith(submissionType: value),
      ),
    );
  }

  void setStatus(String value) {
    emit(
      state.copyWith(competition: state.competition.copyWith(status: value)),
    );
  }

  void setRewardDescription(String value) {
    emit(
      state.copyWith(
        competition: state.competition.copyWith(rewardDescription: value),
      ),
    );
  }

  void setCategoryId(String value) {
    emit(
      state.copyWith(
        competition: state.competition.copyWith(categoryId: value),
      ),
    );
  }

  void setCompetitionImage(String imageUrl) {
    emit(
      state.copyWith(
        competition: state.competition.copyWith(competitionImage: imageUrl),
      ),
    );
  }

  void setCreatedDate(DateTime date) {
    pickedDate = date;
    _updateCreatedAt();
  }

  void setCreatedTime(TimeOfDay time) {
    pickedTime = time;
    _updateCreatedAt();
  }

  void _updateCreatedAt() {
    if (pickedDate == null || pickedTime == null) return;

    final combined = DateTime(
      pickedDate!.year,
      pickedDate!.month,
      pickedDate!.day,
      pickedTime!.hour,
      pickedTime!.minute,
    );

    emit(
      state.copyWith(
        competition: state.competition.copyWith(
          createdAt: Timestamp.fromDate(combined),
        ),
      ),
    );
  }

  void setDeadlineDate(DateTime date) {
    deadlineDate = date;
    _updateDeadline();
  }

  void setDeadlineTime(TimeOfDay time) {
    deadlineTime = time;
    _updateDeadline();
  }

  void _updateDeadline() {
    if (deadlineDate == null || deadlineTime == null) return;

    final combined = DateTime(
      deadlineDate!.year,
      deadlineDate!.month,
      deadlineDate!.day,
      deadlineTime!.hour,
      deadlineTime!.minute,
    );

    emit(
      state.copyWith(
        competition: state.competition.copyWith(
          deadline: Timestamp.fromDate(combined),
        ),
      ),
    );
  }

  bool isDeadlineBeforeCreatedAt() {
    final created = state.competition.createdAt.toDate();
    final deadline = state.competition.deadline.toDate();

    return deadline.isBefore(created);
  }

  void addGuidebookItem(FileItemEntity item) {
    final updated = List<FileItemEntity>.from(state.competition.guidebook)
      ..add(item);

    emit(
      state.copyWith(
        competition: state.competition.copyWith(guidebook: updated),
      ),
    );
  }

  void addGuidebookItemList(List<FileItemEntity> items) {
    final updated = List<FileItemEntity>.from(state.competition.guidebook)
      ..addAll(items);

    emit(
      state.copyWith(
        competition: state.competition.copyWith(guidebook: updated),
      ),
    );
  }

  void removeGuidebookItem(int index) {
    final updated = List<FileItemEntity>.from(state.competition.guidebook)
      ..removeAt(index);

    emit(
      state.copyWith(
        competition: state.competition.copyWith(guidebook: updated),
      ),
    );
  }

  void setRubrik(List<RubrikItemEntity> rubrikList) {
    emit(
      state.copyWith(
        competition: state.competition.copyWith(rubrik: rubrikList),
      ),
    );
  }

  bool isCompetitionComplete() {
    final c = state.competition;
    final titleValid = c.title.isNotEmpty;
    final descValid = c.description.isNotEmpty;
    final problemValid = c.problemStatement.isNotEmpty;
    final submissionValid = c.submissionType.isNotEmpty;
    final rewardValid = c.rewardDescription.isNotEmpty;
    final categoryValid = c.categoryId.isNotEmpty;
    final imgValid = c.competitionImage.isNotEmpty;
    final guidebookValid = c.guidebook.isNotEmpty;
    final rubrikValid = c.rubrik.isNotEmpty;
    return titleValid &&
        descValid &&
        problemValid &&
        submissionValid &&
        rewardValid &&
        categoryValid &&
        imgValid &&
        guidebookValid &&
        rubrikValid;
  }

  Future<void> fetchCompetitionById(String competitionId) async {
    emit(state.copyWith(isLoading: true));
    final result = await sl<GetCompetitionByIdCompanyUseCase>().call(
      competitionId,
    );

    result.fold(
      (failure) {
        (failure) => emit(state.copyWith(isLoading: false, error: failure));
      },
      (data) {
        emit(state.copyWith(isLoading: false, competition: data));

        // Atur ulang pickedDate / pickedTime agar date picker menampilkan data lama
        final created = data.createdAt.toDate();
        pickedDate = DateTime(created.year, created.month, created.day);
        pickedTime = TimeOfDay(hour: created.hour, minute: created.minute);

        final deadline = data.deadline.toDate();
        deadlineDate = DateTime(deadline.year, deadline.month, deadline.day);
        deadlineTime = TimeOfDay(hour: deadline.hour, minute: deadline.minute);
      },
    );
  }

  void debugPrintState() {
    final c = state.competition;

    debugPrint("======= CREATE COMPETITION STATE =======");
    debugPrint("Title              : ${c.title}");
    debugPrint("Description        : ${c.description}");
    debugPrint("Problem Statement  : ${c.problemStatement}");
    debugPrint("Submission Type    : ${c.submissionType}");
    debugPrint("Reward Description : ${c.rewardDescription}");
    debugPrint("Category ID        : ${c.categoryId}");
    debugPrint("Competition Image  : ${c.competitionImage}");
    debugPrint("Guidebook Count    : ${c.guidebook.length}");
    debugPrint("Created At         : ${c.createdAt.toDate()}");
    debugPrint("Deadline           : ${c.deadline.toDate()}");

    debugPrint("Rubrik Count       : ${c.rubrik.length}");
    for (var i = 0; i < c.rubrik.length; i++) {
      final item = c.rubrik[i];
      debugPrint("  - [$i] Kriteria: ${item.kriteria}, Bobot: ${item.bobot}%");
    }

    debugPrint("========================================");

    debugPrint("Internal Temporary Picks:");
    debugPrint("Picked Date (CreatedAt) : $pickedDate");
    debugPrint("Picked Time (CreatedAt) : $pickedTime");
    debugPrint("Picked Date (Deadline)  : $deadlineDate");
    debugPrint("Picked Time (Deadline)  : $deadlineTime");
    debugPrint("========================================");
  }
}
