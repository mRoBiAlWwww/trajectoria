import 'package:flutter_bloc/flutter_bloc.dart';

class DraftOrCompetitionsCubit extends Cubit<String> {
  DraftOrCompetitionsCubit() : super("Competitions");

  void select(String value) => emit(value);
}
