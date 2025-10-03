import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vibra/core/theme/app_colors.dart';
import 'package:vibra/core/theme/theme_notifier.dart';
import 'package:flutter/services.dart';

import 'package:vibra/features/auth/bloc/auth_bloc.dart';
import 'package:vibra/features/auth/repositories/auth_repository.dart';
import 'package:vibra/features/home/repositories/post_repository.dart';
import 'package:vibra/features/auth/widgets/auth_gate.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepository(firebaseAuth: FirebaseAuth.instance),
        ),
        RepositoryProvider<PostRepository>(
          create: (context) => PostRepository(
            firestore: FirebaseFirestore.instance,
            auth: FirebaseAuth.instance,
          ),
        ),
      ],
      child: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(
          authRepository: context.read<AuthRepository>(),
        ),
        child: Consumer<ThemeNotifier>(
          builder: (context, themeNotifier, child) {
            return MaterialApp(
              title: 'Vibra',
              theme: _buildThemeData(Brightness.light),
              darkTheme: _buildThemeData(Brightness.dark),
              themeMode: themeNotifier.isDarkMode ? ThemeMode.dark : ThemeMode.light,
              debugShowCheckedModeBanner: false,
              home: const AuthGate(),
            );
          },
        ),
      ),
    );
  }

  ThemeData _buildThemeData(Brightness brightness) {
    final bool isDark = brightness == Brightness.dark;
    final colors = isDark ? AppColors.dark() : AppColors.light();

    final colorScheme = ColorScheme(
      primary: colors.primary,
      primaryContainer: colors.primaryDark,
      secondary: colors.secondary,
      secondaryContainer: colors.secondaryDark,
      surface: colors.surface,
      error: colors.error,
      onPrimary: colors.textLight,
      onSecondary: colors.textLight,
      onSurface: colors.textDark,
      onError: colors.textLight,
      brightness: brightness,
    );

    return ThemeData.from(colorScheme: colorScheme).copyWith(
      scaffoldBackgroundColor: colors.background,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: GoogleFonts.poppinsTextTheme().apply(
        bodyColor: colors.textDark,
        displayColor: colors.textDark,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.primary,
        foregroundColor: colors.textLight,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          color: colors.textLight,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.textLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surface,
        hintStyle: GoogleFonts.poppins(color: colors.textGrey),
        labelStyle: GoogleFonts.poppins(color: colors.textDark),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.background, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.error, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.selected)) {
            return colors.primary;
          }
          return null;
        }),
        trackColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.selected)) {
            return colors.primary.withAlpha(128);
          }
          return null;
        }),
      ),
    );
  }
}