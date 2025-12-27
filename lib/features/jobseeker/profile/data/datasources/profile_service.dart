import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class ProfileService {
  Future<List<Map<String, dynamic>>> getCompetitionParticipants();
  Future<Map<String, dynamic>> getCompetition(String competitionId);
  Future<List<Map<String, dynamic>>> getAnnouncementsByUserId();
  Future<String> deleteAnnouncement(String announcementId);
  Future<Map<String, dynamic>> getUserprofileInfo();
  Future<String> marksasDone(String announcementId);
}

class ProfileServiceImpl extends ProfileService {
  @override
  Future<List<Map<String, dynamic>>> getCompetitionParticipants() async {
    var currentUser = FirebaseAuth.instance.currentUser;
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

    try {
      var getCompetitionParticipants = await firestoreInstance
          .collection("Competition_participants")
          .where("user_id", isEqualTo: currentUser!.uid)
          .get();

      return getCompetitionParticipants.docs.map((e) => e.data()).toList();
    } catch (e) {
      throw Exception("Error gagal mendapatkan list partisipan kompetisi $e");
    }
  }

  @override
  Future<Map<String, dynamic>> getCompetition(String competitionId) async {
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

    try {
      var getCompetiton = await firestoreInstance
          .collection("Competitions")
          .where("competition_id", isEqualTo: competitionId)
          .get();

      return getCompetiton.docs.first.data();
    } catch (e) {
      throw Exception("Error gagal mendapatkan list partisipan kompetisi $e");
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getAnnouncementsByUserId() async {
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    var currentUser = FirebaseAuth.instance.currentUser;

    try {
      final announcements = await firestoreInstance
          .collection("Announcement")
          .where("user_id", isEqualTo: currentUser!.uid)
          .orderBy('created_announcement_at', descending: true)
          .get();

      return announcements.docs.map((e) => e.data()).toList();
    } catch (e) {
      throw Exception(
        "Error Gagal mengambil announcements dari user berdasarkan title: $e",
      );
    }
  }

  @override
  Future<String> deleteAnnouncement(String announcementId) async {
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    try {
      await firestoreInstance
          .collection("Announcement")
          .doc(announcementId)
          .delete();

      return "Announcement telah berhasil dihapus";
    } catch (e) {
      throw Exception("Error gagal menghapus Announcement $e");
    }
  }

  @override
  Future<Map<String, dynamic>> getUserprofileInfo() async {
    var currentUser = FirebaseAuth.instance.currentUser;
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

    try {
      var getCompetitionParticipants = await firestoreInstance
          .collection("Jobseeker")
          .where("user_id", isEqualTo: currentUser!.uid)
          .get();

      return getCompetitionParticipants.docs.first.data();
    } catch (e) {
      throw Exception("Error gagal mendapatkan list partisipan kompetisi $e");
    }
  }

  @override
  Future<String> marksasDone(String announcementId) async {
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    try {
      await firestoreInstance
          .collection("Announcement")
          .doc(announcementId)
          .set({"is_read": true}, SetOptions(merge: true));
      return "Announcement/notifikasi telah berhasil ditandai telah dibaca";
    } catch (e) {
      throw Exception("Announcement/notifkasi gagal ditandai telah dibaca $e");
    }
  }
}
