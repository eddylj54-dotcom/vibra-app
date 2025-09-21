import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibra/features/home/screens/home_screen.dart';
import 'package:vibra/features/onboarding/bloc/onboarding_bloc.dart';
import 'package:vibra/features/onboarding/bloc/onboarding_event.dart';
import 'package:vibra/features/onboarding/bloc/onboarding_state.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  void initState() {
    super.initState();
    // Dispatch the Started event when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<OnboardingBloc>(context).add(const Started());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vibra Onboarding')),
      body: BlocConsumer<OnboardingBloc, OnboardingState>(
        listener: (context, state) {
          if (state is Completed) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          }
        },
        builder: (context, state) {
          if (state is Initial || state is Loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is StepOne) {
            return _buildStepOne(context, state.selectedInterests);
          } else if (state is StepTwo) {
            return _buildStepTwo(context);
          } else if (state is Completed) {
            return const Center(child: Text('Onboarding Completed!'));
          } else if (state is Error) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const SizedBox.shrink(); // Fallback
        },
      ),
    );
  }

  Widget _buildStepOne(BuildContext context, Set<String> selectedInterests) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'What are your wellness goals?',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: [
              'Mental Health',
              'Physical Fitness',
              'Nutrition',
              'Personal Growth',
              'Sleep',
              'Stress Reduction',
            ].map((interest) {
              final isSelected = selectedInterests.contains(interest);
              return ChoiceChip(
                label: Text(interest),
                selected: isSelected,
                onSelected: (selected) {
                  BlocProvider.of<OnboardingBloc>(context).add(
                    SelectInterest(interest: interest),
                  );
                },
                selectedColor: Theme.of(context).primaryColor.withOpacity(0.7),
                backgroundColor: Colors.grey[200],
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey[800],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              BlocProvider.of<OnboardingBloc>(context).add(const NextStep());
            },
            child: const Text('Next'),
          ),
        ],
      ),
    );
  }

  Widget _buildStepTwo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'How AI will help you',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Vibra uses advanced AI to personalize your wellness journey, recommending micro-learning modules and activities tailored to your goals and progress.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              BlocProvider.of<OnboardingBloc>(context).add(const SubmitGoals());
            },
            child: const Text('Get Started'),
          ),
          TextButton(
            onPressed: () {
              BlocProvider.of<OnboardingBloc>(context).add(const PreviousStep());
            },
            child: const Text('Back'),
          ),
        ],
      ),
    );
  }
}