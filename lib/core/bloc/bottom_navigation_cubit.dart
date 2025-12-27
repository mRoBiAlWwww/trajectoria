import 'package:flutter_bloc/flutter_bloc.dart';

class BottomNavCubit extends Cubit<int> {
  BottomNavCubit() : super(0);

  void changeSelectedIndexJobseeker(int index) {
    emit(index);
  }

  void changeSelectedIndexCompany(int index) {
    if (index < 0 || index > 1) return;
    emit(index);
  }

  void reset() {
    emit(0);
  }
}
