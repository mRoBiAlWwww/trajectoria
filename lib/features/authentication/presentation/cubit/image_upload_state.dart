abstract class ImageUploadState {}

class ImageUploadInitial extends ImageUploadState {}

class ImageUploadLoading extends ImageUploadState {}

class ImageUploadSuccess extends ImageUploadState {
  final String url;
  ImageUploadSuccess({required this.url});
}

class ImageUploadFailure extends ImageUploadState {
  final String message;
  ImageUploadFailure({required this.message});
}
