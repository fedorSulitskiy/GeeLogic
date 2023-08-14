import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/catalogue_page_selection_provider.dart';
import 'package:frontend/widgets/_archive/login_details.dart';
import 'package:frontend/widgets/user/user_content.dart';

class PageSelection extends ConsumerStatefulWidget {
  const PageSelection({super.key, required this.range});

  final int range;

  @override
  ConsumerState<PageSelection> createState() => _PageSelectionState();
}

class _PageSelectionState extends ConsumerState<PageSelection> {
  @override
  Widget build(BuildContext context) {
    final selectedPage = ref.watch(selectedPageProvider);
    List<int> numbers = [];

    for (int i = 1; i <= widget.range; i++) {
      numbers.add(i);
    }

    return Row(
      children: [
        ...numbers.map(
          (e) => _NumberButton(
            isSelected: selectedPage + 1 == e ? true : false,
            number: e.toString(),
          ),
        ),
      ],
    );
  }
}

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
        color: isSelected ? googleBlue : borderColor,
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
            ref.read(selectedPageProvider.notifier).setPage(int.parse(number) - 1);
          },
          child: SizedBox(
            width: number.length * 15.0,
            child: Center(
              child: Text(
                number,
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: isSelected ? Colors.white : googleBlue,
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
