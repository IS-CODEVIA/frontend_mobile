import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/welcome_page.dart';
import '../../features/archived/presentation/pages/archived_page.dart';
import '../../features/general_noticies/presentation/pages/notices_page.dart';
import '../../features/home_student/presentation/pages/home_students_page.dart';

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
  ],
);
