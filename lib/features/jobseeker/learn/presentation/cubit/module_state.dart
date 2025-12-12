import 'package:trajectoria/features/jobseeker/learn/domain/entities/module.dart';

abstract class ModuleState {
  const ModuleState();
}

class ModuleInitial extends ModuleState {}

class ModuleLoading extends ModuleState {}

class ModulesAndFinishedModulesLoaded extends ModuleState {
  final List<ModuleEntity> modules;
  final List<String> user;
  ModulesAndFinishedModulesLoaded(this.modules, this.user);
}

class ModuleFailure extends ModuleState {}
