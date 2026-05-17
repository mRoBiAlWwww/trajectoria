import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:trajectoria/features/jobseeker/learn/presentation/cubit/hydrated_course_cubit.dart';

import '../../helpers/test_helpers.dart';

void main() {
  setUpAll(() async {
    final dir = await Directory.systemTemp.createTemp();
    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: dir,
    );
  });

  test('can set and clear course', () {
    final cubit = HydratedSelectedCourseCubit();
    final course = buildCourseEntity();

    expect(cubit.state, isNull);
    cubit.setCourse(course);
    expect(cubit.state, isNotNull);

    cubit.clearCourse();
    expect(cubit.state, isNull);
  });

  test('serializes and restores course', () {
    final cubit = HydratedSelectedCourseCubit();
    final course = buildCourseEntity();

    final json = cubit.toJson(course);
    final restored = cubit.fromJson(json!);

    expect(restored?.courseId, course.courseId);
  });
}
