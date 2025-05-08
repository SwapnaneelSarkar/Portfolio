import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
// Choose only one URL strategy implementation:
import 'package:url_strategy/url_strategy.dart';
// Remove this import if using the one above
// import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:portfolio/presentation/blocs/navigation/navigation_bloc.dart';
import 'package:portfolio/presentation/blocs/theme/theme_bloc.dart';
import 'package:portfolio/presentation/blocs/animation/animation_bloc.dart';
import 'package:portfolio/presentation/blocs/scroll/scroll_bloc.dart';
import 'package:portfolio/presentation/router/app_router.dart';
import 'package:portfolio/core/theme/app_theme.dart';

void main() {
  // Use only ONE of these methods, not both:
  setPathUrlStrategy();
  // Remove this line:
  // setUrlStrategy(PathUrlStrategy());
  
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
            title: 'Swapnaneel Sarkar | Portfolio',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.darkTheme,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}