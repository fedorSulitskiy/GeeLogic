import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/tags_provider.dart';

class TagBubble extends ConsumerStatefulWidget {
  const TagBubble({super.key, required this.title, required this.id, this.isExpandable = true});

  final String title;
  final int id;
  final bool isExpandable;

  @override
  ConsumerState<TagBubble> createState() => _TagBubbleState();
}

class _TagBubbleState extends ConsumerState<TagBubble> {
  bool _isTapped = false;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.purple, Colors.blue],
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            splashColor: Colors.white.withOpacity(0.5),
            onTap: () {
              setState(() {
                _isTapped = !_isTapped;
              });
            },
            child: Container(
              padding: _isTapped && widget.isExpandable
                  ? const EdgeInsets.only(
                      left: 10.0,
                      right: 0.0,
                      top: 2.0,
                      bottom: 2.0,
                    )
                  : const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
              child: Row(
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      widget.title,
                      style:
                          const TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                  ),
                  if (_isTapped && widget.isExpandable)
                    SizedBox(
                      height: 22.0,
                      width: 22.0,
                      child: IconButton(
                        padding: const EdgeInsets.all(0.0),
                        onPressed: () {
                          ref
                              .read(selectedTagsProvider.notifier)
                              .removeTag(widget.id);
                        },
                        icon: const Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                          size: 14.0,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
