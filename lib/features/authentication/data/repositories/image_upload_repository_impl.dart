import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trajectoria/features/authentication/data/datasources/image_upload.dart';
import 'package:trajectoria/features/authentication/domain/repositories/image_upload.dart';
import 'package:trajectoria/core/dependency_injection/service_locator.dart';

class ImageUploadRepositoryImpl implements ImageUploadRepository {
  @override
  Future<Either> uploadImage(XFile imageFile, String folder) async {
    try {
      final url = await sl<CloudinaryRemoteDataSource>().uploadImage(
        imageFile,
        folder,
      );
      return Right(url);
    } on ServerException {
      return Left('Gagal mengunggah gambar.');
    }
  }
}
