import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/competitions.dart';
import 'package:trajectoria/features/jobseeker/compete/presentation/cubit/hydrated_history_state.dart';

class HydratedHistoryCubit extends HydratedCubit<HydratedHistoryState> {
  HydratedHistoryCubit() : super(HydratedHistoryInitial());

  void addCompetition(CompetitionEntity competition) {
    List<CompetitionEntity> updatedList = [];
    final currentState = state;

    emit(HydratedHistoryLoading());

    if (currentState is HydratedHistoryStored) {
      updatedList = List.from(currentState.competitions);

      // Mencegah duplikat (asumsi 'competitionId' adalah ID unik)
      final bool alreadyExists = updatedList.any(
        (c) => c.competitionId == competition.competitionId,
      );

      if (!alreadyExists) {
        debugPrint("tlong");
        updatedList.add(competition);
      }
    } else {
      updatedList = [competition];
    }
    emit(HydratedHistoryStored(updatedList));
  }

  //logic simpan ke persist
  @override
  Map<String, dynamic>? toJson(HydratedHistoryState state) {
    if (state is HydratedHistoryStored && state.competitions.isNotEmpty) {
      // Ubah List<CompetitionEntity> menjadi List<Map<String, dynamic>>
      final competitionMaps = state.competitions.map((e) => e.toMap()).toList();
      return {'competitions': competitionMaps};
    }
    return null;
  }

  //logic ambil data dari persist
  @override
  HydratedHistoryState? fromJson(Map<String, dynamic> json) {
    try {
      final competitionMaps = json['competitions'] as List?;
      if (competitionMaps != null && competitionMaps.isNotEmpty) {
        // Ubah List<Map> kembali menjadi List<CompetitionEntity>
        final competitions = competitionMaps
            .map(
              (map) => CompetitionEntity.fromMap(map as Map<String, dynamic>),
            )
            .toList();
        return HydratedHistoryStored(competitions);
      }
      return HydratedHistoryInitial();
    } catch (e) {
      return HydratedHistoryInitial();
    }
  }

  void clearHistory() {
    emit(HydratedHistoryInitial());
  }
}
