class PersonDetailEntity {
  final int userId;
  final String name;
  final String email;

  const PersonDetailEntity({
    required this.userId,
    required this.name,
    required this.email,
  });
}

class CourseDetailEntity {
  final PersonDetailEntity teacher;
  final List<PersonDetailEntity> students;

  const CourseDetailEntity({
    required this.teacher,
    required this.students,
  });
}
