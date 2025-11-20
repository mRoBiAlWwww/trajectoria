import 'package:bloc/bloc.dart';

part 'premium_state.dart';

class PremiumCubit extends Cubit<PremiumState> {
  PremiumCubit() : super(PremiumInitial());
}
