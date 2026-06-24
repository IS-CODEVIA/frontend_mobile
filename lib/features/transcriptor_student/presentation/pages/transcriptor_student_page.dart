import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/header_students.dart';
import '../../../../shared/widgets/nabvar_students.dart'; 
import '../../../../shared/widgets/subject_bottom_nav.dart'; 

import '../riverpod/transcription_riverpod.dart';
import '../widgets/live_status_indicator.dart';
import '../widgets/transcription_box.dart';

class TranscriptorStudentPage extends ConsumerWidget {
  final String subjectName;

  const TranscriptorStudentPage({super.key, required this.subjectName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final transcriptionMessages = ref.watch(transcriptionProvider);

    return Scaffold(
      drawer: const NavbarStudents(), 
      bottomNavigationBar: const SubjectBottomNav(),

      body: Column(
        children: [
          const HeaderStudents(),
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  
                  // Título de la materia
                  Text(
                    subjectName,
                    style: textTheme.headlineMedium?.copyWith(
                      color: colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
              
                  const LiveStatusIndicator(),
                  const SizedBox(height: 16),
                  
                 
                  Expanded(
                    child: TranscriptionBox(messages: transcriptionMessages),
                  ),
                  
                  // Botón para pedir la palabra (Levantar la mano)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                      child: IconButton(
                        icon: const Icon(Icons.back_hand_outlined),
                        color: colorScheme.onSurface,
                        iconSize: 32,
                        onPressed: () {
                          // Acción de levantar la mano
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}