class Course {
  Course(
      {this.id,
      this.coursename,
      this.courseLink,
      this.courseTestLink,
      this.roles});

  final int id;
  final String coursename;
  final String courseLink;
  final String courseTestLink;
  final List<int> roles;

  bool completed = false;

  factory Course.fromGsheet(Map<String, dynamic> json) {
    return Course(
        id: int.tryParse(json['id'] ?? ''),
        coursename: json['courseName'] ?? '',
        courseLink: json['courseLink'] ?? '',
        courseTestLink: json['courseTest'] ?? '',
        roles: json['roles'].toString().split(",").map((e) => int.tryParse(e)).toList()
        );
  }

  Map toGsheet() {
    return {
      id: id,
      coursename: coursename,
      courseLink: courseLink,
      courseTestLink: courseTestLink
    };
  }
  @override
    String toString() {
    
      return "Course name: $coursename - Completed: ${completed.toString()}";
    }
}
