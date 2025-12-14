import 'package:trajectoria/features/jobseeker/learn/domain/entities/module.dart';

abstract class FinishedChapterAndModuleState {
  const FinishedChapterAndModuleState();
}

class FinishedChapterAndModuleInitial extends FinishedChapterAndModuleState {}

class FinishedChapterAndModuleLoading extends FinishedChapterAndModuleState {}

class ModulesAndFinishedModulesLoaded extends FinishedChapterAndModuleState {
  final List<ModuleEntity> modules;
  final List<String> user;
  ModulesAndFinishedModulesLoaded(this.modules, this.user);
}

class OnprogresOrFinishedChapterLoaded extends FinishedChapterAndModuleState {
  final List<String> onprogresChapters;
  final List<String> finishedChapters;
  OnprogresOrFinishedChapterLoaded(
    this.onprogresChapters,
    this.finishedChapters,
  );
}

class FinishedChapterAndModuleFailure extends FinishedChapterAndModuleState {}
