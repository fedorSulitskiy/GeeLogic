import 'package:flutter/material.dart';

import 'package:frontend/models/algo_data.dart';
import 'package:frontend/widgets/common/app_bar/add_algorithm_button.dart';
import 'package:frontend/widgets/common/app_bar/search_gee_logic_bar.dart';
import 'package:frontend/widgets/common/app_bar/side_menu.dart';
import 'package:frontend/widgets/edit/edit_content.dart';

/// Screen for editing the selected algorithm
class EditScreen extends StatelessWidget {
  const EditScreen({super.key, required this.data});

  final AlgoData data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          children: [
            // List of menu options
            const Flexible(
              flex: 1,
              child: SideMenu(),
            ),
            // Search and main content
            Flexible(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SearchGeeLogicBar(),
                  Expanded(child: EditContent(algoData: data)),
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
      ),
    );
  }
}
