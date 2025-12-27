import 'package:trajectoria/features/authentication/domain/entities/jobseeker_entity.dart';

abstract class GetUserCompeState {}

class UserCompeInitial extends GetUserCompeState {}

class UserCompeLoading extends GetUserCompeState {}

class UserCompeAllUsersLoaded extends GetUserCompeState {
  final List<JobSeekerEntity> users;
  UserCompeAllUsersLoaded({required this.users});
}

class UserCompeFailure extends GetUserCompeState {}
