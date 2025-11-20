abstract class CreateCompImageState {}

class CreateCompImageInitial extends CreateCompImageState {}

class CreateCompImageLoading extends CreateCompImageState {}

class CreateCompImageSuccess extends CreateCompImageState {
  final String url;
  CreateCompImageSuccess({required this.url});
}

class CreateCompImageFailure extends CreateCompImageState {
  final String message;
  CreateCompImageFailure({required this.message});
}
