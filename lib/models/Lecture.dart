class Lecture{

  final String createdAt;
  final List attendees;
  final String duration;
  final String courseId;
  final String courseName;
  final String courseCode;
  final String id;
  final String session;
  final String semester;

  Lecture({this.createdAt, this.attendees, this.duration, this.courseId,
      this.courseName, this.courseCode, this.id, this.session, this.semester});

  factory Lecture.fromJson(Map<String, dynamic> json){
    return Lecture(
      id: json['id'],
      createdAt: json['created_at'],
      attendees: json['attendees'],
      duration: json['duration'],
      courseId: json['course_id'],
      courseName: json['course_name'],
      courseCode: json['course_code'],
      session: json['session'],
      semester: json['semester']
    );
  }
}