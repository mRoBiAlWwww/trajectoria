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
import 'package:trajectoria/features/authentication/domain/usecases/forgot_password.dart';
import 'package:trajectoria/features/authentication/domain/usecases/get_current_user.dart';
import 'package:trajectoria/features/authentication/domain/usecases/image_upload.dart';
import 'package:trajectoria/features/authentication/domain/usecases/resend_email.dart';
import 'package:trajectoria/features/authentication/domain/usecases/signin.dart';
import 'package:trajectoria/features/authentication/domain/usecases/signin_google.dart';
import 'package:trajectoria/features/authentication/domain/usecases/signout.dart';
import 'package:trajectoria/features/authentication/domain/usecases/signup.dart';
import 'package:trajectoria/features/company/dashboard/data/datasources/create_comp_image_service.dart';
import 'package:trajectoria/features/company/dashboard/data/datasources/create_competition_service.dart';
import 'package:trajectoria/features/company/dashboard/data/repositories/create_comp_image_repository_impl.dart';
import 'package:trajectoria/features/company/dashboard/data/repositories/create_competition_repository_impl.dart';
import 'package:trajectoria/features/company/dashboard/domain/repositories/create_comp_image_repository.dart';
import 'package:trajectoria/features/company/dashboard/domain/repositories/create_competition.dart';
import 'package:trajectoria/features/company/dashboard/domain/usecases/add_finalis.dart';
import 'package:trajectoria/features/company/dashboard/domain/usecases/analyzed.dart';
import 'package:trajectoria/features/company/dashboard/domain/usecases/create_comp_image.dart';
import 'package:trajectoria/features/company/dashboard/domain/usecases/create_competition.dart';
import 'package:trajectoria/features/company/dashboard/domain/usecases/delete_competition_by_id.dart';
import 'package:trajectoria/features/company/dashboard/domain/usecases/delete_finalis.dart';
import 'package:trajectoria/features/company/dashboard/domain/usecases/draft_competition.dart';
import 'package:trajectoria/features/company/dashboard/domain/usecases/get_competition_by_id.dart';
import 'package:trajectoria/features/company/dashboard/domain/usecases/get_competitions.dart';
import 'package:trajectoria/features/company/dashboard/domain/usecases/get_competitions_by_title.dart';
import 'package:trajectoria/features/company/dashboard/domain/usecases/get_draft_competitions.dart';
import 'package:trajectoria/features/company/dashboard/domain/usecases/get_finalis.dart';
import 'package:trajectoria/features/company/dashboard/domain/usecases/get_jobseeker_across_submissions.dart';
import 'package:trajectoria/features/company/dashboard/domain/usecases/get_jobseeker_submissions.dart';
import 'package:trajectoria/features/company/dashboard/domain/usecases/get_jobseeker_submissions_increment.dart';
import 'package:trajectoria/features/company/dashboard/domain/usecases/get_user_info.dart';
import 'package:trajectoria/features/company/dashboard/domain/usecases/scoring.dart';
import 'package:trajectoria/features/jobseeker/compete/data/datasources/competition_services.dart';
import 'package:trajectoria/features/jobseeker/compete/data/repositories/competitions_repository_impl.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/repositories/competitions.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/usecases/add_competition_participant.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/usecases/add_submission.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/usecases/download_file.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/usecases/get_categories.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/usecases/get_competition_by_category.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/usecases/get_competition_by_filters.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/usecases/get_competition_by_title.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/usecases/get_competitions.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/usecases/get_single_competition.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/usecases/is_already_submit.dart';
import 'package:trajectoria/features/jobseeker/compete/domain/usecases/upload_file.dart';
import 'package:trajectoria/features/jobseeker/leaderboard/data/datasources/leaderboard_services.dart';
import 'package:trajectoria/features/jobseeker/leaderboard/data/repositories/leaderboard_repository_impl.dart';
import 'package:trajectoria/features/jobseeker/leaderboard/domain/repositories/leaderboard.dart';
import 'package:trajectoria/features/jobseeker/leaderboard/domain/usecases/get_jobseeker_by_score.dart';
import 'package:trajectoria/features/jobseeker/learn/data/datasources/learn_service.dart';
import 'package:trajectoria/features/jobseeker/learn/data/repositories/learn_impl.dart';
import 'package:trajectoria/features/jobseeker/learn/domain/repositories/learn.dart';
import 'package:trajectoria/features/jobseeker/learn/domain/usecases/add_user_score.dart';
import 'package:trajectoria/features/jobseeker/learn/domain/usecases/add_finished_module.dart';
import 'package:trajectoria/features/jobseeker/learn/domain/usecases/get_course_chapter.dart';
import 'package:trajectoria/features/jobseeker/learn/domain/usecases/get_courses_path.dart';
import 'package:trajectoria/features/jobseeker/learn/domain/usecases/get_modules.dart';
import 'package:trajectoria/features/jobseeker/learn/domain/usecases/get_quiz.dart';
import 'package:trajectoria/features/jobseeker/learn/domain/usecases/get_subchapters.dart';

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
  sl.registerSingleton<CreateCompetitionService>(
    CreateCompetitionServiceImpl(),
  );
  sl.registerSingleton<LeaderboardServices>(LeaderboardServicesImpl());

  //repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(service: sl<AuthFirebaseService>()),
  );
  sl.registerSingleton<ImageUploadRepository>(ImageUploadRepositoryImpl());
  sl.registerSingleton<CompetitionRepository>(CompetitionRepositoryImpl());
  sl.registerSingleton<LearnRepository>(
    LearnRepositoryImpl(service: sl<LearnService>()),
  );
  sl.registerSingleton<CreateCompImageRepository>(
    CreateCompImageRepositoryImpl(),
  );
  sl.registerSingleton<CreateCompetitionRepository>(
    CreateCompetitionRepositoryImpl(service: sl<CreateCompetitionService>()),
  );
  sl.registerSingleton<LeaderboardRepository>(
    LeaderboardRepositoryImpl(service: sl<LeaderboardServices>()),
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

  //company mode
  sl.registerSingleton<CreateCompImageUseCase>(
    CreateCompImageUseCase(repository: sl<CreateCompImageRepository>()),
  );
  sl.registerSingleton<CreateCompetitionUseCase>(
    CreateCompetitionUseCase(repository: sl<CreateCompetitionRepository>()),
  );
  sl.registerSingleton<DraftCompetitionUseCase>(
    DraftCompetitionUseCase(repository: sl<CreateCompetitionRepository>()),
  );
  sl.registerSingleton<GetDraftCompetitionsUseCase>(
    GetDraftCompetitionsUseCase(repository: sl<CreateCompetitionRepository>()),
  );
  sl.registerSingleton<GetCompetitionsCompanyUseCase>(
    GetCompetitionsCompanyUseCase(
      repository: sl<CreateCompetitionRepository>(),
    ),
  );
  sl.registerSingleton<GetCompetitionByIdCompanyUseCase>(
    GetCompetitionByIdCompanyUseCase(
      repository: sl<CreateCompetitionRepository>(),
    ),
  );
  sl.registerSingleton<DeleteCompetitionByIdUseCase>(
    DeleteCompetitionByIdUseCase(repository: sl<CreateCompetitionRepository>()),
  );
  sl.registerSingleton<GetCompetitionByKeywordCompanyUseCase>(
    GetCompetitionByKeywordCompanyUseCase(
      repository: sl<CreateCompetitionRepository>(),
    ),
  );
  sl.registerSingleton<GetJobseekerSubmissionsUseCase>(
    GetJobseekerSubmissionsUseCase(
      repository: sl<CreateCompetitionRepository>(),
    ),
  );
  sl.registerSingleton<AnalyzedUseCase>(
    AnalyzedUseCase(repository: sl<CreateCompetitionRepository>()),
  );
  sl.registerSingleton<GetUserInfoUseCase>(
    GetUserInfoUseCase(repository: sl<CreateCompetitionRepository>()),
  );
  sl.registerSingleton<ScoringUseCase>(
    ScoringUseCase(repository: sl<CreateCompetitionRepository>()),
  );
  sl.registerSingleton<AddFinalisUseCase>(
    AddFinalisUseCase(repository: sl<CreateCompetitionRepository>()),
  );
  sl.registerSingleton<GetFinalisUseCase>(
    GetFinalisUseCase(repository: sl<CreateCompetitionRepository>()),
  );
  sl.registerSingleton<DeleteFinalisUseCase>(
    DeleteFinalisUseCase(repository: sl<CreateCompetitionRepository>()),
  );
  sl.registerSingleton<GetJobseekerSubmissionsIncrementUseCase>(
    GetJobseekerSubmissionsIncrementUseCase(
      repository: sl<CreateCompetitionRepository>(),
    ),
  );
  sl.registerSingleton<GetJobseekerAcrossSubmissionsUseCase>(
    GetJobseekerAcrossSubmissionsUseCase(
      repository: sl<CreateCompetitionRepository>(),
    ),
  );
  sl.registerSingleton<GetJobseekerByScoreUseCase>(
    // BENAR: UseCase berbicara dengan Repository
    GetJobseekerByScoreUseCase(repository: sl<LeaderboardRepository>()),
  );

  //external packages
  sl.registerSingleton<ImagePicker>(ImagePicker());
  sl.registerSingleton<CloudinaryPublic>(
    CloudinaryPublic('dzne8xrer', 'trajectoria_cloudinary', cache: false),
  );
}
