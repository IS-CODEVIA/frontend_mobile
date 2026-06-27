import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/welcome_page.dart';
import '../../features/archived/presentation/pages/archived_page.dart';
import '../../features/general_noticies/presentation/pages/notices_page.dart';
import '../../features/home_student/presentation/pages/home_students_page.dart';
import '../../features/transcriptor_student/presentation/pages/transcriptor_student_page.dart';
import '../../features/assignment_notices/presentation/pages/assignment_notices_page.dart';
import '../../features/material_students/presentation/pages/material_students_page.dart';
import '../../features/people_student/presentation/pages/people_student_page.dart';
import '../../features/settings_students/presentation/pages/settings_students_page.dart';
import '../../features/archived_assignment_notices/presentation/pages/archived_assignment_notices_page.dart';
import '../../features/archived_material_students/presentation/pages/archived_material_students_page.dart';
import '../../features/archived_people_student/presentation/pages/archived_people_student_page.dart';

// Professor features
import '../../features/home_professor/presentation/pages/home_professor_page.dart';
import '../../features/assignment_notices_professor/presentation/pages/assignment_notices_professor_page.dart';
import '../../features/material_professor/presentation/pages/material_professor_page.dart';
import '../../features/transcriptor_professor/presentation/pages/transcriptor_professor_page.dart';
import '../../features/people_professor/presentation/pages/people_professor_page.dart';
import '../../features/settings_professor/presentation/pages/settings_professor_page.dart';
import '../../features/archived_professor/presentation/pages/archived_professor_page.dart';
import '../../features/archived_assignment_notices_professor/presentation/pages/archived_assignment_notices_professor_page.dart';
import '../../features/archived_material_professor/presentation/pages/archived_material_professor_page.dart';
import '../../features/archived_people_professor/presentation/pages/archived_people_professor_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'welcome',
      builder: (context, state) => const WelcomePage(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const RegisterPage(),
    ),
    // Student routes
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomeStudentsPage(),
    ),
    GoRoute(
      path: '/notices',
      name: 'notices',
      builder: (context, state) => const NoticesPage(),
    ),
    GoRoute(
      path: '/archived',
      name: 'archived',
      builder: (context, state) => const ArchivedPage(),
    ),
    GoRoute(
      path: '/assignment-notices/:subjectName',
      name: 'assignment-notices',
      builder: (context, state) {
        final subjectName = state.pathParameters['subjectName']!;
        return AssignmentNoticesPage(subjectName: subjectName);
      },
    ),
    GoRoute(
      path: '/material-students/:subjectName',
      name: 'material-students',
      builder: (context, state) {
        final subjectName = state.pathParameters['subjectName']!;
        return MaterialStudentsPage(subjectName: subjectName);
      },
    ),
    GoRoute(
      path: '/transcriptor/:subjectName',
      name: 'transcriptor',
      builder: (context, state) {
        final subjectName = state.pathParameters['subjectName']!;
        return TranscriptorStudentPage(subjectName: subjectName);
      },
    ),
    GoRoute(
      path: '/people-student/:subjectName',
      name: 'people-student',
      builder: (context, state) {
        final subjectName = state.pathParameters['subjectName']!;
        return PeopleStudentPage(subjectName: subjectName);
      },
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => const SettingsStudentsPage(),
    ),
    // Student archived routes
    GoRoute(
      path: '/archived-assignment-notices/:subjectName',
      name: 'archived-assignment-notices',
      builder: (context, state) {
        final subjectName = state.pathParameters['subjectName']!;
        return ArchivedAssignmentNoticesPage(subjectName: subjectName);
      },
    ),
    GoRoute(
      path: '/archived-material-students/:subjectName',
      name: 'archived-material-students',
      builder: (context, state) {
        final subjectName = state.pathParameters['subjectName']!;
        return ArchivedMaterialStudentsPage(subjectName: subjectName);
      },
    ),
    GoRoute(
      path: '/archived-people-student/:subjectName',
      name: 'archived-people-student',
      builder: (context, state) {
        final subjectName = state.pathParameters['subjectName']!;
        return ArchivedPeopleStudentPage(subjectName: subjectName);
      },
    ),
    // Professor routes
    GoRoute(
      path: '/professor-home',
      name: 'professor-home',
      builder: (context, state) => const HomeProfessorPage(),
    ),
    GoRoute(
      path: '/professor-archived',
      name: 'professor-archived',
      builder: (context, state) => const ArchivedProfessorPage(),
    ),
    GoRoute(
      path: '/professor-settings',
      name: 'professor-settings',
      builder: (context, state) => const SettingsProfessorPage(),
    ),
    GoRoute(
      path: '/professor-assignment-notices/:subjectName',
      name: 'professor-assignment-notices',
      builder: (context, state) {
        final subjectName = state.pathParameters['subjectName']!;
        final extra = state.extra as Map<String, dynamic>?;
        return AssignmentNoticesProfessorPage(
          subjectName: subjectName,
          joinCode: extra?['joinCode'] as String?,
        );
      },
    ),
    GoRoute(
      path: '/professor-material-students/:subjectName',
      name: 'professor-material-students',
      builder: (context, state) {
        final subjectName = state.pathParameters['subjectName']!;
        return MaterialProfessorPage(subjectName: subjectName);
      },
    ),
    GoRoute(
      path: '/professor-transcriptor/:subjectName',
      name: 'professor-transcriptor',
      builder: (context, state) {
        final subjectName = state.pathParameters['subjectName']!;
        return TranscriptorProfessorPage(subjectName: subjectName);
      },
    ),
    GoRoute(
      path: '/professor-people-student/:subjectName',
      name: 'professor-people-student',
      builder: (context, state) {
        final subjectName = state.pathParameters['subjectName']!;
        return PeopleProfessorPage(subjectName: subjectName);
      },
    ),
    // Professor archived routes
    GoRoute(
      path: '/professor-archived-assignment-notices/:subjectName',
      name: 'professor-archived-assignment-notices',
      builder: (context, state) {
        final subjectName = state.pathParameters['subjectName']!;
        return ArchivedAssignmentNoticesProfessorPage(subjectName: subjectName);
      },
    ),
    GoRoute(
      path: '/professor-archived-material-students/:subjectName',
      name: 'professor-archived-material-students',
      builder: (context, state) {
        final subjectName = state.pathParameters['subjectName']!;
        return ArchivedMaterialProfessorPage(subjectName: subjectName);
      },
    ),
    GoRoute(
      path: '/professor-archived-people-student/:subjectName',
      name: 'professor-archived-people-student',
      builder: (context, state) {
        final subjectName = state.pathParameters['subjectName']!;
        return ArchivedPeopleProfessorPage(subjectName: subjectName);
      },
    ),
  ],
);
