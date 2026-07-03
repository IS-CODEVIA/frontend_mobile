import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/header_students.dart';
import '../../../../shared/widgets/nabvar_students.dart';
import '../../../../shared/widgets/subject_bottom_nav.dart';

import '../riverpod/transcription_riverpod.dart';
import '../widgets/live_status_indicator.dart';
import '../widgets/transcription_box.dart';
import '../widgets/chat_sheet.dart';

class TranscriptorStudentPage extends ConsumerStatefulWidget {
  final String subjectName;
  final int courseId;

  const TranscriptorStudentPage({
    super.key,
    required this.subjectName,
    required this.courseId,
  });

  @override
  ConsumerState<TranscriptorStudentPage> createState() =>
      _TranscriptorStudentPageState();
}

class _TranscriptorStudentPageState
    extends ConsumerState<TranscriptorStudentPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(transcriptionProvider.notifier).connect(widget.courseId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final tState = ref.watch(transcriptionProvider);
    final notifier = ref.read(transcriptionProvider.notifier);

    if (tState.error != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifier.clearError();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(tState.error!),
            backgroundColor: colorScheme.error,
          ),
        );
      });
    }

    final displayMessages = tState.messages;
    final partial = tState.currentPartial;

    return Scaffold(
      drawer: const NavbarStudents(),
      bottomNavigationBar: SubjectBottomNav(
        subjectName: widget.subjectName,
        courseId: widget.courseId,
      ),
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
                  Text(
                    widget.subjectName,
                    style: textTheme.headlineMedium?.copyWith(
                      color: colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const LiveStatusIndicator(),
                  const SizedBox(height: 16),
                  Expanded(
                    child: TranscriptionBox(
                      messages: displayMessages,
                      partialText: partial,
                      connectionState: tState.connectionState,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 16.0, bottom: 8.0),
                      child: IconButton(
                        icon: const Icon(Icons.back_hand_outlined),
                        color: colorScheme.onSurface,
                        iconSize: 32,
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => const ChatSheet(),
                          );
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
