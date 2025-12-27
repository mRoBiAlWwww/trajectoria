import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HydratedAnnouncement extends HydratedCubit<List<String>> {
  HydratedAnnouncement() : super([]) {
    _syncPendingAnnouncements();
  }

  Future<void> _syncPendingAnnouncements() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> pendingList =
          prefs.getStringList('pending_announcements') ?? [];

      if (pendingList.isNotEmpty) {
        print("📥 SYNC: Menemukan ${pendingList.length} data dari background.");

        final Set<String> uniqueIds = Set.from(state)..addAll(pendingList);
        emit(uniqueIds.toList());
        await prefs.remove('pending_announcements');
      }
    } catch (e) {
      throw Exception("❌ SYNC ERROR: $e");
    }
  }

  void addAnnouncementId(String id) {
    if (!state.contains(id)) {
      emit([...state, id]);
    }
  }

  void deleteAnnouncementId(String id) {
    if (state.contains(id)) {
      final newList = state.where((element) => element != id).toList();
      emit(newList);
    }
  }

  List<String> getAllAnnouncements() {
    return List.from(state);
  }

  @override
  List<String>? fromJson(Map<String, dynamic> json) =>
      List<String>.from(json['ids'] ?? []);

  @override
  Map<String, dynamic>? toJson(List<String> state) => {'ids': state};
}
