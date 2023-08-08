import 'package:flutter/material.dart';

import 'package:frontend/widgets/common/app_bar/add_algorithm_button.dart';
import 'package:frontend/widgets/common/app_bar/search_gee_logic_bar.dart';
import 'package:frontend/widgets/common/app_bar/side_menu.dart';

class NewAppBarTest extends StatelessWidget {
  const NewAppBarTest({super.key});

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
                  Expanded(
                    child: Container(
                      color: Colors.yellow,
                    ),
                  )
                ],
              ),
            ),
            // Add Button
            Flexible(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const AddAlgorithmButton(),
                  Expanded(
                    child: Container(
                      color: Colors.blue,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
