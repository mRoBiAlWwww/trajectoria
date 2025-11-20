import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

abstract class LeaderboardServices {
  Future<Either> getUserByScore();
}

class LeaderboardServicesImpl extends LeaderboardServices {
  @override
  Future<Either> getUserByScore() async {
    final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    try {
      var competitions = await firestoreInstance
          .collection('Jobseeker')
          .orderBy('courses_score', descending: true)
          .get();

      return Right(competitions.docs.map((e) => e.data()).toList());
    } catch (e) {
      return const Left('Please try again');
    }
  }
}
