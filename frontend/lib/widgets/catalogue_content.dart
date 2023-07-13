import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:frontend/models/algo_card.dart';
import 'package:frontend/providers/algo_box_selection_provider.dart';
import 'package:frontend/widgets/algo_card.dart';
import 'package:frontend/widgets/details_card.dart';
import 'package:frontend/providers/algo_info_provider.dart';

// List<AlgoCardData> algos = dummyAlgoCardData;

class CatalogueContent extends ConsumerStatefulWidget {
  const CatalogueContent({super.key});

  @override
  ConsumerState<CatalogueContent> createState() => _CatalogueContentState();
}

class _CatalogueContentState extends ConsumerState<CatalogueContent> {

  @override
  Widget build(BuildContext context) {
    final algos = ref.watch(algoInfoProvider);
    final selectedId = ref.watch(algoCardSelectionProvider);
    bool isSelected = false;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Ensures I can scroll beyond the app bar
                const SizedBox(height: 120),
                // The algo cards
                ...List<Widget>.generate(
                  algos.length,
                  (index) {
                    if (selectedId == index) {
                      setState(() {
                        isSelected = true;
                      });
                    } else {
                      setState(() {
                        isSelected = false;
                      });
                    }
                    AlgoCardData data = algos[index];
                    return AlgoCard(data: data, index: index, isSelected: isSelected,);
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          width: 30,
        ),
        ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: const SingleChildScrollView(
            child: Column(
              children: [
                // Ensures I can scroll beyond the app bar
                SizedBox(
                  height: 120,
                ),
                // Details about each algorithm
                DetailsCard(),
              ],
            ),
          ),
        )
      ],
    );
  }
}
