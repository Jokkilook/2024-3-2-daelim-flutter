import 'package:daelim_project/routes/app_router.dart';
import 'package:daelim_project/routes/app_screen.dart';
import 'package:flutter/material.dart';

class AppNavigationRail extends StatelessWidget {
  final AppScreen appScreen;

  const AppNavigationRail({
    super.key,
    required this.appScreen,
  });

  @override
  Widget build(BuildContext context) {
    final screens = List<AppScreen>.from(AppScreen.values);
    screens.removeAt(0);

    return NavigationRail(
      onDestinationSelected: (value) {
        final screen = screens[value];
        appRouter.pushNamed(screen.name);
      },
      destinations: screens.map((e) {
        return NavigationRailDestination(
          icon: Icon(e.getIcon),
          label: Text(e.name),
        );
      }).toList(),
      selectedIndex: appScreen.index - 1,
    );
  }
}
