enum MaterialItemType {
  transcription,
  document, // Para archivos subidos por el docente
}

class MaterialItemModel {
  final String id;
  final String title;
  final String description;
  final String date;
  final MaterialItemType type;

  MaterialItemModel({
    required this.id,
    required this.title,
    this.description = '',
    required this.date,
    required this.type,
  });
}

class UnitMaterialsModel {
  final String unitName;
  final List<MaterialItemModel> materials;

  UnitMaterialsModel({
    required this.unitName,
    required this.materials,
  });
}