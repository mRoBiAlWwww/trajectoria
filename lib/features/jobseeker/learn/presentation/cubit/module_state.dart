import 'package:trajectoria/features/authentication/domain/entities/jobseeker_entity.dart';
import 'package:trajectoria/features/jobseeker/learn/domain/entities/module.dart';

abstract class ModuleState {
  const ModuleState();
}

class ModuleInitial extends ModuleState {}

class ModuleLoading extends ModuleState {}

class ModulesAndFinishedModulesLoaded extends ModuleState {
  final List<ModuleEntity> modules;
  final JobSeekerEntity user;
  ModulesAndFinishedModulesLoaded(this.modules, this.user);
}

class ModuleFailure extends ModuleState {}
