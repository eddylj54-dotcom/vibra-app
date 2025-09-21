part of 'onboarding_bloc.dart';

abstract class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object> get props => [];
}

class OnboardingInitial extends OnboardingState {}

class OnboardingNameInput extends OnboardingState {
  final String? displayName;

  const OnboardingNameInput({this.displayName});

  @override
  List<Object> get props => [displayName ?? ''];
}

class OnboardingGoalSelection extends OnboardingState {
  final String displayName;
  final String? selectedGoal;

  const OnboardingGoalSelection({required this.displayName, this.selectedGoal});

  @override
  List<Object> get props => [displayName, selectedGoal ?? ''];
}

class OnboardingLoading extends OnboardingState {}

class OnboardingSuccess extends OnboardingState {}

class OnboardingError extends OnboardingState {
  final String message;

  const OnboardingError(this.message);

  @override
  List<Object> get props => [message];
}