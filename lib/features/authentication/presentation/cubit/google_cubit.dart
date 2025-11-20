import 'package:flutter_bloc/flutter_bloc.dart';

class LoginFlowCubit extends Cubit<bool> {
  LoginFlowCubit() : super(false);

  void setGooglePopupFlow(bool value) => emit(value);
}
