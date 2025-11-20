import 'package:flutter/foundation.dart';

@immutable
abstract class HydratedProgressState {}

class HydratedProgressStateInitial extends HydratedProgressState {}

class HydratedProgressStateLoaded extends HydratedProgressState {
  final List<Map<String, dynamic>> items;
  HydratedProgressStateLoaded(this.items);
}
