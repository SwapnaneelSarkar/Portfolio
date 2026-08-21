import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:portfolio/presentation/blocs/navigation/navigation_bloc.dart';
import 'package:portfolio/presentation/blocs/theme/theme_bloc.dart';
import 'package:portfolio/presentation/blocs/animation/animation_bloc.dart';
import 'package:portfolio/presentation/blocs/scroll/scroll_bloc.dart';
import 'package:portfolio/presentation/router/app_router.dart';
import 'package:portfolio/core/theme/app_theme.dart';

void main() {
  // Set URL strategy for web
  setUrlStrategy(PathUrlStrategy());

  // Cheap viewport polling for scroll-triggered reveals.
  VisibilityDetectorController.instance.updateInterval =
      const Duration(milliseconds: 100);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => NavigationBloc()),
        BlocProvider(create: (context) => ThemeBloc()),
        BlocProvider(create: (context) => AnimationBloc()),
        BlocProvider(create: (context) => ScrollBloc()),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp.router(
            title: 'Swapnaneel Sarkar | Technical Product Manager',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.darkTheme,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
