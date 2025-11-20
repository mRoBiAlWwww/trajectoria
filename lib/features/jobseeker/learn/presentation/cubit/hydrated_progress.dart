import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:trajectoria/features/jobseeker/learn/presentation/cubit/hydrated_progress_state.dart';

class HydratedProgressCubit extends HydratedCubit<HydratedProgressState> {
  HydratedProgressCubit() : super(HydratedProgressStateInitial());

  /// Menambahkan item baru ke dalam list
  void addItem(Map<String, dynamic> newItem) {
    final currentState = state;
    if (currentState is HydratedProgressStateLoaded) {
      final updatedList = List<Map<String, dynamic>>.from(currentState.items)
        ..add(newItem);
      emit(HydratedProgressStateLoaded(updatedList));
    } else {
      emit(HydratedProgressStateLoaded([newItem]));
    }
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
      final item = loaded.items.firstWhere(
        (e) => e['courseId'] == courseId,
        orElse: () => {},
      );
      return (item['score'] ?? 0) as int;
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
