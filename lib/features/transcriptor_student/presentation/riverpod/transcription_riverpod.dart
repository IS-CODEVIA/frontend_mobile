import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/transcription_message.dart';

final transcriptionProvider = Provider<List<TranscriptionMessage>>((ref) {
  return [
    TranscriptionMessage(
      speaker: 'Horacio',
      text: 'El deep learning es muy interesante, ya que a sus inicios era muy utilizado por los científicos de datos',
    ),
  ];
});