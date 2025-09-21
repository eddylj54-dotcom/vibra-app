
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vibra/features/auth/repositories/auth_repository.dart';
import 'package:vibra/features/database/repositories/database_repository.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final AuthRepository _authRepository;
  final DatabaseRepository _databaseRepository;

  OnboardingBloc({
    required AuthRepository authRepository,
    required DatabaseRepository databaseRepository,
  })  : _authRepository = authRepository,
        _databaseRepository = databaseRepository,
        super(OnboardingNameInput()) {
    on<OnboardingNameSubmitted>((event, emit) async {
      final user = _authRepository.currentUser;
      if (user == null) {
        emit(const OnboardingError('User not authenticated.'));
        return;
      }
      emit(OnboardingLoading());
      try {
        // Update displayName in Firebase Auth
        await user.updateDisplayName(event.displayName);

        // Update displayName in Firestore
        await _databaseRepository.updateUserData(
          user.uid,
          displayName: event.displayName,
        );
        emit(OnboardingGoalSelection(displayName: event.displayName));
      } catch (e) {
        emit(OnboardingError(e.toString()));
      }
    });

    on<OnboardingGoalSelected>((event, emit) async {
      final user = _authRepository.currentUser;
      if (user == null) {
        emit(const OnboardingError('User not authenticated.'));
        return;
      }
      emit(OnboardingLoading());
      try {
        // Update mainGoal in Firestore
        await _databaseRepository.updateUserData(
          user.uid,
          mainGoal: event.goal,
        );
        emit(OnboardingSuccess());
      } catch (e) {
        emit(OnboardingError(e.toString()));
      }
    });
  }
}
