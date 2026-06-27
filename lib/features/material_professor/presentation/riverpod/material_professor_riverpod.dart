import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/app_container.dart';
import '../../../../features/home_professor/presentation/riverpod/home_professor_riverpod.dart';
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
    NotifierProvider<MaterialsProfessorNotifier, List<MaterialEntity>>(
  MaterialsProfessorNotifier.new,
);

final materialsProfessorForCourseProvider =
    Provider.family<List<MaterialEntity>, String>((ref, subjectName) {
  final all = ref.watch(materialsProfessorProvider);
  return all;
});

class MaterialsProfessorNotifier extends Notifier<List<MaterialEntity>> {
  @override
  List<MaterialEntity> build() => [];

  int? _findCourseId(String subjectName) {
    final courses = ref.read(professorSubjectsProvider);
    try {
      return courses.firstWhere((c) => c.courseName == subjectName).courseId;
    } catch (_) {
      return null;
    }
  }

  Future<void> loadMaterials(String subjectName) async {
    final courseId = _findCourseId(subjectName);
    if (courseId == null) return;

    try {
      final materials = await ref.read(_getMaterialsUsecaseProvider)(
        courseId: courseId,
      );
      state = materials;
    } catch (_) {}
  }

  Future<MaterialEntity?> createMaterial({
    required String subjectName,
    required String title,
    required String fileUrl,
    String? description,
    required String fileType,
  }) async {
    final courseId = _findCourseId(subjectName);
    if (courseId == null) return null;

    try {
      final material = await ref.read(_createMaterialUsecaseProvider)(
        courseId: courseId,
        title: title,
        fileUrl: fileUrl,
        description: description,
        fileType: fileType,
      );
      state = [...state, material];
      return material;
    } catch (_) {
      return null;
    }
  }
}
