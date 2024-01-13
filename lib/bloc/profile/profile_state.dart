part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  final UserModel user;

  const ProfileSuccess({required this.user});

  @override
  List<Object> get props => [user];
}

class ProfileLoaded extends ProfileState {
  final UserModel user;

  const ProfileLoaded({required this.user});

  @override
  List<Object> get props => [user];
}

class ProfileChangedAvatar extends ProfileState {
  final UserModel user;

  const ProfileChangedAvatar({required this.user});

  @override
  List<Object> get props => [user];
}
