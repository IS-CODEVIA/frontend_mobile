import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/material_model.dart';

class MaterialsNotifier extends Notifier<List<UnitMaterialsModel>> {
  @override
  List<UnitMaterialsModel> build() {
    return [
      UnitMaterialsModel(
        unitName: 'Unidad 1',
        materials: [
          MaterialItemModel(
            id: '1',
            title: 'Exploracion de datos',
            description: 'Técnicas de exploración y visualización de datos para identificar patrones y anomalías en el conjunto de datos.',
            date: '10 jun 2026',
            type: MaterialItemType.transcription,
            unitName: 'Unidad 1',
            content: 'En esta sesión exploramos técnicas de análisis exploratorio de datos (EDA). Revisamos distribuciones, correlaciones y valores atípicos utilizando herramientas de visualización como histogramas, box plots y scatter plots. Se discutieron métodos para identificar relaciones entre variables y cómo preparar los datos para modelos posteriores.',
          ),
          MaterialItemModel(
            id: '2',
            title: 'Presentación Kmeans',
            description: 'Diapositivas sobre el algoritmo de clustering K-Means, incluyendo ejemplos prácticos.',
            date: '12 jun 2026',
            type: MaterialItemType.document,
            unitName: 'Unidad 1',
            content: 'Presentación sobre el algoritmo K-Means. Cubre: selección de K, inicialización de centroides, asignación de clusters, actualización de centroides, criterio de convergencia, y evaluación de resultados con el método del codo y silueta.',
          ),
        ],
      ),
      UnitMaterialsModel(
        unitName: 'Unidad 2',
        materials: [],
      ),
    ];
  }

  void addMaterial(String unitName, MaterialItemModel material) {
    state = state.map((unit) {
      if (unit.unitName == unitName) {
        return UnitMaterialsModel(
          unitName: unit.unitName,
          materials: [...unit.materials, material],
        );
      }
      return unit;
    }).toList();
  }

  void createUnit(String unitName) {
    if (state.any((u) => u.unitName == unitName)) return;
    state = [...state, UnitMaterialsModel(unitName: unitName, materials: [])];
  }
}

final materialsProvider =
    NotifierProvider<MaterialsNotifier, List<UnitMaterialsModel>>(
  MaterialsNotifier.new,
);
