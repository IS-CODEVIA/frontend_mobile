import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/app_container.dart';
import '../../../home_professor/presentation/riverpod/home_professor_riverpod.dart';
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

final materialsProfessorProvider = NotifierProvider<
    MaterialsProfessorNotifier, Map<String, List<MaterialEntity>>>(
  MaterialsProfessorNotifier.new,
);

final materialsForSubjectProvider =
    Provider.family<List<MaterialEntity>, String>((ref, subjectName) {
  final all = ref.watch(materialsProfessorProvider);
  return all[subjectName] ?? [];
});

class MaterialsProfessorNotifier
    extends Notifier<Map<String, List<MaterialEntity>>> {
  @override
  Map<String, List<MaterialEntity>> build() {
    ref.listen(professorSubjectsProvider, (_, next) {
      if (next.isNotEmpty) {
        _retryPendingLoads();
      }
    });
    return {};
  }

  int? _resolveCourseId(String subjectName) {
    final courses = ref.read(professorSubjectsProvider);
    try {
      return courses.firstWhere((c) => c.courseName == subjectName).courseId;
    } catch (_) {
      return null;
    }
  }

  void _retryPendingLoads() {
    for (final subjectName in state.keys) {
      if (state[subjectName]!.isEmpty) {
        loadMaterials(subjectName);
      }
    }
  }

  Future<void> loadMaterials(String subjectName) async {
    if (!state.containsKey(subjectName)) {
      state = {...state, subjectName: []};
    }

    final courseId = _resolveCourseId(subjectName);
    if (courseId == null) return;

    try {
      final materials = await ref.read(_getMaterialsUsecaseProvider)(
        courseId: courseId,
      );
      state = {...state, subjectName: materials};
    } catch (_) {}
  }

  Future<MaterialEntity?> createMaterial({
    required String subjectName,
    required String title,
    required String fileUrl,
    String? description,
    required String fileType,
  }) async {
    final courseId = _resolveCourseId(subjectName);
    if (courseId == null) return null;

    try {
      final material = await ref.read(_createMaterialUsecaseProvider)(
        courseId: courseId,
        title: title,
        fileUrl: fileUrl,
        description: description,
        fileType: fileType,
      );
      final current = state[subjectName] ?? [];
      state = {...state, subjectName: [...current, material]};
      return material;
    } catch (_) {
      return null;
    }
  }
}
