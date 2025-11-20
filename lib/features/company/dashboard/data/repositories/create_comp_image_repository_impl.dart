import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trajectoria/features/authentication/data/datasources/image_upload.dart';
import 'package:trajectoria/features/company/dashboard/domain/repositories/create_comp_image_repository.dart';
import 'package:trajectoria/service_locator.dart';

class CreateCompImageRepositoryImpl implements CreateCompImageRepository {
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
