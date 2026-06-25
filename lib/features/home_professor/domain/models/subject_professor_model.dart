class SubjectProfessorModel {
  final String id;
  final String title;
  final String subtitle;
  final String professorName;
  final int enrolledStudents;
  final int colorSeed;

  const SubjectProfessorModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.professorName,
    required this.enrolledStudents,
    this.colorSeed = 0,
  });
}
