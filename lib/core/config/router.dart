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
  ],
);
