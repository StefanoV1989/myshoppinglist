import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myshoppinglist/models/user_model.dart';
import 'package:myshoppinglist/repository/user_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';


class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {

  final UserRepository userRepository;

  ProfileBloc(this.userRepository) : super(ProfileInitial()) {
    on<ProfileLoadSettings>((event, emit) async {
      emit(ProfileLoading());
      UserModel user = await userRepository.getSetting(event.user.uuid!);
      UserModel newUser = event.user.copyWith(name: user.name, surname: user.surname);
      emit(ProfileLoaded(user: newUser));
    });

    on<ProfileSaveSettings>((event, emit) async {
      emit(ProfileLoading());
      UserModel newUser = await userRepository.updateSetting(event.user);
      emit(ProfileSuccess(user: newUser));
    },);

    on<ProfileChangeAvatar>((event, emit) async {
      emit(ProfileLoading());
      String newAvatar = await userRepository.uploadAvatar(event.user.uuid!, event.avatar);

      UserModel newUser = event.user.copyWith(avatar: newAvatar);
      emit(ProfileChangedAvatar(user: newUser));
      emit(ProfileLoaded(user: newUser));
    },);
  }
}