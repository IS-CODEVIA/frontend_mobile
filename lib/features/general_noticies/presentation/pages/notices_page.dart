import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/responsive/responsive_utils.dart';
import '../../../../shared/widgets/header_students.dart';
import '../../../../shared/widgets/nabvar_students.dart';

import '../riverpod/notices_riverpod.dart';
import '../widgets/notice_card.dart';

class NoticesPage extends ConsumerWidget {
  const NoticesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isSmall = MediaQuery.of(context).size.width < 360;
    final isTablet = MediaQuery.of(context).size.width >= 600;
    final padding = horizontalPadding(context);

    final notices = ref.watch(noticesProvider);

    return Scaffold(
      drawer: const NavbarStudents(),
      body: Column(
        children: [
          const HeaderStudents(),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: isTablet ? 24 : 16),
                  Row(
                    children: [
                      Icon(
                        Icons.mark_email_unread_outlined,
                        color: colorScheme.secondary,
                        size: isTablet ? 40 : isSmall ? 28 : 32,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Avisos',
                        style: textTheme.headlineMedium?.copyWith(
                          color: colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                          fontSize: responsiveFontSize(context, isSmall ? 20 : 24),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isTablet ? 32 : 24),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.only(top: 8, bottom: isTablet ? 40 : 24),
                      itemCount: notices.length,
                      itemBuilder: (context, index) {
                        return NoticeCard(notice: notices[index]);
                      },
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
