import '../../domain/entities/course_detail_entity.dart';

class PersonDetailModel {
  final int userId;
  final String name;
  final String email;
  final int roleId;

  const PersonDetailModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.roleId,
  });

  factory PersonDetailModel.fromJson(Map<String, dynamic> json) {
    return PersonDetailModel(
      userId: json['userID'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      roleId: json['roleID'] as int? ?? 1,
    );
  }

  PersonDetailEntity toEntity() {
    return PersonDetailEntity(
      userId: userId,
      name: name,
      email: email,
    );
  }
}

class CourseDetailModel {
  final PersonDetailModel teacher;
  final List<PersonDetailModel> students;

  const CourseDetailModel({
    required this.teacher,
    required this.students,
  });

  factory CourseDetailModel.fromJson(Map<String, dynamic> json) {
    final teacherJson = json['teacher'] as Map<String, dynamic>;
    final studentsList = json['students'] as List;
    return CourseDetailModel(
      teacher: PersonDetailModel.fromJson(teacherJson),
      students: studentsList
          .map((s) => PersonDetailModel.fromJson(s as Map<String, dynamic>))
          .toList(),
    );
  }

  CourseDetailEntity toEntity() {
    return CourseDetailEntity(
      teacher: teacher.toEntity(),
      students: students.map((s) => s.toEntity()).toList(),
    );
  }
}
