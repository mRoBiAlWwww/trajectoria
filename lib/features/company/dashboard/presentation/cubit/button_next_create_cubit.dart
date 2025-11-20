import 'package:flutter_bloc/flutter_bloc.dart';

class ButtonNextCreateCubit extends Cubit<bool> {
  ButtonNextCreateCubit() : super(false);

  void updateValid(bool value) => emit(value);
}
