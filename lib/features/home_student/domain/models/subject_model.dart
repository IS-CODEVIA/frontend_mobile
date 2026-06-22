class SubjectModel {
  final String id;
  final String title;
  final String subtitle;
  final String teacherName;
  final int colorSeed;

  const SubjectModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.teacherName,
    this.colorSeed = 0,
  });
}
