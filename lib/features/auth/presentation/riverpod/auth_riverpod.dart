import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/app_container.dart';
import '../../../../core/network/api_client.dart';
import '../../di/auth_di.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';

final _authDIProvider = Provider<AuthDI>((ref) {
  final container = ref.watch(appContainerProvider);
  return AuthDI(container!);
});

final _loginUsecaseProvider = Provider<LoginUsecase>((ref) {
  return ref.watch(_authDIProvider).loginUsecase;
});

final _registerUsecaseProvider = Provider<RegisterUsecase>((ref) {
  return ref.watch(_authDIProvider).registerUsecase;
});

enum AuthStatus { initial, unauthenticated, authenticated }

class AuthState {
  final AuthStatus status;
  final bool isLoading;
  final String? error;
  final bool isStudent;
  final bool isRegisterLoading;
  final bool isRegisterSuccess;
  final UserData? user;

  const AuthState({
    this.status = AuthStatus.initial,
    this.isLoading = false,
    this.error,
    this.isStudent = true,
    this.isRegisterLoading = false,
    this.isRegisterSuccess = false,
    this.user,
  });

  AuthState copyWith({
    AuthStatus? status,
    bool? isLoading,
    String? error,
    bool? isStudent,
    bool? isRegisterLoading,
    bool? isRegisterSuccess,
    UserData? user,
  }) {
    return AuthState(
      status: status ?? this.status,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isStudent: isStudent ?? this.isStudent,
      isRegisterLoading: isRegisterLoading ?? this.isRegisterLoading,
      isRegisterSuccess: isRegisterSuccess ?? this.isRegisterSuccess,
      user: user ?? this.user,
    );
  }
}

class UserData {
  final int userId;
  final String name;
  final String email;
  final int roleId;
  final String? avatarUrl;

  const UserData({required this.userId, required this.name, required this.email, required this.roleId, this.avatarUrl});
}

class AuthNotifier extends AsyncNotifier<AuthState> {
  @override
  Future<AuthState> build() async => const AuthState();

  void setRole(bool isStudent) {
    state = AsyncValue.data(state.requireValue.copyWith(isStudent: isStudent));
  }

  Future<void> login({required String email, required String password}) async {
    final previous = state.requireValue;
    state = const AsyncValue.loading();

    try {
      final payload = await ref.read(_loginUsecaseProvider)(email: email, password: password);

      final expectedRoleId = previous.isStudent ? 1 : 2;
      if (payload.user.roleId != expectedRoleId) {
        final selectedRole = previous.isStudent ? 'alumno' : 'docente';
        final actualRole = payload.user.roleId == 1 ? 'alumno' : 'docente';
        throw ApiException(
          'No puedes iniciar sesión como $selectedRole. Tu cuenta está registrada como $actualRole.',
        );
      }

      final storage = ref.read(appContainerProvider)!.tokenStorage;
      await storage.saveToken(payload.accessToken);
      await storage.saveRefreshToken(payload.refreshToken);
      state = AsyncValue.data(
        previous.copyWith(
          status: AuthStatus.authenticated,
          isLoading: false,
          user: UserData(
            userId: payload.user.userId,
            name: payload.user.name,
            email: payload.user.email,
            roleId: payload.user.roleId,
            avatarUrl: payload.user.avatarUrl,
          ),
        ),
      );
    } on Exception catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required int roleId,
  }) async {
    final previous = state.requireValue;
    state = const AsyncValue.loading();

    try {
      final payload = await ref.read(_registerUsecaseProvider)(
        name: name,
        email: email,
        password: password,
        roleId: roleId,
      );
      final storage = ref.read(appContainerProvider)!.tokenStorage;
      await storage.saveToken(payload.accessToken);
      await storage.saveRefreshToken(payload.refreshToken);
      state = AsyncValue.data(
        previous.copyWith(
          isRegisterLoading: false,
          isRegisterSuccess: true,
          user: UserData(
            userId: payload.user.userId,
            name: payload.user.name,
            email: payload.user.email,
            roleId: payload.user.roleId,
            avatarUrl: payload.user.avatarUrl,
          ),
        ),
      );
    } on Exception catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  void clearRegisterSuccess() {
    state = AsyncValue.data(state.requireValue.copyWith(isRegisterSuccess: false));
  }

  Future<void> logout() async {
    await ref.read(appContainerProvider)!.tokenStorage.clearTokens();
    state = AsyncValue.data(const AuthState(status: AuthStatus.unauthenticated));
  }

  void clearError() {
    state = AsyncValue.data(state.requireValue.copyWith(error: null));
  }

  void updateAvatarUrl(String? avatarUrl) {
    final current = state.requireValue.user;
    if (current == null) return;
    state = AsyncValue.data(
      state.requireValue.copyWith(
        user: UserData(
          userId: current.userId,
          name: current.name,
          email: current.email,
          roleId: current.roleId,
          avatarUrl: avatarUrl,
        ),
      ),
    );
  }
}

final authViewModelProvider = AsyncNotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
