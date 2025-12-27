part of 'profile_cubit.dart';

abstract class ProfileState {
  const ProfileState();
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class HistoryCompetitionsLoaded extends ProfileState {
  final List<CompetitionEntity> history;
  HistoryCompetitionsLoaded({required this.history});
}

class BookmarksLoaded extends ProfileState {
  final List<CompetitionEntity> bookmarks;
  BookmarksLoaded({required this.bookmarks});
}

class AnnouncementsLoaded extends ProfileState {
  final List<AnnouncementEntity> announcements;
  AnnouncementsLoaded({required this.announcements});
}

class ProfileSuccess extends ProfileState {
  final String success;
  ProfileSuccess({required this.success});
}

class ProfileFailure extends ProfileState {}
