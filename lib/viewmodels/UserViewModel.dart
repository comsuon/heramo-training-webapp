import 'package:flutter/material.dart';

import 'package:heramo_training_system/network/CourseApi.dart';
import 'package:heramo_training_system/network/model/course.dart';

import '../utils/sheet_credential.dart' as Credential;
import '../utils/strings.dart' as Strings;

class UserViewModel extends ChangeNotifier {
  String _name = "";
  String _ref = "";
  int _roleId = 0;
  CourseApi _courseApi;

  UserViewModel() {
    _courseApi ??= CourseApi(Credential.sheetCredentials);
  }

  String get name => _name;
  String get ref => _ref;
  int get roleId => _roleId;
  CourseApi get courseApi => _courseApi;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _error = "";
  String get error => _error;

  Future<List<Course>> login(String name, String ref, int roleId) async {
    List<Course> resultList = [];
    _isLoading = true;
    _error = "";
    notifyListeners();

    String validateResult = _validate(name, ref, roleId);
    if (validateResult.isNotEmpty) {
      _error = validateResult;
      _isLoading = false;
      notifyListeners();
      return List.empty();
    }

    try {
      final courses = await _courseApi.getAllCourse();
      _isLoading = false;

      var courseForRole =
          courses.where((element) => element.roles.contains(roleId)).toList();

      if (courseForRole.length == 0) {
        _error = Strings.error_no_courses;
      } else {
        _error = '';
        _name = name;
        _ref = ref;
        _roleId = roleId;
        final resultTotal = await _courseApi.getResult();
        if (resultTotal != null) {
          courseForRole.forEach((course) {
            if (resultTotal[course.id] != null && resultTotal[course.id].contains(int.tryParse(_ref))) {
              course.completed = true;
            } else {
              course.completed = false;
            }
          });
          resultList.addAll(courseForRole);
        }
      }
    } catch (e) {
      _error = Strings.error_getting_courses;
      _isLoading = false;
    } finally {
      notifyListeners();
    }

    return resultList;
  }

  String _validate(String name, String ref, int roleId) {
    if (name.isEmpty) {
      return Strings.error_missing_name;
    } else if (ref.isEmpty) {
      return Strings.error_missing_ref;
    } else if (roleId < 1) {
      return Strings.error_missing_roleid;
    } else {
      return "";
    }
  }
}
