import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trajectoria/features/authentication/data/datasources/auth_firebase_service.dart';
import 'package:trajectoria/features/authentication/data/datasources/image_upload.dart';
import 'package:trajectoria/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:trajectoria/features/authentication/data/repositories/image_upload_repository_impl.dart';
import 'package:trajectoria/features/authentication/domain/repositories/auth.dart';
import 'package:trajectoria/features/authentication/domain/repositories/image_upload.dart';
import 'package:trajectoria/features/authentication/domain/usecases/additional_info_company.dart';
import 'package:trajectoria/features/authentication/domain/usecases/additional_info_jobseeker.dart';
import 'package:trajectoria/features/authentication/domain/usecases/delete_token_notification.dart';
import 'package:trajectoria/features/authentication/domain/usecases/forgot_password.dart';
import 'package:trajectoria/features/authentication/domain/usecases/get_current_user.dart';
import 'package:trajectoria/features/authentication/domain/usecases/image_upload.dart';
import 'package:trajectoria/features/authentication/domain/usecases/resend_email.dart';
import 'package:trajectoria/features/authentication/domain/usecases/signin.dart';
import 'package:trajectoria/features/authentication/domain/usecases/signin_google.dart';
import 'package:trajectoria/features/authentication/domain/usecases/signout.dart';
import 'package:trajectoria/features/authentication/domain/usecases/signup.dart';
import 'package:trajectoria/features/company/dashboard/data/datasources/competition_organizer_service.dart';
import 'package:trajectoria/features/company/dashboard/data/datasources/create_comp_image_service.dart';
import 'package:trajectoria/features/company/dashboard/data/repositories/create_comp_image_repository_impl.dart';
import 'package:trajectoria/features/company/dashboard/data/repositories/competition_organizer_repository_impl.dart';
import 'package:trajectoria/features/company/dashboard/domain/repositories/create_comp_image_repository.dart';
import 'package:trajectoria/features/company/dashboard/domain/repositories/competition_organizer.dart';
import 'package:trajectoria/features/company/dashboard/domain/usecases/add_finalis.dart';
import 'package:trajectoria/features/company/dashboard/domain/usecases/analyzed.dart';
import 'package:trajectoria/features/company/dashboard/domain/usecases/create_comp_image.dart';
import 'package:trajectoria/features/company/dashboard/domain/usecases/create_competition.dart';
import 'package:trajectoria/features/company/dashboard/domain/usecases/delete_comp_partc_by_comp_id.dart';
import 'package:trajectoria/features/company/dashboard/domain/usecases/delete_competition_by_id.dart';
import 'package:trajectoria/features/company/dashboard/domain/usecases/delete_finalis.dart';
import 'package:trajectoria/features/company/dashboard/domain/usecases/delete_submission_by_comp_id.dart';
import 'package:trajectoria/features/company/dashboard/domain/usecases/draft_competition.dart';
import 'package:trajectoria/features/company/dashboard/domain/usecases/get_competition_by_id.dart';
import 'package:trajectoria/features/company/dashboard/domain/usecases/get_competitions.dart';
import 'package:trajectoria/features/company/dashboard/domain/usecases/get_competitions_by_title.dart';
import 'package:trajectoria/features/company/dashboard/domain/usecases/get_draft_competitions.dart';
import 'package:trajectoria/features/company/dashboard/domain/usecases/get_finalis.dart';
import 'package:trajectoria/features/company/dashboard/domain/usecases/get_jobseeker_across_submissions.dart';
import 'package:trajectoria/features/company/dashboard/domain/usecases/get_jobseeker_submissions.dart';
import 'package:trajectoria/features/company/dashboard/domain/usecases/get_jobseeker_submissions_increment.dart';
import 'package:trajectoria/features/company/dashboard/domain/usecases/get_submission_by_username.dart';
import 'package:trajectoria/features/company/dashboard/domain/usecases/get_user_info.dart';
import 'package:trajectoria/features/company/dashboard/domain/usecases/final_assessment.dart';
import 'package:trajectoria/features/jobseeker/compete/data/datasources/competition_services.dart';
import 'package:trajectoria/features/jobseeker/compete/data/repositories/competitions_repository_impl.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/repositories/competitions.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/usecases/add_bookmark.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/usecases/add_competition_participant.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/usecases/add_submission.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/usecases/delete_bookmark.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/usecases/download_file.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/usecases/get_categories.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/usecases/get_competition_by_category.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/usecases/get_competition_by_filters.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/usecases/get_competition_by_title.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/usecases/get_competitions.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/usecases/get_single_competition.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/usecases/get_submission.dart';
import 'package:trajectoria/features/authentication/domain/usecases/add_token_notification.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/usecases/get_total_comp_participants.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/usecases/is_already_submit.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/usecases/is_bookmarked.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/usecases/upload_file.dart';
import 'package:trajectoria/features/jobseeker/leaderboard/data/datasources/leaderboard_services.dart';
import 'package:trajectoria/features/jobseeker/leaderboard/data/repositories/leaderboard_repository_impl.dart';
import 'package:trajectoria/features/jobseeker/leaderboard/domain/repositories/leaderboard.dart';
import 'package:trajectoria/features/jobseeker/leaderboard/domain/usecases/get_jobseeker_by_score.dart';
import 'package:trajectoria/features/jobseeker/learn/data/datasources/learn_service.dart';
import 'package:trajectoria/features/jobseeker/learn/data/repositories/learn_impl.dart';
import 'package:trajectoria/features/jobseeker/learn/domain/repositories/learn.dart';
import 'package:trajectoria/features/jobseeker/learn/domain/usecases/add_finished_chapter.dart';
import 'package:trajectoria/features/jobseeker/learn/domain/usecases/add_finished_subchapter.dart';
import 'package:trajectoria/features/jobseeker/learn/domain/usecases/add_onprogres_chapter.dart';
import 'package:trajectoria/features/jobseeker/learn/domain/usecases/add_user_score.dart';
import 'package:trajectoria/features/jobseeker/learn/domain/usecases/add_finished_module.dart';
import 'package:trajectoria/features/jobseeker/learn/domain/usecases/add_value_progres.dart';
import 'package:trajectoria/features/jobseeker/learn/domain/usecases/get_all_course_chapters.dart';
import 'package:trajectoria/features/jobseeker/learn/domain/usecases/get_course_by_id.dart';
import 'package:trajectoria/features/jobseeker/learn/domain/usecases/get_course_chapter.dart';
import 'package:trajectoria/features/jobseeker/learn/domain/usecases/get_courses_path.dart';
import 'package:trajectoria/features/jobseeker/learn/domain/usecases/get_modules.dart';
import 'package:trajectoria/features/jobseeker/learn/domain/usecases/get_quiz.dart';
import 'package:trajectoria/features/jobseeker/learn/domain/usecases/get_subchapters.dart';
import 'package:trajectoria/features/jobseeker/profile/data/datasources/profile_service.dart';
import 'package:trajectoria/features/jobseeker/profile/data/repositories/profile_impl.dart';
import 'package:trajectoria/features/jobseeker/profile/domain/repositories/profile.dart';
import 'package:trajectoria/features/jobseeker/profile/domain/usecases/delete_announcement.dart';
import 'package:trajectoria/features/jobseeker/profile/domain/usecases/get_announcements.dart';
import 'package:trajectoria/features/jobseeker/profile/domain/usecases/get_bookmarks.dart';
import 'package:trajectoria/features/jobseeker/profile/domain/usecases/get_history_competitions.dart';
import 'package:trajectoria/features/jobseeker/profile/domain/usecases/marks_as_done.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  //services/datasources
  sl.registerSingleton<AuthFirebaseService>(AuthFirebaseServiceImpl());
  sl.registerSingleton<CloudinaryRemoteDataSource>(
    CloudinaryRemoteDataSourceImpl(),
  );
  sl.registerSingleton<CompetitionService>(CompetitionServiceImpl());
  sl.registerSingleton<LearnService>(LearnServiceImpl());
  sl.registerSingleton<CloudinaryCreateImageComp>(
    CloudinaryCreateImageCompImpl(),
  );
  sl.registerSingleton<CompetitionOrganizerService>(
    CompetitionOrganizerServiceImpl(),
  );
  sl.registerSingleton<LeaderboardServices>(LeaderboardServicesImpl());
  sl.registerSingleton<ProfileService>(ProfileServiceImpl());

  //repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(service: sl<AuthFirebaseService>()),
  );
  sl.registerSingleton<ImageUploadRepository>(ImageUploadRepositoryImpl());
  sl.registerSingleton<CompetitionRepository>(
    CompetitionRepositoryImpl(service: sl<CompetitionService>()),
  );
  sl.registerSingleton<LearnRepository>(
    LearnRepositoryImpl(service: sl<LearnService>()),
  );
  sl.registerSingleton<CreateCompImageRepository>(
    CreateCompImageRepositoryImpl(),
  );
  sl.registerSingleton<CompetitionOrganizerRepository>(
    CompetitionOrganizerRepositoryImpl(
      service: sl<CompetitionOrganizerService>(),
    ),
  );
  sl.registerSingleton<LeaderboardRepository>(
    LeaderboardRepositoryImpl(service: sl<LeaderboardServices>()),
  );
  sl.registerSingleton<ProfileRepository>(
    ProfileRepositoryImpl(service: sl<ProfileService>()),
  );

  //usecases
  //auth
  sl.registerSingleton<UploadImageUseCase>(
    UploadImageUseCase(repository: sl<ImageUploadRepository>()),
  );
  sl.registerSingleton<SignupUseCase>(
    SignupUseCase(repository: sl<AuthRepository>()),
  );
  sl.registerSingleton<SigninUseCase>(
    SigninUseCase(repository: sl<AuthRepository>()),
  );
  sl.registerSingleton<ResendEmailUseCase>(
    ResendEmailUseCase(repository: sl<AuthRepository>()),
  );
  sl.registerSingleton<AdditionalInfoJobseekerUseCase>(
    AdditionalInfoJobseekerUseCase(repository: sl<AuthRepository>()),
  );
  sl.registerSingleton<AdditionalInfoCompanyUseCase>(
    AdditionalInfoCompanyUseCase(repository: sl<AuthRepository>()),
  );
  sl.registerSingleton<ForgotPasswordUseCase>(
    ForgotPasswordUseCase(repository: sl<AuthRepository>()),
  );
  sl.registerSingleton<SignInWithGoogleUseCase>(
    SignInWithGoogleUseCase(repository: sl<AuthRepository>()),
  );
  sl.registerSingleton<GetCurrentUserUseCase>(
    GetCurrentUserUseCase(repository: sl<AuthRepository>()),
  );
  sl.registerSingleton<SignOutUseCase>(
    SignOutUseCase(repository: sl<AuthRepository>()),
  );
  sl.registerSingleton<AddTokenNotificationUseCase>(
    AddTokenNotificationUseCase(repository: sl<AuthRepository>()),
  );
  sl.registerSingleton<DeleteTokenNotificationUseCase>(
    DeleteTokenNotificationUseCase(repository: sl<AuthRepository>()),
  );

  //competitions
  sl.registerSingleton<GetCompetitionsUseCase>(
    GetCompetitionsUseCase(repository: sl<CompetitionRepository>()),
  );
  sl.registerSingleton<GetSingleCompetitionUseCase>(
    GetSingleCompetitionUseCase(repository: sl<CompetitionRepository>()),
  );
  sl.registerSingleton<AddCompetitionParticipantUseCase>(
    AddCompetitionParticipantUseCase(repository: sl<CompetitionRepository>()),
  );
  sl.registerSingleton<DownloadFileUseCase>(
    DownloadFileUseCase(repository: sl<CompetitionRepository>()),
  );
  sl.registerSingleton<UpploadFileUseCase>(
    UpploadFileUseCase(repository: sl<CompetitionRepository>()),
  );
  sl.registerSingleton<AddSubmissionUseCase>(
    AddSubmissionUseCase(repository: sl<CompetitionRepository>()),
  );
  sl.registerSingleton<GetCompetitionByTitleUseCase>(
    GetCompetitionByTitleUseCase(repository: sl<CompetitionRepository>()),
  );
  sl.registerSingleton<GetCategoriesUseCase>(
    GetCategoriesUseCase(repository: sl<CompetitionRepository>()),
  );
  sl.registerSingleton<GetCompetitionByCategoryUseCase>(
    GetCompetitionByCategoryUseCase(repository: sl<CompetitionRepository>()),
  );
  sl.registerSingleton<GetCompetitionByFiltersUseCase>(
    GetCompetitionByFiltersUseCase(repository: sl<CompetitionRepository>()),
  );
  sl.registerSingleton<IsAlreadySubmitedUseCase>(
    IsAlreadySubmitedUseCase(repository: sl<CompetitionRepository>()),
  );
  sl.registerSingleton<GetSubmissionParticipantUseCase>(
    GetSubmissionParticipantUseCase(repository: sl<CompetitionRepository>()),
  );
  sl.registerSingleton<GetTotalCompParticipantsUseCase>(
    GetTotalCompParticipantsUseCase(repository: sl<CompetitionRepository>()),
  );
  sl.registerSingleton<AddBookmarkUseCase>(
    AddBookmarkUseCase(repository: sl<CompetitionRepository>()),
  );
  sl.registerSingleton<DeleteBookmarkUseCase>(
    DeleteBookmarkUseCase(repository: sl<CompetitionRepository>()),
  );
  sl.registerSingleton<IsBookmarkedUseCase>(
    IsBookmarkedUseCase(repository: sl<CompetitionRepository>()),
  );

  //learn
  sl.registerSingleton<GetCoursesUseCase>(
    GetCoursesUseCase(repository: sl<LearnRepository>()),
  );
  sl.registerSingleton<GetModulesUseCase>(
    GetModulesUseCase(repository: sl<LearnRepository>()),
  );
  sl.registerSingleton<GetSubchaptersUseCase>(
    GetSubchaptersUseCase(repository: sl<LearnRepository>()),
  );
  sl.registerSingleton<GetCourseChapterUseCase>(
    GetCourseChapterUseCase(repository: sl<LearnRepository>()),
  );
  sl.registerSingleton<GetQuizUseCase>(
    GetQuizUseCase(repository: sl<LearnRepository>()),
  );
  sl.registerSingleton<AddFinishedModuleStatusUseCase>(
    AddFinishedModuleStatusUseCase(repository: sl<LearnRepository>()),
  );
  sl.registerSingleton<AddUserScoreUseCase>(
    AddUserScoreUseCase(repository: sl<LearnRepository>()),
  );
  sl.registerSingleton<AddFinishedSubchapterStatusUseCase>(
    AddFinishedSubchapterStatusUseCase(repository: sl<LearnRepository>()),
  );
  sl.registerSingleton<AddFinishedChapterStatusUseCase>(
    AddFinishedChapterStatusUseCase(repository: sl<LearnRepository>()),
  );
  sl.registerSingleton<GetAllCourseChaptersUseCase>(
    GetAllCourseChaptersUseCase(repository: sl<LearnRepository>()),
  );
  sl.registerSingleton<AddOnprogresChapterCubit>(
    AddOnprogresChapterCubit(repository: sl<LearnRepository>()),
  );
  sl.registerSingleton<AddValueProgresUseCase>(
    AddValueProgresUseCase(repository: sl<LearnRepository>()),
  );
  sl.registerSingleton<GetCourseChapterByIdUseCase>(
    GetCourseChapterByIdUseCase(repository: sl<LearnRepository>()),
  );

  //leaderboard
  sl.registerSingleton<GetJobseekerByScoreUseCase>(
    GetJobseekerByScoreUseCase(repository: sl<LeaderboardRepository>()),
  );

  //profile
  sl.registerSingleton<GetHistoryCompetitionsUseCase>(
    GetHistoryCompetitionsUseCase(repository: sl<ProfileRepository>()),
  );
  sl.registerSingleton<GetAnnouncementsUseCase>(
    GetAnnouncementsUseCase(repository: sl<ProfileRepository>()),
  );
  sl.registerSingleton<DeleteAnnouncementUseCase>(
    DeleteAnnouncementUseCase(repository: sl<ProfileRepository>()),
  );
  sl.registerSingleton<GetBookmarksUseCase>(
    GetBookmarksUseCase(repository: sl<ProfileRepository>()),
  );
  sl.registerSingleton<MarksasDoneUseCase>(
    MarksasDoneUseCase(repository: sl<ProfileRepository>()),
  );

  //company mode
  sl.registerSingleton<CreateCompImageUseCase>(
    CreateCompImageUseCase(repository: sl<CreateCompImageRepository>()),
  );
  sl.registerSingleton<CreateCompetitionUseCase>(
    CreateCompetitionUseCase(repository: sl<CompetitionOrganizerRepository>()),
  );
  sl.registerSingleton<DraftCompetitionUseCase>(
    DraftCompetitionUseCase(repository: sl<CompetitionOrganizerRepository>()),
  );
  sl.registerSingleton<GetDraftCompetitionsUseCase>(
    GetDraftCompetitionsUseCase(
      repository: sl<CompetitionOrganizerRepository>(),
    ),
  );
  sl.registerSingleton<GetCompetitionsByCurrentCompanyUseCase>(
    GetCompetitionsByCurrentCompanyUseCase(
      repository: sl<CompetitionOrganizerRepository>(),
    ),
  );
  sl.registerSingleton<GetCompetitionByIdCompanyUseCase>(
    GetCompetitionByIdCompanyUseCase(
      repository: sl<CompetitionOrganizerRepository>(),
    ),
  );
  sl.registerSingleton<DeleteCompetitionByIdUseCase>(
    DeleteCompetitionByIdUseCase(
      repository: sl<CompetitionOrganizerRepository>(),
    ),
  );
  sl.registerSingleton<DeleteCompPartcByCompIdUseCase>(
    DeleteCompPartcByCompIdUseCase(
      repository: sl<CompetitionOrganizerRepository>(),
    ),
  );
  sl.registerSingleton<DeleteSubmissionByCompIdUseCase>(
    DeleteSubmissionByCompIdUseCase(
      repository: sl<CompetitionOrganizerRepository>(),
    ),
  );
  sl.registerSingleton<GetCompetitionByKeywordCompanyUseCase>(
    GetCompetitionByKeywordCompanyUseCase(
      repository: sl<CompetitionOrganizerRepository>(),
    ),
  );
  sl.registerSingleton<GetJobseekerSubmissionsUseCase>(
    GetJobseekerSubmissionsUseCase(
      repository: sl<CompetitionOrganizerRepository>(),
    ),
  );
  sl.registerSingleton<AnalyzedUseCase>(
    AnalyzedUseCase(repository: sl<CompetitionOrganizerRepository>()),
  );
  sl.registerSingleton<GetUserInformationUseCase>(
    GetUserInformationUseCase(repository: sl<CompetitionOrganizerRepository>()),
  );
  sl.registerSingleton<FinalAssessmentUseCase>(
    FinalAssessmentUseCase(repository: sl<CompetitionOrganizerRepository>()),
  );
  sl.registerSingleton<AddFinalisUseCase>(
    AddFinalisUseCase(repository: sl<CompetitionOrganizerRepository>()),
  );
  sl.registerSingleton<GetFinalisUseCase>(
    GetFinalisUseCase(repository: sl<CompetitionOrganizerRepository>()),
  );
  sl.registerSingleton<DeleteFinalisUseCase>(
    DeleteFinalisUseCase(repository: sl<CompetitionOrganizerRepository>()),
  );
  sl.registerSingleton<GetJobseekerSubmissionsIncrementUseCase>(
    GetJobseekerSubmissionsIncrementUseCase(
      repository: sl<CompetitionOrganizerRepository>(),
    ),
  );
  sl.registerSingleton<GetJobseekerAcrossSubmissionsUseCase>(
    GetJobseekerAcrossSubmissionsUseCase(
      repository: sl<CompetitionOrganizerRepository>(),
    ),
  );
  sl.registerSingleton<GetSubmissionByUsernameUseCase>(
    GetSubmissionByUsernameUseCase(
      repository: sl<CompetitionOrganizerRepository>(),
    ),
  );

  //external packages
  sl.registerSingleton<ImagePicker>(ImagePicker());
  sl.registerSingleton<CloudinaryPublic>(
    CloudinaryPublic('dzne8xrer', 'trajectoria_cloudinary', cache: false),
  );
}
