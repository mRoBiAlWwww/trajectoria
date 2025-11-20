import 'package:trajectoria/features/jobseeker/compete/domain/entities/finalis.dart';

abstract class UserFinalisState {}

class UserFinalisInitial extends UserFinalisState {}

class UserFinalisLoading extends UserFinalisState {}

class UserFinalisSuccess extends UserFinalisState {
  final String success;
  UserFinalisSuccess({required this.success});
}

class UserFinalisLoaded extends UserFinalisState {
  final List<FinalisEntity> finalis;
  UserFinalisLoaded({required this.finalis});
}

class UserFinalisFailure extends UserFinalisState {
  final String message;
  UserFinalisFailure({required this.message});
}
