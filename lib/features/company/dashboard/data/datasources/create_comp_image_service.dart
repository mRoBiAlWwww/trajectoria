import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trajectoria/core/dependency_injection/service_locator.dart';

class ServerException implements Exception {}

abstract class CloudinaryCreateImageComp {
  Future<String> uploadImage(XFile imageFile, String folder);
}

class CloudinaryCreateImageCompImpl implements CloudinaryCreateImageComp {
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
