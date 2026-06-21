import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthStatus {
  initial,
  unauthenticated,
  authenticated,
}

class AuthState {
  final AuthStatus status;
  final bool isLoading;
  final String? error;
  final bool isStudent;
  final bool isRegisterLoading;
  final bool isRegisterSuccess;

  const AuthState({
    this.status = AuthStatus.initial,
    this.isLoading = false,
    this.error,
    this.isStudent = true,
    this.isRegisterLoading = false,
    this.isRegisterSuccess = false,
  });

  AuthState copyWith({
    AuthStatus? status,
    bool? isLoading,
    String? error,
    bool? isStudent,
    bool? isRegisterLoading,
    bool? isRegisterSuccess,
  }) {
    return AuthState(
      status: status ?? this.status,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isStudent: isStudent ?? this.isStudent,
      isRegisterLoading: isRegisterLoading ?? this.isRegisterLoading,
      isRegisterSuccess: isRegisterSuccess ?? this.isRegisterSuccess,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState();

  void setRole(bool isStudent) {
    state = state.copyWith(isStudent: isStudent);
  }

  void register() {
    state = state.copyWith(isRegisterLoading: true, error: null);
    
  }

  void clearRegisterSuccess() {
    state = state.copyWith(isRegisterSuccess: false);
  }

  void goToLogin() {
    state = state.copyWith(status: AuthStatus.unauthenticated, error: null);
  }

  void goToHome() {
    state = state.copyWith(status: AuthStatus.authenticated, error: null);
  }

  void logout() {
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final authViewModelProvider =
    NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
