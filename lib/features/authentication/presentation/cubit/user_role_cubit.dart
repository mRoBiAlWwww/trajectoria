import 'package:bloc/bloc.dart';

class RoleCubit extends Cubit<String> {
  RoleCubit() : super('');

  void setRole(String role) {
    emit(role);
  }

  void clearRole() {
    emit('');
  }
}
