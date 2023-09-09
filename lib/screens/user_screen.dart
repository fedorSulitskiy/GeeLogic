import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:frontend/widgets/common/app_bar/add_algorithm_button.dart';
import 'package:frontend/widgets/common/app_bar/drawer_side_menu.dart';
import 'package:frontend/widgets/common/app_bar/search_gee_logic_bar.dart';
import 'package:frontend/widgets/common/app_bar/side_menu.dart';

import 'package:frontend/widgets/user/user_content.dart';

/// The screen that displays the user's algorithms and user's profile.
class UserScreen extends ConsumerWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// Responsive layout
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      drawer: screenSize.width > 850 ? null : DrawerSideMenu(ref: ref),
      body: Center(
        child: Stack(
          children: [
            const Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 60),
                Expanded(child: UserContent()),
              ],
            ),
            Row(
              children: [
                // List of menu options
                Flexible(
                  flex: 1,
                  child: screenSize.width > 850
                      ? const SideMenu()
                      : const DrawerMenuButton(),
                ),
                // Search and main content
                const Flexible(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SearchGeeLogicBar(),
                      Spacer(),
                    ],
                  ),
                ),
                // Add algorithm Button
                const Flexible(
                  flex: 1,
                  child: AddAlgorithmButton(),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
