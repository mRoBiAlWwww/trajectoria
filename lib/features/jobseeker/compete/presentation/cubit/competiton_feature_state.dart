abstract class CompetitonFeatureState {}

class CompetitonFeatureInitial extends CompetitonFeatureState {}

class CompetitonFeatureLoading extends CompetitonFeatureState {}

class ManageBookmarksSuccess extends CompetitonFeatureState {
  String status;
  ManageBookmarksSuccess(this.status);
}

class CompetitonFeatureError extends CompetitonFeatureState {
  final String message;
  CompetitonFeatureError(this.message);
}
