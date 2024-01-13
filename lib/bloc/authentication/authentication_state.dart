part of 'authentication_bloc.dart';

class AuthenticationState extends Equatable {
  const AuthenticationState();
  
  @override
  List<Object> get props => [];
}

class AuthUninitialized extends AuthenticationState {}

class AuthLoading extends AuthenticationState {}

class Authorized extends AuthenticationState {
  final UserModel user;

  const Authorized({required this.user});

  @override
  List<Object> get props => [user];
}

class Unauthorized extends AuthenticationState {}