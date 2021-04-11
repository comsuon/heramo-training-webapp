class ResultTotal {
  final int courseId;
  final List<int> employeeIdList;
  ResultTotal({this.courseId, this.employeeIdList});

  factory ResultTotal.fromSheet(Map<String, dynamic> json) {
    return ResultTotal(
        courseId: int.tryParse(json['courseId'] ?? ''),
        employeeIdList: json['employeeIdList'].toString().split(',').toList().map((e) => int.tryParse(e))
        );
  }
}