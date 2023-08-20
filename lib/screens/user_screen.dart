import 'package:flutter/material.dart';

import 'package:frontend/widgets/common/app_bar/add_algorithm_button.dart';
import 'package:frontend/widgets/common/app_bar/search_gee_logic_bar.dart';
import 'package:frontend/widgets/common/app_bar/side_menu.dart';

import 'package:frontend/widgets/user/user_content.dart';

/// The screen that displays the user's algorithms and user's profile.
class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Row(
          children: [
            // List of menu options
            Flexible(
              flex: 1,
              child: SideMenu(),
            ),
            // Search and main content
            Flexible(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SearchGeeLogicBar(),
                  Expanded(child: UserContent()),
                ],
              ),
            ),
            // Add algorithm Button
            Flexible(
              flex: 1,
              child: AddAlgorithmButton(),
            )
          ],
        ),
      ),
    );
  }
}
