import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:frontend/widgets/common/app_bar/add_algorithm_button.dart';
import 'package:frontend/widgets/common/app_bar/drawer_side_menu.dart';
import 'package:frontend/widgets/common/app_bar/search_gee_logic_bar.dart';
import 'package:frontend/widgets/common/app_bar/side_menu.dart';

import 'package:frontend/widgets/catalogue/catalogue_content.dart';

/// The screen that displays the catalogue page.
class CatalogueScreen extends ConsumerStatefulWidget {
  const CatalogueScreen({super.key});

  @override
  ConsumerState<CatalogueScreen> createState() => _CatalogueScreenState();
}

class _CatalogueScreenState extends ConsumerState<CatalogueScreen> {
  @override
  Widget build(BuildContext context) {
    /// Responsive design element to extract current screensize
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      drawer: screenSize.width > 670 ? null :  DrawerSideMenu(ref: ref),
      body: Center(
        child: Stack(
          children: [
            const Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 60),
                Expanded(child: CatalogueContent()),
              ],
            ),
            Row(
              children: [
                // List of menu options
                Flexible(
                  flex: 14,
                  child: screenSize.width > 670 ? const SideMenu() : const DrawerMenuButton(),
                ),
                // Search and main content
                const Flexible(
                  flex: 75,
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
                  flex: 14,
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
