import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:stacked/stacked.dart';

import '../../shared/logo.dart';
import '../../shared/profile_pic.dart';
import '../../theme/globals.dart';
import 'home_viewmodel.dart';
import 'widgets/celebrity_side_scroll.dart';
import 'widgets/header.dart';

class HomeView extends StatelessWidget {
  final VoidCallback goToProfileView;

  const HomeView({Key? key, required this.goToProfileView}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFC8CEEC), Color(0xFFFAFBFD)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ViewModelBuilder<HomeViewModel>.reactive(
          viewModelBuilder: () => HomeViewModel(),
          fireOnModelReadyOnce: true,
          onModelReady: (model) => model.initializeModel(),
          builder: (context, model, _) {
            if (model.isBusy) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }

            return FloatingSearchBar(
              leadingActions: const [
                AppLogo(
                  centered: false,
                  small: true,
                ),
              ],
              axisAlignment: 0,
              queryStyle: blackTextStyle,
              actions: [
                SizedBox(
                  width: 36,
                  height: 36,
                  child: MaterialButton(
                    onPressed: goToProfileView,
                    shape: const CircleBorder(),
                    padding: EdgeInsets.zero,
                    child: ProfilePic(
                      url: model.user.photoURL,
                      size: 16,
                    ),
                  ),
                ),
              ],
              hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
              borderRadius: maxBorderRadius,
              builder: (context, transition) {
                return const Text('Search coming soon');
              },
              body: SafeArea(
                child: ListView(
                  padding: const EdgeInsets.only(top: 56, bottom: 16),
                  children: [
                    // const CelebrityGroupHeader(title: 'Trending'),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 650,
                      child: CelebritySideScroll(
                        celebrities: model.celebrities,
                      ),
                    ),
                    // const CelebrityGroupHeader(title: 'Online Now'),
                    // SizedBox(
                    //   height: 240,
                    //   child: CelebritySideScroll(
                    //     celebrities: model.celebrities,
                    //   ),
                    // ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
