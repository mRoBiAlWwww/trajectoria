import 'package:flutter_bloc/flutter_bloc.dart';

class NextCubit extends Cubit<int> {
  NextCubit() : super(0);

  void next() => emit(state + 1);
}
