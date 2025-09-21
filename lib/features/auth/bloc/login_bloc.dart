import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vibra/features/auth/repositories/auth_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository _authRepository;

  LoginBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(LoginInitial()) {
    on<LoginWithEmailPasswordPressed>((event, emit) async {
      emit(LoginLoading());
      try {
        await _authRepository.signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        emit(LoginSuccess());
      } catch (e) {
        emit(LoginFailure(e.toString()));
      }
    });

    on<LoginWithGooglePressed>((event, emit) async {
      emit(LoginLoading());
      try {
        await _authRepository.signInWithGoogle();
        emit(LoginSuccess());
      } catch (e) {
        emit(LoginFailure(e.toString()));
      }
    });
  }
}
