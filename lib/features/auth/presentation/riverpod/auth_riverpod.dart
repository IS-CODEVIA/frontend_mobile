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

  const AuthState({
    this.status = AuthStatus.initial,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    AuthStatus? status,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      status: status ?? this.status,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState();

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
