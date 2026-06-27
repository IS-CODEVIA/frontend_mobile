import '../../domain/entities/course_detail_entity.dart';

class PersonDetailModel {
  final int userId;
  final String name;
  final String email;

  const PersonDetailModel({
    required this.userId,
    required this.name,
    required this.email,
  });

  factory PersonDetailModel.fromJson(Map<String, dynamic> json) {
    return PersonDetailModel(
      userId: json['userID'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
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

  factory CourseDetailModel.fromParticipants(List<Map<String, dynamic>> participants) {
    PersonDetailModel? teacher;
    final students = <PersonDetailModel>[];
    for (final p in participants) {
      final person = PersonDetailModel.fromJson(p);
      if (p['role'] == 'teacher') {
        teacher = person;
      } else {
        students.add(person);
      }
    }
    return CourseDetailModel(
      teacher: teacher ?? PersonDetailModel(userId: 0, name: 'Unknown', email: ''),
      students: students,
    );
  }

  CourseDetailEntity toEntity() {
    return CourseDetailEntity(
      teacher: teacher.toEntity(),
      students: students.map((s) => s.toEntity()).toList(),
    );
  }
}
