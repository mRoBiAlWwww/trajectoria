import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trajectoria/features/company/dashboard/domain/repositories/create_comp_image_repository.dart';

class CreateCompImageUseCase {
  final CreateCompImageRepository repository;

  CreateCompImageUseCase({required this.repository});

  Future<Either> call(XFile imageFile, String folder) {
    return repository.uploadImage(imageFile, folder);
  }
}
