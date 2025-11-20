import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trajectoria/features/authentication/domain/repositories/image_upload.dart';

class UploadImageUseCase {
  final ImageUploadRepository repository;

  UploadImageUseCase({required this.repository});

  Future<Either> call(XFile imageFile, String folder) {
    return repository.uploadImage(imageFile, folder);
  }
}
