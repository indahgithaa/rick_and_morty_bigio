import 'package:flutter/material.dart';
import '../../features/character/presentation/pages/character_detail_page.dart';
import '../../features/character/presentation/pages/main_navigation.dart';
import '../../features/splash/splash_screen.dart';
import 'route_names.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case RouteNames.main:
        return MaterialPageRoute(builder: (_) => const MainNavigation());

      case RouteNames.characterDetail:
        final characterId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => CharacterDetailPage(characterId: characterId),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
