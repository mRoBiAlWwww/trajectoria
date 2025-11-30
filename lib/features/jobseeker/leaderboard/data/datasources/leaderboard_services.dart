import 'package:cloud_firestore/cloud_firestore.dart';

abstract class LeaderboardServices {
  Future<List<Map<String, dynamic>>> getUserByScore();
}

class LeaderboardServicesImpl extends LeaderboardServices {
  @override
  Future<List<Map<String, dynamic>>> getUserByScore() async {
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    try {
      var competitions = await firestoreInstance
          .collection('Jobseeker')
          .orderBy('courses_score', descending: true)
          .get();

      return (competitions.docs.map((e) => e.data()).toList());
    } catch (e) {
      throw Exception('Please try again');
    }
  }
}
