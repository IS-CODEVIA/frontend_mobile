enum ClassRole {
  teacher,
  student,
}

class PersonModel {
  final String id;
  final String name;
  final String subtitle;
  final ClassRole role;
  final String? avatarUrl;

  PersonModel({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.role,
    this.avatarUrl,
  });
}
