import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:frontend/widgets/common/app_bar/add_algorithm_button.dart';
import 'package:frontend/widgets/common/app_bar/drawer_side_menu.dart';
import 'package:frontend/widgets/common/app_bar/search_gee_logic_bar.dart';

import 'package:frontend/models/algo_data.dart';
import 'package:frontend/widgets/details/details_content.dart';

/// The screen that displays the details of the algorithm page.
class DetailsScreen extends ConsumerWidget {
  const DetailsScreen({super.key, required this.data});

  final AlgoData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      drawer: DrawerSideMenu(ref: ref),
      body: Center(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                Expanded(child: DetailsContent(data: data,)),
              ],
            ),
            const Row(
              children: [
                // List of menu options
                Flexible(
                  flex: 1,
                  child: DrawerMenuButton(),
                ),
                // Search and main content
                Flexible(
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
                Flexible(
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
