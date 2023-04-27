import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../celeb_dashboard/celeb_dashboard_view.dart';
import '../home/home_view.dart';
// import '../notifications/notifications_view.dart';
import '../profile/profile_view.dart';
import 'navbar_viewmodel.dart';

class NavbarView extends StatelessWidget {
  final  bool isCelebrity;

  const NavbarView({
    Key? key,
    required this.isCelebrity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NavbarViewModel>.reactive(
      viewModelBuilder: () => NavbarViewModel(),
      builder: (context, model, _) {
        final body = [
          if (isCelebrity) const CelebrityDashboardView(),
          HomeView(
            goToProfileView: () {
              if (isCelebrity) {
                model.setIndex(2);
              } else {
                model.setIndex(1);
              }
            },
          ),
          // const NotificationsView(),
          ProfileView(isCelebrity: isCelebrity),
        ];

        return Scaffold(
          extendBodyBehindAppBar: true,
          body: PageTransitionSwitcher(
            transitionBuilder: (child, anim1, anim2) {
              return FadeThroughTransition(
                animation: anim1,
                secondaryAnimation: anim2,
                child: child,
              );
            },
            child: body[model.currentIndex],
          ),
          bottomNavigationBar: BottomNavigationBar(
            showSelectedLabels: false,
            showUnselectedLabels: false,
            currentIndex: model.currentIndex,
            onTap: model.setIndex,
            selectedItemColor: Colors.red,
            unselectedItemColor: const Color(0xFF828282),
            items: [
              if (isCelebrity)
                const BottomNavigationBarItem(
                  label: 'Home',
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home),
                ),
              const BottomNavigationBarItem(
                label: 'Explore',
                icon: Icon(Icons.explore_outlined),
                activeIcon: Icon(Icons.explore),
              ),
              // const BottomNavigationBarItem(
              //   label: 'Notifications',
              //   icon: Icon(Icons.notifications_outlined),
              //   activeIcon: Icon(Icons.notifications),
              // ),
              const BottomNavigationBarItem(
                label: 'Profile',
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
              ),
            ],
          ),
        );
      },
    );
  }
}
