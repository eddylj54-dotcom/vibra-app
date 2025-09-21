import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vibra/features/auth/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  late StreamSubscription<User?> _userSubscription;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthInitial()) {
    on<AuthStateChanged>(_onAuthStateChanged);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<AuthLoginWithEmailPasswordRequested>(_onAuthLoginWithEmailPasswordRequested); // New handler
    on<AuthLoginWithGoogleRequested>(_onAuthLoginWithGoogleRequested); // New handler

    _userSubscription = _authRepository.authStateChanges.listen(
      (user) => add(AuthStateChanged(user)),
    );
  }

  void _onAuthStateChanged(AuthStateChanged event, Emitter<AuthState> emit) {
    if (event.user != null) {
      emit(Authenticated(event.user!));
    } else {
      // Only emit Unauthenticated if not currently in a loading or error state from a login attempt
      if (state is! AuthLoading && state is! AuthError) {
        emit(Unauthenticated());
      }
    }
  }

  void _onAuthLogoutRequested(
      AuthLogoutRequested event, Emitter<AuthState> emit) async {
    await _authRepository.signOut();
    emit(Unauthenticated());
  }

  // New handler for email/password login
  void _onAuthLoginWithEmailPasswordRequested(
      AuthLoginWithEmailPasswordRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _authRepository.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      // State will be updated by AuthStateChanged event from authStateChanges stream
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? 'Error de inicio de sesión.'));
      emit(Unauthenticated()); // Return to unauthenticated state after error
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(Unauthenticated()); // Return to unauthenticated state after error
    }
  }

  // New handler for Google login
  void _onAuthLoginWithGoogleRequested(
      AuthLoginWithGoogleRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _authRepository.signInWithGoogle();
      // State will be updated by AuthStateChanged event from authStateChanges stream
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? 'Error de inicio de sesión con Google.'));
      emit(Unauthenticated()); // Return to unauthenticated state after error
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(Unauthenticated()); // Return to unauthenticated state after error
    }
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
