import 'package:flutter_bloc/flutter_bloc.dart';

class ScoreCubit extends Cubit<int> {
  ScoreCubit() : super(0);

  void addScore() => emit(state + 1);
}
