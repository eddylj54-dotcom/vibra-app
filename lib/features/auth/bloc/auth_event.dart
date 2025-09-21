part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthStateChanged extends AuthEvent {
  final User? user;

  const AuthStateChanged(this.user);

  @override
  List<Object> get props => [user!];
}

class AuthLogoutRequested extends AuthEvent {}

// New events for login
class AuthLoginWithEmailPasswordRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginWithEmailPasswordRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class AuthLoginWithGoogleRequested extends AuthEvent {
  const AuthLoginWithGoogleRequested();
}
