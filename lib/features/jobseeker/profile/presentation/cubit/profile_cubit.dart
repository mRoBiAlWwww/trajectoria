import 'package:bloc/bloc.dart';
import 'package:trajectoria/features/company/dashboard/domain/entities/announcement.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/entities/competitions.dart';
import 'package:trajectoria/features/jobseeker/profile/domain/usecases/delete_announcement.dart';
import 'package:trajectoria/features/jobseeker/profile/domain/usecases/get_announcements.dart';
import 'package:trajectoria/features/jobseeker/profile/domain/usecases/get_bookmarks.dart';
import 'package:trajectoria/features/jobseeker/profile/domain/usecases/get_history_competitions.dart';
import 'package:trajectoria/core/dependency_injection/service_locator.dart';
import 'package:trajectoria/features/jobseeker/profile/domain/usecases/marks_as_done.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  Future<void> getHistoryCompetitions() async {
    emit(ProfileLoading());

    final returnedCourseChapter = await sl<GetHistoryCompetitionsUseCase>()
        .call();
    return returnedCourseChapter.fold(
      (error) {
        emit(ProfileFailure());
      },
      (chapterData) async {
        emit(HistoryCompetitionsLoaded(history: chapterData));
      },
    );
  }

  Future<void> getBookmarks() async {
    emit(ProfileLoading());

    final returnedBookmars = await sl<GetBookmarksUseCase>().call();
    return returnedBookmars.fold(
      (error) {
        emit(ProfileFailure());
      },
      (bookmarks) async {
        emit(BookmarksLoaded(bookmarks: bookmarks));
      },
    );
  }

  Future<void> getAnnouncements() async {
    emit(ProfileLoading());

    final returnedCourseChapter = await sl<GetAnnouncementsUseCase>().call();
    return returnedCourseChapter.fold(
      (error) {
        emit(ProfileFailure());
      },
      (chapterData) async {
        emit(AnnouncementsLoaded(announcements: chapterData));
      },
    );
  }

  Future<void> deleteAnnouncement(String announcementId) async {
    if (state is AnnouncementsLoaded) {
      final currentList = (state as AnnouncementsLoaded).announcements;

      final newList = currentList
          .where((item) => item.announcementId != announcementId)
          .toList();

      emit(AnnouncementsLoaded(announcements: newList));

      final result = await sl<DeleteAnnouncementUseCase>().call(announcementId);

      result.fold((error) {
        getAnnouncements();
      }, (success) {});
    }
  }

  Future<void> markasDoneNotification(String announcementId) async {
    emit(ProfileLoading());

    final returnedCourseChapter = await sl<MarksasDoneUseCase>().call(
      announcementId,
    );
    return returnedCourseChapter.fold(
      (error) {
        emit(ProfileFailure());
      },
      (chapterData) async {
        emit(ProfileSuccess(success: chapterData));
      },
    );
  }
}
