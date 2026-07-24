import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/app_container.dart';
import '../../di/material_professor_di.dart';
import '../../domain/entities/material_entity.dart';
import '../../domain/usecases/create_material_usecase.dart';
import '../../domain/usecases/get_materials_usecase.dart';

final _materialProfessorDIProvider = Provider<MaterialProfessorDI>((ref) {
  return MaterialProfessorDI(ref.watch(appContainerProvider)!);
});

final _getMaterialsUsecaseProvider = Provider<GetMaterialsUsecase>((ref) {
  return ref.watch(_materialProfessorDIProvider).getMaterialsUsecase;
});

final _createMaterialUsecaseProvider = Provider<CreateMaterialUsecase>((ref) {
  return ref.watch(_materialProfessorDIProvider).createMaterialUsecase;
});

final materialsProfessorProvider =
    AsyncNotifierProvider<MaterialsProfessorNotifier, Map<int, List<MaterialEntity>>>(
  MaterialsProfessorNotifier.new,
);

final materialsByCourseIdProvider =
    Provider.family<AsyncValue<List<MaterialEntity>>, int>((ref, courseId) {
  final all = ref.watch(materialsProfessorProvider);
  final map = all.asData?.value;
  if (map == null) return const AsyncValue.loading();
  final list = map[courseId];
  if (list == null) return const AsyncValue.loading();
  return AsyncValue.data(list);
});

class MaterialsProfessorNotifier
    extends AsyncNotifier<Map<int, List<MaterialEntity>>> {
  @override
  Future<Map<int, List<MaterialEntity>>> build() async => {};

  Future<void> loadMaterials(int courseId) async {
    try {
      final materials = await ref.read(_getMaterialsUsecaseProvider)(
        courseId: courseId,
      );
      materials.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      state = AsyncValue.data({...state.asData?.value ?? {}, courseId: materials});
    } catch (_) {}
  }

  Future<MaterialEntity?> createMaterial({
    required int courseId,
    required String title,
    required String fileUrl,
    String? description,
    required String fileType,
  }) async {
    try {
      final material = await ref.read(_createMaterialUsecaseProvider)(
        courseId: courseId,
        title: title,
        fileUrl: fileUrl,
        description: description,
        fileType: fileType,
      );
      final currentMap = state.asData?.value ?? {};
      final current = currentMap[courseId] ?? [];
      state = AsyncValue.data({...currentMap, courseId: [...current, material]});
      return material;
    } catch (_) {
      return null;
    }
  }
}
