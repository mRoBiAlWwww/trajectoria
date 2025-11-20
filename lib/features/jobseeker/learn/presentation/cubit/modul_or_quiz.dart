import 'package:flutter_bloc/flutter_bloc.dart';

class ModulOrQuizToggleCubit extends Cubit<String> {
  ModulOrQuizToggleCubit() : super("Modul");

  void select(String value) => emit(value);
}
