import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:trajectoria/features/jobseeker/learn/presentation/cubit/hydrated_progress_state.dart';

class HydratedProgressCubit extends HydratedCubit<HydratedProgressState> {
  HydratedProgressCubit() : super(HydratedProgressStateInitial());

  void addItem(Map<String, dynamic> input) {
    final currentState = state;

    // Ambil data dari input
    final String targetCourseId = input['courseId'];
    final int scoreToAdd = input['score'] as int;

    List<Map<String, dynamic>> currentList = [];

    // 1. Ambil list saat ini (jika ada)
    if (currentState is HydratedProgressStateLoaded) {
      currentList = List<Map<String, dynamic>>.from(currentState.items);
    }

    // 2. Cari apakah courseId sudah ada di dalam list
    final index = currentList.indexWhere(
      (item) => item['courseId'] == targetCourseId,
    );
    if (index != -1) {
      // KASUS A: SUDAH ADA (Update/Sum)
      final existingItem = currentList[index];
      final int currentScore = (existingItem['score'] ?? 0) as int;

      // Update item di index tersebut dengan Score Lama + Score Baru
      currentList[index] = {
        'courseId': targetCourseId,
        'score': currentScore + scoreToAdd,
      };
    } else {
      // KASUS B: BELUM ADA (Insert Baru)
      currentList.add({'courseId': targetCourseId, 'score': scoreToAdd});
    }

    // 3. Emit state baru
    emit(HydratedProgressStateLoaded(currentList));
  }

  /// Menghapus item berdasarkan index
  void removeItemAt(int index) {
    final currentState = state;
    if (currentState is HydratedProgressStateLoaded &&
        index >= 0 &&
        index < currentState.items.length) {
      final updatedList = List<Map<String, dynamic>>.from(currentState.items)
        ..removeAt(index);
      emit(HydratedProgressStateLoaded(updatedList));
    }
  }

  void clearItems() {
    emit(HydratedProgressStateInitial());
  }

  //Untuk ambil score berdasarkan courseId
  int getScoreByCourseId(String courseId) {
    if (state is HydratedProgressStateLoaded) {
      final loaded = state as HydratedProgressStateLoaded;
      try {
        final item = loaded.items.firstWhere((e) => e['courseId'] == courseId);
        return (item['score'] ?? 0) as int;
      } catch (e) {
        return 0;
      }
    }
    return 0;
  }

  @override
  HydratedProgressState? fromJson(Map<String, dynamic> json) {
    try {
      final List<dynamic> items = json['items'] ?? [];
      final List<Map<String, dynamic>> parsedItems = items
          .map((e) => Map<String, dynamic>.from(e))
          .toList();

      return HydratedProgressStateLoaded(parsedItems);
    } catch (e) {
      return HydratedProgressStateInitial();
    }
  }

  @override
  Map<String, dynamic>? toJson(HydratedProgressState state) {
    if (state is HydratedProgressStateLoaded) {
      return {'items': state.items};
    }
    return null;
  }
}
