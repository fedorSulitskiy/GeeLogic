import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:frontend/models/algo_data.dart';
import 'package:frontend/providers/algo_selection_provider.dart';
import 'package:frontend/providers/catalogue_api_provider.dart';
import 'package:frontend/providers/catalogue_page_selection_provider.dart';
import 'package:frontend/widgets/catalogue/algo_card.dart';
import 'package:frontend/widgets/catalogue/details_card.dart';
import 'package:frontend/providers/algo_info_provider.dart';
import 'package:frontend/widgets/catalogue/page_selection.dart';
import 'package:frontend/widgets/common/loading_star.dart';

/// The content of the [CatalogueScreen] widget.
class CatalogueContent extends ConsumerStatefulWidget {
  const CatalogueContent({super.key});

  @override
  ConsumerState<CatalogueContent> createState() => _CatalogueContentState();
}

class _CatalogueContentState extends ConsumerState<CatalogueContent> {
  @override
  Widget build(BuildContext context) {
    /// The offset to be sent to the backend to retrieve the next 5 algorithms,
    /// for pagination.
    final offset = ref.watch(selectedPageProvider);
    /// The API selected by the user to filter the algorithms by. If the user
    /// chose 'all algorithms' page, then this will be '0,1' if 'python api' page
    /// is selected then it will be '1' and if 'javascript api' page is selected then
    /// it will be '0'.
    final selectedApi = ref.watch(catalogueSelectedApiProvider);
    /// The index of the algorithm card that is currently selected. This is used
    /// to show the selection aura around the selected card, and to show the details
    /// of the selected algorithm in the [DetailsCard] widget.
    final selectedIndex = ref.watch(selectedAlgoIndexProvider);
    /// The parameters to be sent to the backend to retrieve the algorithms according
    /// to custom ordering and filtering.
    /// TODO: Currently it's hardcoded but it leaves potential for more comprehensive filtering
    final params = json.encode({
      "offset": offset * 5,
      "orderCondition": 'date_created',
      "apiCondition": selectedApi
    });
    /// The algorithms retrieved from the backend according to the parameters
    final algosFromBackend = ref.watch(
      allAlgorithmsProvider(params),
    );
    /// Whether the user has selected an algorithm or not. This is used to show
    /// the selection aura around the selected card.
    bool isSelected = false;

    return algosFromBackend.when(
      data: (algosFromBackend) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Scrollable column of AlgoCard widgets for user selection
            ScrollConfiguration(
              behavior:
                  ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Ensures I can scroll beyond the app bar
                    const SizedBox(height: 25),
                    // The algo cards
                    ...List<Widget>.generate(
                      algosFromBackend['results'].length,
                      (index) {
                        // Data gathered from the backend
                        AlgoData data = algosFromBackend['results'][index];

                        // Visually determines which card is selected, by setting
                        // the selection aura to on depending on the selectionIndex
                        if (selectedIndex == index) {
                          setState(() {
                            isSelected = true;
                          });
                        } else {
                          setState(() {
                            isSelected = false;
                          });
                        }

                        // Display the AlgoCard widget
                        return AlgoCard(
                          data: data,
                          index: index,
                          isSelected: isSelected,
                        );
                      },
                    ),

                    // The page selection widget
                    PageSelection(
                        range: (algosFromBackend['count'] / 5).ceil()),
                    const SizedBox(height: 25),
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 30,
            ),
            // Scrollable column of DetailsCard widget with details of the selected
            // algorithm.
            ScrollConfiguration(
              behavior:
                  ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Ensures I can scroll beyond the app bar
                    const SizedBox(height: 25),
                    // Details about each algorithm
                    DetailsCard(loadedAlgos: algosFromBackend['results']),
                    const SizedBox(height: 25),
                  ],
                ),
              ),
            )
          ],
        );
      },
      error: (err, stack) => Text('Error: $err'),
      loading: () => const Center(child: LoadingStar()),
    );
  }
}
