import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:trajectoria/features/authentication/data/models/company_signup_req.dart';
import 'package:trajectoria/features/authentication/data/models/jobseeker_signup_req.dart';
import 'package:trajectoria/features/authentication/data/models/user_signin_req.dart';
import 'package:trajectoria/features/authentication/data/models/user_signup_req.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthFirebaseService {
  Future<String> signup(UserSignupReq user);
  Future<String> resendVerificationEmail();
  Future<String> additionalUserInfoJobSeeker(JobseekerSignupReq user);
  Future<String> additionalUserInfoCompany(CompanySignupReq user);
  Future<String> forgotPassword(String email);
  Future<(Map<String, dynamic>, String)> signin(UserSigninReq user);
  Future<(Map<String, dynamic>, String)> signInWithGoogle(String role);
  Future<(Map<String, dynamic>, String)> getCurrentUser();
  Future<String> signOut();
}

class AuthFirebaseServiceImpl extends AuthFirebaseService {
  @override
  Future<String> signup(UserSignupReq user) async {
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

      return "Signup berhasil";
    } on FirebaseAuthException catch (e) {
      throw Exception(_firebaseErrorMessage(e));
    } catch (_) {
      throw Exception("Harap masukkan data diri dengan teliti");
    }
  }

  @override
  Future<String> resendVerificationEmail() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;

      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
      return "Verifikasi email telah terkirim. Silahkan cek kotak masuk mu";
    } on FirebaseAuthException catch (e) {
      throw Exception(_firebaseErrorMessage(e));
    } catch (_) {
      throw Exception("Harap masukkan data diri dengan teliti");
    }
  }

  @override
  Future<String> additionalUserInfoJobSeeker(JobseekerSignupReq user) async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      var currentUser = FirebaseAuth.instance.currentUser;

      Map<String, dynamic> data = user.toJobseekerModel().toMap();
      data["user_id"] = currentUser?.uid;

      //dihapus dari entitas Unrole
      await firestoreInstance
          .collection("Unrole")
          .doc(currentUser?.uid)
          .delete();

      await firestoreInstance
          .collection("Jobseeker")
          .doc(currentUser?.uid)
          .set(data);
      return "Signup telah berhasil";
    } on FirebaseAuthException catch (e) {
      return _firebaseErrorMessage(e);
    } on FirebaseException catch (e) {
      throw Exception("Terjadi kesalahan saat mengakses menyimpan data: $e");
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  @override
  Future<String> additionalUserInfoCompany(CompanySignupReq user) async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      var currentUser = FirebaseAuth.instance.currentUser;

      Map<String, dynamic> data = user.toCompanyModel().toMap();
      data["user_id"] = currentUser?.uid;

      //dihapus dari entitas Unrole
      await firestoreInstance
          .collection("Unrole")
          .doc(currentUser?.uid)
          .delete();

      await firestoreInstance
          .collection("Company")
          .doc(currentUser?.uid)
          .set(data);

      return "Signup telah berhasil";
    } on FirebaseAuthException catch (e) {
      return _firebaseErrorMessage(e);
    } on FirebaseException catch (e) {
      throw Exception("Terjadi kesalahan saat  menyimpan data: $e");
    } catch (e) {
      throw Exception("Terjadi kesalahan tak terduga: $e");
    }
  }

  @override
  Future<String> forgotPassword(String email) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    try {
      await auth.sendPasswordResetEmail(email: email);

      return "Email reset password berhasil dikirim ke $email";
    } on FirebaseAuthException catch (e) {
      return _firebaseErrorMessage(e);
    } catch (e) {
      throw Exception("Terjadi kesalahan tak terduga: $e");
    }
  }

  @override
  Future<(Map<String, dynamic>, String)> signin(UserSigninReq user) async {
    try {
      final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: user.email,
            password: user.password,
          );

      final userId = userCredential.user?.uid;

      if (userId == null) {
        throw Exception("User ID tidak ditemukan setelah login");
      }

      final querySnapshot = await firestoreInstance
          .collection("Jobseeker")
          .where("email", isEqualTo: user.email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return (querySnapshot.docs.first.data(), "Jobseeker");
      } else {
        final companySnapshot = await firestoreInstance
            .collection("Company")
            .where("email", isEqualTo: user.email)
            .limit(1)
            .get();

        if (companySnapshot.docs.isNotEmpty) {
          return (companySnapshot.docs.first.data(), "Company");
        } else {
          throw Exception("Gagal mengambil data pengguna setelah login");
        }
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(_firebaseErrorMessage(e));
    }
  }

  @override
  Future<(Map<String, dynamic>, String)> signInWithGoogle(String role) async {
    try {
      //initialisasi
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
      final FirebaseAuth authInstance = FirebaseAuth.instance;

      //proses auth dengan google
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception("Proses login Google dibatalkan oleh pengguna");
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

      if (currentUser == null) {
        throw Exception("User Google tidak ditemukan.");
      }

      final jobseekerSnapshot = await firestoreInstance
          .collection("Jobseeker")
          .where("email", isEqualTo: currentUser.email)
          .limit(1)
          .get();

      if (jobseekerSnapshot.docs.isNotEmpty) {
        //user lama
        return (jobseekerSnapshot.docs.first.data(), "Jobseeker");
      } else {
        final companySnapshot = await firestoreInstance
            .collection("Company")
            .where("email", isEqualTo: currentUser.email)
            .limit(1)
            .get();

        if (companySnapshot.docs.isNotEmpty) {
          //user lama
          return (companySnapshot.docs.first.data(), "Company");
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
          return (newUserData, role);
        }
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(_firebaseErrorMessage(e));
    } on Exception catch (e) {
      throw Exception("Kesalahan pada layanan Google: $e");
    }
  }

  @override
  Future<(Map<String, dynamic>, String)> getCurrentUser() async {
    try {
      final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
      var currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception("Unauthenticated");
      }

      debugPrint(currentUser.uid);
      final jobseekerUserDoc = await firestoreInstance
          .collection("Jobseeker")
          .doc(currentUser.uid)
          .get();

      if (jobseekerUserDoc.exists) {
        return (jobseekerUserDoc.data()!, "Jobseeker");
      }

      final companyUserDoc = await firestoreInstance
          .collection("Company")
          .doc(currentUser.uid)
          .get();

      if (companyUserDoc.exists) {
        return (companyUserDoc.data()!, "Company");
      }

      final unroleUserDoc = await firestoreInstance
          .collection("Unrole")
          .doc(currentUser.uid)
          .get();

      if (unroleUserDoc.exists) {
        return (unroleUserDoc.data()!, "Unrole");
      }
      throw Exception("Data pengguna tidak ditemukan");
    } on FirebaseException catch (e) {
      throw Exception("Kesalahan saat mengambil data pengguna: $e");
    } catch (e) {
      throw Exception("Terjadi kesalahan tak terduga: $e");
    }
  }

  @override
  Future<String> signOut() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      await googleSignIn.signOut();
      await auth.signOut();

      return "Logout Success";
    } catch (e) {
      throw Exception("Kesalahan saat logout: $e");
    }
  }

  String _firebaseErrorMessage(FirebaseAuthException e) {
    if (e.code == "weak-password") return "Password terlalu lemah!";
    if (e.code == "email-already-in-use") return "Email telah digunakan!";
    if (e.code == "user-not-found" || e.code == "wrong-password") {
      return "Email atau kata sandi salah.";
    }
    if (e.code == "invalid-email") {
      return "Format email tidak valid.";
    }
    if (e.code == "user-disabled") {
      return "Akun ini telah dinonaktifkan.";
    }
    if (e.code == "too-many-requests") {
      return "Kamu telah meminta permintaan verifikasi email terlalu sering baru-baru ini. Coba lagi nanti.";
    }
    if (e.code == "wrong-password") {
      return "Email atau password salah.";
    }
    return e.message ?? "Kesalahan authentikasi tak terduga.";
  }
}
