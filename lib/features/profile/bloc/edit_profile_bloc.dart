import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibra/features/auth/repositories/auth_repository.dart';
import 'edit_profile_event.dart';
import 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final AuthRepository _authRepository;

  EditProfileBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(EditProfileInitial()) {
    on<EditProfileSubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(
    EditProfileSubmitted event,
    Emitter<EditProfileState> emit,
  ) async {
    emit(EditProfileLoading());
    try {
      await _authRepository.updateUserProfile(event.newName);
      emit(EditProfileSuccess());
    } catch (e) {
      emit(EditProfileFailure(e.toString()));
    }
  }
}
