import 'package:gsheets/gsheets.dart';
import 'package:heramo_training_system/network/BaseApi.dart';
import 'package:heramo_training_system/network/model/course.dart';
import '../utils/constant.dart' as Constants;

class CourseApi extends BaseApi {
  final String apiCredential;
  CourseApi(this.apiCredential) : super(apiCredential);

  Future<List<Course>> getAllCourse() async { 
    await init();
    worksheet = await spreadsheet.worksheetByTitle(Constants.courseListWorkSheet);
    final courses = await worksheet.values.map.allRows(fromRow: 2);
    return courses.map((json) => Course.fromGsheet(json)).toList();
  }

  Future<Map<int, List<int>>> getResult() async {
    worksheet = await spreadsheet.worksheetByTitle(Constants.resultListWorkSheet);
    final result = await worksheet.values.map.allRows(fromRow: 2);
    var resultMap = Map<int, List<int>>();
    result.forEach((row) { 
      var courseId = int.tryParse(row['courseId']);
      var employeeIdList = row['employeeIdList'].toString().split(',').map((e) => int.tryParse(e)).toList();
      resultMap[courseId] = employeeIdList;
    });
    return resultMap;
  }

}
