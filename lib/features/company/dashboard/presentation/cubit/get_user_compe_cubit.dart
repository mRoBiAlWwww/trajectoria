import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trajectoria/features/authentication/domain/entities/jobseeker_entity.dart';
import 'package:trajectoria/features/company/dashboard/domain/usecases/get_user_info.dart';
import 'package:trajectoria/features/company/dashboard/presentation/cubit/get_user_compe_state.dart';
import 'package:trajectoria/service_locator.dart';

class GetUserCompeCubit extends Cubit<GetUserCompeState> {
  GetUserCompeCubit() : super(UserCompeInitial());

  Future<void> getUserInfo(String submissionId) async {
    emit(UserCompeLoading());
    final result = await sl<GetUserInfoUseCase>().call(submissionId);
    result.fold(
      (failure) {
        emit(UserCompeFailure());
      },
      (data) {
        emit(UserCompeUserInfo(jobseeker: data));
      },
    );
  }

  Future<void> loadAllUsers(List<String> submissionIds) async {
    emit(UserCompeLoading());

    List<JobSeekerEntity> users = [];

    try {
      for (final id in submissionIds) {
        final result = await sl<GetUserInfoUseCase>().call(id);

        result.fold((failure) {}, (data) {
          users.add(data);
        });
      }

      emit(UserCompeAllUsersLoaded(users: users));
    } catch (e) {
      emit(UserCompeFailure());
    }
  }
}
