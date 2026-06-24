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
            date: '10 jun 2026',
            type: MaterialItemType.transcription,
          ),
          MaterialItemModel(
            id: '2',
            title: 'Presentación Kmeans',
            date: '12 jun 2026',
            type: MaterialItemType.document,
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
