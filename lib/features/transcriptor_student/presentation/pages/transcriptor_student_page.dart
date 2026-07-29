import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/responsive/responsive_utils.dart';
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
    final landscape = isLandscape(context);
    final padding = horizontalPadding(context);

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
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: responsiveSpacing(context, 16)),
                  Text(
                    widget.subjectName,
                    style: textTheme.headlineMedium?.copyWith(
                      color: colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                      fontSize: responsiveFontSize(context, landscape ? 20 : 24),
                    ),
                  ),
                  SizedBox(height: responsiveSpacing(context, 8)),
                  const LiveStatusIndicator(),
                  SizedBox(height: responsiveSpacing(context, 16)),
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
                      padding: EdgeInsets.only(top: responsiveSpacing(context, 16), bottom: 8.0),
                      child: IconButton(
                        icon: const Icon(Icons.back_hand_outlined),
                        color: colorScheme.onSurface,
                        iconSize: landscape ? 26 : 32,
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) =>
                                ChatSheet(courseId: widget.courseId),
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
