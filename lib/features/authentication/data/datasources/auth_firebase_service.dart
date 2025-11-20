import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:trajectoria/features/authentication/data/models/company_signup_req.dart';
import 'package:trajectoria/features/authentication/data/models/jobseeker_signup_req.dart';
import 'package:trajectoria/features/authentication/data/models/user_signin_req.dart';
import 'package:trajectoria/features/authentication/data/models/user_signup_req.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthFirebaseService {
  Future<Either> signup(UserSignupReq user);
  Future<Either> resendVerificationEmail();
  Future<Either> additionalUserInfoJobSeeker(JobseekerSignupReq user);
  Future<Either> additionalUserInfoCompany(CompanySignupReq user);
  Future<Either> forgotPassword(String email);
  Future<Either> signin(UserSigninReq user);
  Future<Either> signInWithGoogle(String role);
  Future<Either> getCurrentUser();
  Future<Either> signOut();
}

class AuthFirebaseServiceImpl extends AuthFirebaseService {
  @override
  Future<Either> signup(UserSignupReq user) async {
    try {
      var returnedData = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: user.email,
            password: user.password!,
          );

      final User? userReturned = returnedData.user;

      if (userReturned != null && !userReturned.emailVerified) {
        await userReturned.sendEmailVerification();
      }

      return const Right(true);
    } on FirebaseAuthException catch (e) {
      String message = '';

      if (e.code == 'weak-password') {
        message = 'Password terlalu lemah!';
      } else if (e.code == 'email-already-in-use') {
        message = 'Email telah digunakan!';
      } else {
        message = "Harap masukkan data diri dengan teliti";
      }
      return Left(message);
    }
  }

  @override
  Future<Either> resendVerificationEmail() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;

      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
      return const Right(
        'Verification email has been sent again. Please check your inbox.',
      );
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'too-many-requests') {
        message =
            'You have requested a verification email too recently. Please try again later.';
      } else {
        message = 'An error occurred: ${e.message ?? 'Unknown error'}';
      }
      return Left(message);
    }
  }

  @override
  Future<Either> additionalUserInfoJobSeeker(JobseekerSignupReq user) async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      var currentUser = FirebaseAuth.instance.currentUser;

      Map<String, dynamic> data = user.toJobseekerModel().toMap();
      data['user_id'] = currentUser?.uid;

      //dihapus dari entitas Unrole
      await firestoreInstance
          .collection("Unrole")
          .doc(currentUser?.uid)
          .delete();

      await firestoreInstance
          .collection('Jobseeker')
          .doc(currentUser?.uid)
          .set(data);
      return const Right('Sign up was successfull');
    } on FirebaseException catch (e) {
      return Left(e.message ?? 'A Firebase error occurred.');
    } catch (e) {
      return Left('An unexpected error occurred: ${e.toString()}');
    }
  }

  @override
  Future<Either> additionalUserInfoCompany(CompanySignupReq user) async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      var currentUser = FirebaseAuth.instance.currentUser;

      Map<String, dynamic> data = user.toCompanyModel().toMap();
      data['user_id'] = currentUser?.uid;

      //dihapus dari entitas Unrole
      await firestoreInstance
          .collection("Unrole")
          .doc(currentUser?.uid)
          .delete();

      await firestoreInstance
          .collection('Company')
          .doc(currentUser?.uid)
          .set(data);

      // final companyEntity = user.toCompanyEntity();
      // final updatedUser = companyEntity.copyWith(userId: currentUser?.uid);
      // user.role == "Jobseeker"
      //     ? await firestoreInstance
      //           .collection('Jobseeker')
      //           .doc(user.userId)
      //           .set(updatedUser.toMap())
      //     : await firestoreInstance
      //           .collection('Company')
      //           .doc(user.userId)
      //           .set(updatedUser.toMap());
      return const Right('Sign up was successfull');
    } on FirebaseException catch (e) {
      return Left(e.message ?? 'A Firebase error occurred.');
    } catch (e) {
      return Left('An unexpected error occurred: ${e.toString()}');
    }
  }

  @override
  Future<Either> forgotPassword(String email) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    try {
      await auth.sendPasswordResetEmail(email: email);

      return Right('Email reset password berhasil dikirim ke $email.');
    } on FirebaseAuthException catch (e) {
      String message = 'Gagal mengirim email reset password.';

      if (e.code == 'user-not-found') {
        message = 'Tidak ada pengguna yang terdaftar dengan email ini.';
      } else if (e.code == 'invalid-email') {
        message = 'Format email tidak valid.';
      } else {
        message = e.message ?? 'Gagal mengirim email reset password.';
      }

      return Left(message);
    } catch (e) {
      return Left('Terjadi kesalahan tak terduga: ${e.toString()}');
    }
  }

  @override
  Future<Either> signin(UserSigninReq user) async {
    try {
      DocumentSnapshot userDoc;
      final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: user.email,
            password: user.password,
          );

      final userId = userCredential.user?.uid;

      if (userId == null) {
        return const Left('User ID tidak ditemukan setelah login.');
      }

      final querySnapshot = await firestoreInstance
          .collection('Jobseeker')
          .where('email', isEqualTo: user.email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        userDoc = querySnapshot.docs.first;
        return Right([userDoc.data(), "Jobseeker"]);
      } else {
        final companySnapshot = await firestoreInstance
            .collection('Company')
            .where('email', isEqualTo: user.email)
            .limit(1)
            .get();

        if (companySnapshot.docs.isNotEmpty) {
          userDoc = companySnapshot.docs.first;
          return Right([userDoc.data(), "Company"]);
        } else {
          return const Left('Gagal mengambil data pengguna setelah login.');
        }
      }
      // final querySnapshot = await firestoreInstance
      //     .collection('Jobseeker')
      //     .where('email', isEqualTo: user.email)
      //     .limit(1)
      //     .get();

      // if (querySnapshot.docs.isNotEmpty) {
      //   userDoc = querySnapshot.docs.first;
      //   return Right(userDoc.data());
      // } else {
      //   final companySnapshot = await firestoreInstance
      //       .collection('Company')
      //       .where('email', isEqualTo: user.email)
      //       .limit(1)
      //       .get();

      //   if (companySnapshot.docs.isNotEmpty) {
      //     userDoc = companySnapshot.docs.first;
      //     return Right(userDoc.data());
      //   } else {
      //     return const Left('Gagal mengambil data pengguna setelah login.');
      //   }
      // }
    } on FirebaseAuthException catch (e) {
      String message = 'Login gagal.';

      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        message = 'Email atau kata sandi salah.';
      } else if (e.code == 'invalid-email') {
        message = 'Format email tidak valid.';
      } else if (e.code == 'user-disabled') {
        message = 'Akun pengguna ini telah dinonaktifkan.';
      } else {
        message = e.message ?? 'Gagal login karena kesalahan tak terduga.';
      }
      return Left(message);
    } catch (e) {
      return Left('Terjadi kesalahan umum: ${e.toString()}');
    }
  }

  @override
  Future<Either> signInWithGoogle(String role) async {
    try {
      //initialisasi
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
      final FirebaseAuth authInstance = FirebaseAuth.instance;
      DocumentSnapshot userDoc;

      //proses auth dengan google
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        return const Left('Proses login Google dibatalkan oleh pengguna.');
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential = await authInstance
          .signInWithCredential(credential);

      //cek ketersedian user di db
      final User? currentUser = userCredential.user;
      final querySnapshot = await firestoreInstance
          .collection('Jobseeker')
          .where('email', isEqualTo: currentUser!.email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        userDoc = querySnapshot.docs.first;
        //user lama
        // return Right(false);
        return Right([userDoc.data(), "Jobseeker"]);
      } else {
        final companySnapshot = await firestoreInstance
            .collection('Company')
            .where('email', isEqualTo: currentUser.email)
            .limit(1)
            .get();

        if (companySnapshot.docs.isNotEmpty) {
          userDoc = companySnapshot.docs.first;
          //user lama
          // return Right(false);
          return Right([userDoc.data(), "Company"]);
        } else {
          //user baru
          final newUserData = {
            'user_id': currentUser.uid,
            'email': currentUser.email?.toLowerCase() ?? googleUser.email,
            'name': currentUser.displayName,
            'role': role,
            'created_at': Timestamp.now(),
            'profileImage': currentUser.photoURL ?? '',
            'bio': '',
            'cv_file_path': '',
            'skill_sumarry': '',
            'experience_sumarry': '',
            'status_employment': '',
            'courses_score': 0,
            'competitions_onprogress': <String>[],
            'competitions_done': <String>[],
            'finished_module': <String>[],
          };
          await FirebaseFirestore.instance
              .collection(role)
              .doc(currentUser.uid)
              .set(newUserData);
          // return Right(true);
          return Right([newUserData, role]);
        }
      }
    } on FirebaseAuthException catch (e) {
      return Left('Login Google gagal: ${e.message}');
    } on Exception catch (e) {
      return Left('Kesalahan pada layanan Google: ${e.toString()}');
    }
  }

  @override
  Future<Either> getCurrentUser() async {
    try {
      final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
      var currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        debugPrint("Tidak ada pengguna yang login (currentUser is null)");
        return const Left('Unauthenticated');
      }
      DocumentSnapshot userDoc;

      debugPrint(currentUser.uid);
      userDoc = await firestoreInstance
          .collection('Jobseeker')
          .doc(currentUser.uid)
          .get();

      if (userDoc.exists) {
        return Right([userDoc.data(), "Jobseeker"]);
      }

      userDoc = await firestoreInstance
          .collection('Company')
          .doc(currentUser.uid)
          .get();

      if (userDoc.exists) {
        return Right([userDoc.data(), "Company"]);
      }

      userDoc = await firestoreInstance
          .collection('Unrole')
          .doc(currentUser.uid)
          .get();

      if (userDoc.exists) {
        return Right([userDoc.data(), "Unrole"]);
      } else {
        return const Left('Gagal mengambil data pengguna setelah login.');
      }
      // userDoc = await firestoreInstance
      //     .collection('Jobseeker')
      //     .doc(currentUser?.uid)
      //     .get();

      // if (!userDoc.exists) {
      //   userDoc = await firestoreInstance
      //       .collection('Company')
      //       .doc(currentUser?.uid)
      //       .get();
      // }
      // if (!userDoc.exists) {
      //   userDoc = await firestoreInstance
      //       .collection('Unrole')
      //       .doc(currentUser?.uid)
      //       .get();
      // }

      // if (!userDoc.exists) {
      //   return const Left('Gagal mengambil data pengguna setelah login.');
      // }

      // return Right(userDoc.data());
    } catch (e) {
      return Left('Kesalahan saat mengambil data pengguna: $e');
    }
  }

  @override
  Future<Either> signOut() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      await googleSignIn.signOut();
      await auth.signOut();

      return Right("Logout Success");
    } catch (e) {
      return Left('Kesalahan saat logout: $e');
    }
  }
}
