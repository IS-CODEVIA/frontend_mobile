import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/app_container.dart';
import '../../../auth/presentation/riverpod/auth_riverpod.dart';
import '../../di/profile_di.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/update_avatar_usecase.dart';

final _profileDIProvider = Provider<ProfileDI>((ref) {
  final container = ref.watch(appContainerProvider);
  return ProfileDI(container!);
});

final _getProfileUsecaseProvider = Provider<GetProfileUsecase>((ref) {
  return ref.watch(_profileDIProvider).getProfileUsecase;
});

final _updateAvatarUsecaseProvider = Provider<UpdateAvatarUsecase>((ref) {
  return ref.watch(_profileDIProvider).updateAvatarUsecase;
});

enum ProfileStatus { initial, loading, loaded, error }

class ProfileState {
  final ProfileStatus status;
  final ProfileEntity? profile;
  final String? error;
  final bool isUploading;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.profile,
    this.error,
    this.isUploading = false,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    ProfileEntity? profile,
    String? error,
    bool? isUploading,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      error: error,
      isUploading: isUploading ?? this.isUploading,
    );
  }
}

class ProfileNotifier extends Notifier<ProfileState> {
  @override
  ProfileState build() => const ProfileState();

  Future<void> loadProfile() async {
    state = state.copyWith(status: ProfileStatus.loading, error: null);

    try {
      final profile = await ref.read(_getProfileUsecaseProvider)();
      ref.read(authViewModelProvider.notifier).updateAvatarUrl(profile.avatarUrl);
      state = state.copyWith(
        status: ProfileStatus.loaded,
        profile: profile,
      );
    } on Exception catch (e) {
      state = state.copyWith(
        status: ProfileStatus.error,
        error: e.toString(),
      );
    }
  }

  Future<void> updateAvatar(File imageFile) async {
    state = state.copyWith(isUploading: true, error: null);

    try {
      final profile = await ref.read(_updateAvatarUsecaseProvider)(imageFile);
      ref.read(authViewModelProvider.notifier).updateAvatarUrl(profile.avatarUrl);
      state = state.copyWith(
        status: ProfileStatus.loaded,
        profile: profile,
        isUploading: false,
      );
    } on Exception catch (e) {
      state = state.copyWith(
        isUploading: false,
        error: e.toString(),
      );
    }
  }
}

final profileProvider = NotifierProvider<ProfileNotifier, ProfileState>(
  ProfileNotifier.new,
);
