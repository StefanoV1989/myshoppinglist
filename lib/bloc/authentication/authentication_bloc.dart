import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myshoppinglist/models/user_model.dart';
import 'package:myshoppinglist/repository/user_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository;

  AuthenticationBloc(this.userRepository) : super(AuthUninitialized()) {
    on<AppStarted>((event, emit) async {
      emit(AuthLoading());
      
      if(await userRepository.isSignedIn()) {
        UserModel? user = await userRepository.getUser();

        emit(Authorized(user: user!));
      }
      else
      {
        emit(Unauthorized());
      }
    });

    on<LoggedIn>((event, emit) async {
      emit(AuthLoading());
      UserModel? user = await userRepository.signInWithCredential(event.username, event.password);

      if(user != null)
      {
        emit(Authorized(user: user));
      }
      else
      {
        emit(Unauthorized());
      }
    });

    on<LoggedOut>((event, emit) async {
      await userRepository.signOut();
      emit(Unauthorized());
    });

    on<LoggedInRefresh>((event, emit) {
      emit(AuthLoading());
      emit(Authorized(user: event.user));
    },);
  }


}