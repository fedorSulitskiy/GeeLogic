import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:frontend/models/algo_data.dart';
import 'package:frontend/widgets/common/app_bar/add_algorithm_button.dart';
import 'package:frontend/widgets/common/app_bar/drawer_side_menu.dart';
import 'package:frontend/widgets/common/app_bar/search_gee_logic_bar.dart';
import 'package:frontend/widgets/common/app_bar/side_menu.dart';
import 'package:frontend/widgets/edit/edit_content.dart';

/// Screen for editing the selected algorithm
class EditScreen extends ConsumerWidget {
  const EditScreen({super.key, required this.data});

  final AlgoData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      drawer: screenSize.width > 850 ? null : DrawerSideMenu(ref: ref),
      body: Center(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                Expanded(child: EditContent(algoData: data)),
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
                // Add Button
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
