import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/notice_model.dart';

final noticesProvider = Provider<List<NoticeModel>>((ref) {
  return [
    NoticeModel(
      id: '1',
      authorName: 'Horacio Solis',
      date: '10 jun 2026',
      message: 'Mañana no habra sesion, estare fuera de la universidad',
    ),
    NoticeModel(
      id: '2',
      authorName: 'Ali Lopez',
      date: '10 jun 2026',
      message: 'La sesion comenzara a las 7:30',
    ),
  ];
});