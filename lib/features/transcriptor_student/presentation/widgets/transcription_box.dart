import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../riverpod/transcription_riverpod.dart';
import '../../domain/models/transcription_message.dart';

class TranscriptionBox extends StatefulWidget {
  final List<TranscriptionMessage> messages;
  final String? partialText;
  final TranscriptionConnectionState connectionState;

  const TranscriptionBox({
    super.key,
    required this.messages,
    this.partialText,
    this.connectionState = TranscriptionConnectionState.disconnected,
  });

  @override
  State<TranscriptionBox> createState() => _TranscriptionBoxState();
}

class _TranscriptionBoxState extends State<TranscriptionBox> {
  final _scrollController = ScrollController();
  var _autoScroll = true;

  @override
  void didUpdateWidget(TranscriptionBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.messages.length > oldWidget.messages.length ||
        widget.partialText != oldWidget.partialText) {
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    if (!_autoScroll || !_scrollController.hasClients) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _showFullscreen(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: _FullscreenTranscription(
          initialMessages: widget.messages,
          initialPartial: widget.partialText,
          initialConnection: widget.connectionState,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.secondary,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              if (widget.connectionState ==
                  TranscriptionConnectionState.connecting)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Conectando...',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                )
              else
                const Spacer(),
              if (widget.messages.isNotEmpty ||
                  widget.partialText != null)
                IconButton(
                  icon: Icon(Icons.fullscreen_rounded,
                      size: 20, color: colorScheme.primary),
                  visualDensity: VisualDensity.compact,
                  tooltip: 'Ver en pantalla completa',
                  onPressed: () => _showFullscreen(context),
                ),
            ],
          ),
          if (widget.connectionState ==
                  TranscriptionConnectionState.disconnected &&
              widget.messages.isEmpty)
            Expanded(
              child: Center(
                child: Text(
                  'Esperando transcripción...',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            )
          else
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is UserScrollNotification) {
                    if (notification.direction == ScrollDirection.reverse) {
                      _autoScroll = true;
                    } else if (notification.direction ==
                        ScrollDirection.forward) {
                      _autoScroll = false;
                    }
                  }
                  return false;
                },
                child: ListView.separated(
                  controller: _scrollController,
                  itemCount:
                      widget.messages.length + (widget.partialText != null ? 1 : 0),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    if (index == widget.messages.length &&
                        widget.partialText != null) {
                      return _buildPartial(textTheme, colorScheme);
                    }
                    final message = widget.messages[index];
                    return RichText(
                      text: TextSpan(
                        text: '${message.speaker}: ',
                        style: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        children: [
                          TextSpan(
                            text: message.text,
                            style: textTheme.bodyLarge?.copyWith(
                              color: colorScheme.secondary,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPartial(TextTheme textTheme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              'Transcribiendo...',
              style: textTheme.bodySmall?.copyWith(
                color: Colors.green,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          widget.partialText!,
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurface,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}

class _FullscreenTranscription extends ConsumerStatefulWidget {
  final List<TranscriptionMessage> initialMessages;
  final String? initialPartial;
  final TranscriptionConnectionState initialConnection;

  const _FullscreenTranscription({
    required this.initialMessages,
    this.initialPartial,
    required this.initialConnection,
  });

  @override
  ConsumerState<_FullscreenTranscription> createState() =>
      _FullscreenTranscriptionState();
}

class _FullscreenTranscriptionState
    extends ConsumerState<_FullscreenTranscription> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final tState = ref.watch(transcriptionProvider);
    final messages = tState.messages.isNotEmpty
        ? tState.messages
        : widget.initialMessages;
    final partial = tState.currentPartial ?? widget.initialPartial;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        title: Text(
          'Transcripción en vivo',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.secondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.close, color: colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: messages.isEmpty && partial == null
          ? Center(
              child: Text(
                'Esperando transcripción...',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            )
          : ListView(
              controller: _scrollController,
              padding: const EdgeInsets.all(24),
              children: [
                ...messages.map(
                  (m) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: RichText(
                      text: TextSpan(
                        text: '${m.speaker}: ',
                        style: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        children: [
                          TextSpan(
                            text: m.text,
                            style: textTheme.bodyLarge?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (partial != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Transcribiendo...',
                            style: textTheme.bodyMedium?.copyWith(
                              color: Colors.green,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        partial,
                        style: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurface,
                          fontStyle: FontStyle.italic,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
    );
  }
}
