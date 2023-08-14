import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:frontend/models/algo_data.dart';
import 'package:frontend/providers/algo_selection_provider.dart';
import 'package:frontend/providers/catalogue_page_selection_provider.dart';
import 'package:frontend/widgets/catalogue/algo_card.dart';
import 'package:frontend/widgets/catalogue/details_card.dart';
import 'package:frontend/providers/algo_info_provider.dart';
import 'package:frontend/widgets/catalogue/page_selection.dart';
import 'package:frontend/widgets/common/loading_star.dart';

class CatalogueContent extends ConsumerStatefulWidget {
  const CatalogueContent({super.key});

  @override
  ConsumerState<CatalogueContent> createState() => _CatalogueContentState();
}

class _CatalogueContentState extends ConsumerState<CatalogueContent> {

  @override
  Widget build(BuildContext context) {
    final offset = ref.watch(selectedPageProvider);
    final selectedIndex = ref.watch(selectedAlgoIndexProvider);
    final algosFromBackend = ref.watch(allAlgorithmsProvider(offset*5));
    bool isSelected = false;

    return algosFromBackend.when(
      data: (algosFromBackend) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                        AlgoData data = algosFromBackend['results'][index];

                        if (selectedIndex == index) {
                          setState(() {
                            isSelected = true;
                          });
                        } else {
                          setState(() {
                            isSelected = false;
                          });
                        }

                        return AlgoCard(
                          data: data,
                          index: index,
                          isSelected: isSelected,
                        );
                      },
                    ),
                    PageSelection(range: (algosFromBackend['count'] / 5).ceil())
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 30,
            ),
            ScrollConfiguration(
              behavior:
                  ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Ensures I can scroll beyond the app bar
                    const SizedBox(
                      height: 25,
                    ),
                    // Details about each algorithm
                    DetailsCard(loadedAlgos: algosFromBackend['results']),
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
