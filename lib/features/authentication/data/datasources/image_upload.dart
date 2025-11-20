import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trajectoria/service_locator.dart';

class ServerException implements Exception {}

abstract class CloudinaryRemoteDataSource {
  Future<String> uploadImage(XFile imageFile, String folder);
}

class CloudinaryRemoteDataSourceImpl implements CloudinaryRemoteDataSource {
  @override
  Future<String> uploadImage(XFile imageFile, String folder) async {
    try {
      final response = await sl<CloudinaryPublic>().uploadFile(
        CloudinaryFile.fromFile(
          imageFile.path,
          resourceType: CloudinaryResourceType.Image,
          folder: folder,
        ),
      );
      return response.secureUrl;
    } on CloudinaryException catch (e) {
      debugPrint(e.message);
      throw ServerException();
    }
  }
}
