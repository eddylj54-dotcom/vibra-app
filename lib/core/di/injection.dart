import 'package:get_it/get_it.dart';
import 'package:vibra/features/auth/bloc/auth_bloc.dart';
import 'package:vibra/features/auth/repositories/auth_repository.dart';
import 'package:vibra/features/database/repositories/database_repository.dart';
import 'package:vibra/features/onboarding/bloc/onboarding_bloc.dart';

final getIt = GetIt.instance;

void setupLocator() {
  // Repositories
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepository());
  getIt.registerLazySingleton<DatabaseRepository>(() => DatabaseRepository());

  // Blocs
  getIt.registerFactory<OnboardingBloc>(
    () => OnboardingBloc(
      authRepository: getIt<AuthRepository>(),
      databaseRepository: getIt<DatabaseRepository>(),
    ),
  );
  getIt.registerFactory<AuthBloc>(() => AuthBloc(
        authRepository: getIt<AuthRepository>(),
      ));
  // Register other dependencies here
}