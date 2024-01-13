part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class ProfileLoadSettings extends ProfileEvent {
  final UserModel user;

  const ProfileLoadSettings({required this.user});

  @override
  List<Object> get props => [user];
}

class ProfileSaveSettings extends ProfileEvent {
  final UserModel user;

  const ProfileSaveSettings({required this.user});

  @override
  List<Object> get props => [user];
}

class ProfileChangeAvatar extends ProfileEvent {
  final UserModel user;
  final File avatar;

  const ProfileChangeAvatar({required this.user, required this.avatar});

  @override
  List<Object> get props => [user, avatar];
}