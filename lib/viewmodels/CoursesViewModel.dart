import 'package:flutter/material.dart';
import 'package:heramo_training_system/network/model/course.dart';

class CoursesViewModel extends ChangeNotifier {

  List<Course> _courses;

  List<Course> get courses => _courses;

  void addCourses(List<Course> courses) {
    _courses = courses;
    notifyListeners();
  }
}