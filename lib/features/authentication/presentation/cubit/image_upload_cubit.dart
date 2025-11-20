import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trajectoria/features/authentication/domain/usecases/image_upload.dart';
import 'package:trajectoria/service_locator.dart';
import 'image_upload_state.dart';

class ImageUploadCubit extends Cubit<ImageUploadState> {
  ImageUploadCubit() : super(ImageUploadInitial());

  Future<void> pickAndUploadImage(String folder) async {
    final imagePicker = sl<ImagePicker>();
    final uploadImageUseCase = sl<UploadImageUseCase>();

    // 1. Ambil Gambar
    final XFile? image = await imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (image == null) return;
    emit(ImageUploadLoading());

    // 2. Panggil Use Case
    final result = await uploadImageUseCase(image, folder);

    // 3. Emit State
    result.fold(
      (failure) => emit(ImageUploadFailure(message: failure.message)),
      (url) => emit(ImageUploadSuccess(url: url)),
    );
  }
}
