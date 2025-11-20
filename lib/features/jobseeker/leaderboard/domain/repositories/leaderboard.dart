import 'package:dartz/dartz.dart';

abstract class LeaderboardRepository {
  Future<Either> getUserByScore();
}
