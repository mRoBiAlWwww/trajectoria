import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

abstract class ImageUploadRepository {
  Future<Either> uploadImage(XFile imageFile, String folder);
}
