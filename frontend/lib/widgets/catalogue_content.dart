import 'package:flutter/material.dart';
import 'package:frontend/models/algo_card.dart';

import 'package:frontend/widgets/algo_card.dart';
import 'package:frontend/models/data/algo_card_temp_data.dart';
import 'package:frontend/widgets/placeholders/placeholder_map.dart';

List<AlgoCardData> algos = dummyAlgoCardData;

class CatalogueContent extends StatefulWidget {
  const CatalogueContent({super.key});

  @override
  State<CatalogueContent> createState() => _CatalogueContentState();
}

class _CatalogueContentState extends State<CatalogueContent> {
  @override
  Widget build(BuildContext context) {
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
                    AlgoCardData data = algos[index];
                    return AlgoCard(algoCard: data);
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Ensures I can scroll beyond the app bar
                const SizedBox(
                  height: 120,
                ),
                // Details about each algorithm
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        width: 700,
                        height: 1000,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.blue,
                            width: 3.0,
                          ),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: const Column(
                          children: [
                            Text('Title'),
                            PlaceholderMap(),
                            Text('Description'),
                            Text('bla bla bla bla'),
                            Text('Tags'),
                            Text('Comments'),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
