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
  final String unitName; // Para mostrar "Unidad 1" en el detalle
  final String content;

  MaterialItemModel({
    required this.id,
    required this.title,
    this.description = '',
    required this.date,
    required this.type,
    required this.unitName,
    required this.content,
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