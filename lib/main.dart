import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/presentation/blocs/theme/theme_cubit.dart';
import 'package:portfolio/presentation/router/app_router.dart';

void main() {
  setUrlStrategy(PathUrlStrategy());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, mode) {
          return MaterialApp.router(
            title: 'Swapnaneel Sarkar — Technical Product Manager',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: mode,
            themeAnimationDuration: const Duration(milliseconds: 180),
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
