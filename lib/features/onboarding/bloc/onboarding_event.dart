part of 'onboarding_bloc.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object> get props => [];
}

class OnboardingNameSubmitted extends OnboardingEvent {
  final String displayName;

  const OnboardingNameSubmitted(this.displayName);

  @override
  List<Object> get props => [displayName];
}

class OnboardingGoalSelected extends OnboardingEvent {
  final String goal;

  const OnboardingGoalSelected(this.goal);

  @override
  List<Object> get props => [goal];
}