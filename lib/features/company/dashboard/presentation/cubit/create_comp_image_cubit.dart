import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trajectoria/features/company/dashboard/domain/usecases/create_comp_image.dart';
import 'package:trajectoria/features/company/dashboard/presentation/cubit/create_comp_image_state.dart';
import 'package:trajectoria/core/dependency_injection/service_locator.dart';

class CreateCompImageCubit extends Cubit<CreateCompImageState> {
  CreateCompImageCubit() : super(CreateCompImageInitial());

  Future<void> pickAndUploadImage(String folder) async {
    final imagePicker = sl<ImagePicker>();
    final uploadImageUseCase = sl<CreateCompImageUseCase>();

    // 1. Ambil Gambar
    final XFile? image = await imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (image == null) return;
    emit(CreateCompImageLoading());

    // 2. Panggil Use Case
    final result = await uploadImageUseCase(image, folder);

    // 3. Emit State
    result.fold(
      (failure) => emit(CreateCompImageFailure(message: failure.message)),
      (url) => emit(CreateCompImageSuccess(url: url)),
    );
  }
}
