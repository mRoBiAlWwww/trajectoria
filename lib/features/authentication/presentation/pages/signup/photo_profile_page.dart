import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:trajectoria/common/helper/navigator/app_navigator.dart';
import 'package:trajectoria/common/helper/overlay/overlay.dart';
import 'package:trajectoria/common/widgets/button/basic_app_buton.dart';
import 'package:trajectoria/core/config/assets/app_images.dart';
import 'package:trajectoria/features/authentication/data/models/user_signup_req.dart';
import 'package:trajectoria/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:trajectoria/features/authentication/presentation/cubit/auth_state.dart';
import 'package:trajectoria/features/authentication/presentation/cubit/image_upload_cubit.dart';
import 'package:trajectoria/features/authentication/presentation/cubit/image_upload_state.dart';
import 'package:trajectoria/features/authentication/presentation/cubit/user_role_cubit.dart';
import 'package:trajectoria/features/authentication/presentation/pages/signup/get_started.dart';

class PhotoProfilePage extends StatelessWidget {
  final UserSignupReq signupReq;
  const PhotoProfilePage({super.key, required this.signupReq});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: Center(
          child: FractionallySizedBox(
            widthFactor: 0.66,
            child: Container(
              height: 10,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
          ),
        ),
        actions: const [],
      ),
      body: BlocListener<AuthStateCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            GlobalLoading.show(context);
          } else {
            GlobalLoading.hide();
          }

          if (state is AuthFailure) {
            _displayErrorToast(context, state.errorMessage);
          }

          if (state is AuthSuccess) {
            debugPrint(state.user.role.toString());
            AppNavigator.pushAndRemove(context, GetStartePage());
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: SingleChildScrollView(
            child: BlocProvider<ImageUploadCubit>(
              create: (context) => ImageUploadCubit(),
              child: BlocBuilder<ImageUploadCubit, ImageUploadState>(
                builder: (context, state) {
                  String imageUrl = '';
                  final Widget imageContent = _buildImageContent(state);
                  if (state is ImageUploadSuccess) {
                    imageUrl = state.url;
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Foto Profil',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        context.read<RoleCubit>().state == "Jobseeker"
                            ? 'Kamu bisa menambahkan atau edit fotomu di kemudian'
                            : 'Kamu juga bisa memasukkan logo penyelenggara sebagai foto profil',
                        style: TextStyle(fontSize: 15),
                      ),
                      const SizedBox(height: 50),
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 200,
                          height: 200,
                          child: Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.center,
                            children: [
                              Image.asset(
                                AppImages.userProfile,
                                fit: BoxFit.cover,
                                width: 200,
                                height: 200,
                              ),
                              ClipOval(child: imageContent),
                              Positioned(
                                top: 140,
                                left: 140,
                                child: FilledButton(
                                  onPressed: () {
                                    context
                                        .read<ImageUploadCubit>()
                                        .pickAndUploadImage(
                                          'trajectoria/image_profile',
                                        );
                                  },
                                  style: ButtonStyle(
                                    minimumSize: WidgetStateProperty.all(
                                      const Size(0, 0),
                                    ),
                                    backgroundColor: WidgetStateProperty.all(
                                      Colors.black,
                                    ),
                                    foregroundColor: WidgetStateProperty.all(
                                      Colors.white,
                                    ),
                                    padding: WidgetStateProperty.all(
                                      const EdgeInsets.symmetric(
                                        horizontal: 12.0,
                                        vertical: 12.0,
                                      ),
                                    ),
                                    shape: WidgetStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                      ),
                                    ),
                                  ),

                                  child: const Icon(Icons.add, size: 30),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 250),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _skip(context),
                          _buatAkun(context, imageUrl),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageContent(ImageUploadState state) {
    if (state is ImageUploadLoading) {
      return Container(
        width: 200,
        height: 200,
        color: Colors.grey,
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    } else if (state is ImageUploadSuccess) {
      return Image.network(
        state.url,
        fit: BoxFit.cover,
        width: 200,
        height: 200,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: 200,
            height: 200,
            color: Colors.grey,
            child: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return const Center(child: Text('Gagal memuat.'));
        },
      );
    } else {
      return Container();
    }
  }

  Widget _skip(BuildContext context) {
    return TextButton(
      onPressed: () async {
        signupReq.imageUrl = "";
        signupReq.role == "Jobseeker"
            ? await context.read<AuthStateCubit>().additionalUserInfoJobSeeker(
                signupReq.toJobseekerSignupReq(),
              )
            : await context.read<AuthStateCubit>().additionalUserInfoCompany(
                signupReq.toCompanySignupReq(),
              );
      },
      style: TextButton.styleFrom(foregroundColor: Colors.black),
      child: Text(
        "Skip",
        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
      ),
    );
  }

  Widget _buatAkun(BuildContext context, String imageUrl) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.35,
      child: BasicAppButton(
        onPressed: imageUrl.isNotEmpty
            ? () async {
                signupReq.imageUrl = imageUrl;
                signupReq.role == "Jobseeker"
                    ? await context
                          .read<AuthStateCubit>()
                          .additionalUserInfoJobSeeker(
                            signupReq.toJobseekerSignupReq(),
                          )
                    : await context
                          .read<AuthStateCubit>()
                          .additionalUserInfoCompany(
                            signupReq.toCompanySignupReq(),
                          );
              }
            : null,
        backgroundColor: Colors.black,
        content: Text(
          "Buat Akun",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _displayErrorToast(context, String message) {
    MotionToast.error(
      title: Text(
        "error",
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      description: Text(message, style: TextStyle(color: Colors.white)),
    ).show(context);
  }
}



  // Widget _buatAkun(BuildContext context, String imageUrl) {
  //   return ElevatedButton(
  //     onPressed: imageUrl.isNotEmpty
  //         ? () async {
  //             signupReq.imageUrl = imageUrl;
  //             await context.read<AuthStateCubit>().additionalUserInfo(
  //               signupReq,
  //             );
  //           }
  //         : null,
  //     style: ElevatedButton.styleFrom(
  //       padding: EdgeInsets.symmetric(horizontal: 30),
  //       shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
  //       backgroundColor: Colors.black,
  //       foregroundColor: Colors.white,
  //     ),
  //     child: const Text(
  //       "Buat Akun",
  //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  //     ),
  //   );
  // }
  // Widget _buildImageContent(ImageUploadState state) {
  //   if (state is ImageUploadLoading) {
  //     return Container(
  //       width: 200,
  //       height: 200,
  //       color: Colors.blueGrey,
  //       child: const Center(
  //         child: CircularProgressIndicator(color: Colors.white),
  //       ),
  //     );
  //   } else if (state is ImageUploadSuccess) {
  //     return Image.network(
  //       state.url,
  //       fit: BoxFit.cover,
  //       width: 200,
  //       height: 200,
  //       loadingBuilder: (context, child, loadingProgress) {
  //         if (loadingProgress == null) return child;
  //         return const Center(child: CircularProgressIndicator());
  //       },
  //       errorBuilder: (context, error, stackTrace) {
  //         return const Center(child: Text('Gagal memuat.'));
  //       },
  //     );
  //   } else {
  //     return Container();
  //   }
  // }