import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/algo_selection_provider.dart';

import 'package:frontend/providers/catalogue_page_selection_provider.dart';
import 'package:frontend/app_theme.dart';

/// The widget responsible for page selection in the [CatalogueContent] widget.
class PageSelection extends ConsumerStatefulWidget {
  const PageSelection({super.key, required this.range});

  /// Range is the number of pages required to show all algorithms loaded
  /// from the backend.
  final int range;

  @override
  ConsumerState<PageSelection> createState() => _PageSelectionState();
}

class _PageSelectionState extends ConsumerState<PageSelection> {
  @override
  Widget build(BuildContext context) {
    /// The index of the page selected by the user.
    final selectedPage = ref.watch(selectedPageProvider);
    List<int> numbers = [];

    // Generate a list of numbers from 1 to the range of the page selection.
    for (int i = 1; i <= widget.range; i++) {
      numbers.add(i);
    }

    return Row(
      children: [
        ...numbers.map(
          (e) => _NumberButton(
            // Adjust the selectedPage by one since it represents the index not the
            // actual page number.
            isSelected: selectedPage + 1 == e ? true : false,
            number: e.toString(),
          ),
        ),
      ],
    );
  }
}

/// The button with the number of the page.
class _NumberButton extends ConsumerWidget {
  const _NumberButton({
    required this.isSelected,
    required this.number,
  });

  final bool isSelected;
  final String number;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: isSelected
            ? GeeLogicColourScheme.blue
            : GeeLogicColourScheme.borderGrey,
      ),
      margin: const EdgeInsets.only(
        top: 4.0,
        right: 4.0,
        left: 4.0,
      ),
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Set the index of selected algorithm to 0 to show the first algorithm by default.
            ref.read(selectedAlgoIndexProvider.notifier).selectCard(0);
            // Set the selected page to the page selected by the user.
            ref
                .read(selectedPageProvider.notifier)
                .setPage(int.parse(number) - 1);
          },
          child: SizedBox(
            width: number.length * 15.0,
            child: Center(
              child: Text(
                number,
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color:
                          isSelected ? Colors.white : GeeLogicColourScheme.blue,
                      fontSize: 24.0,
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
