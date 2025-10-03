import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibra/features/auth/pages/login_page.dart';
import 'package:vibra/features/onboarding/bloc/onboarding_bloc.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Setup Your Profile')),
      body: BlocConsumer<OnboardingBloc, OnboardingState>(
        listener: (context, state) {
          if (state is OnboardingSuccess) {
            // Navigate to the login page or home page after success
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const LoginPage()), // Assuming navigation to LoginPage
              (route) => false,
            );
          } else if (state is OnboardingError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is OnboardingLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is OnboardingNameInput) {
            return _NameInputView();
          }
          if (state is OnboardingGoalSelection) {
            return _GoalSelectionView(displayName: state.displayName);
          }
          // Default/Initial state
          return _NameInputView();
        },
      ),
    );
  }
}

class _NameInputView extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('What should we call you?', style: TextStyle(fontSize: 22)),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Your Name'),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              if (_nameController.text.isNotEmpty) {
                context
                    .read<OnboardingBloc>()
                    .add(OnboardingNameSubmitted(_nameController.text));
              }
            },
            child: const Text('Next'),
          ),
        ],
      ),
    );
  }
}

class _GoalSelectionView extends StatelessWidget {
  final String displayName;
  const _GoalSelectionView({required this.displayName});

  @override
  Widget build(BuildContext context) {
    final goals = ['Be more active', 'Reduce stress', 'Learn a new skill'];
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Welcome, $displayName! What is your main goal?', style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 24),
          ...goals.map((goal) => ListTile(
                title: Text(goal),
                onTap: () {
                  context.read<OnboardingBloc>().add(OnboardingGoalSelected(goal));
                },
              )),
        ],
      ),
    );
  }
}
