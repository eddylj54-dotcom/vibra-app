import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vibra/features/auth/repositories/auth_repository.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository _authRepository;

  RegisterBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(RegisterInitial()) {
    on<RegisterWithEmailPasswordPressed>((event, emit) async {
      emit(RegisterLoading());
      try {
        await _authRepository.signUpWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        await _authRepository.sendEmailVerification();
        emit(RegisterSuccess());
      } catch (e) {
        emit(RegisterFailure(e.toString()));
      }
    });
  }
}
