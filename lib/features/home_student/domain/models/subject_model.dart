class SubjectModel {
  final int id;
  final int courseId;
  final String title;
  final String subtitle;
  final int colorSeed;

  const SubjectModel({
    required this.id,
    required this.courseId,
    required this.title,
    required this.subtitle,
    this.colorSeed = 0,
  });
}
