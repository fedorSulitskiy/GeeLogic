import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/googlecode.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:frontend/widgets/placeholders/data/placeholder_data.dart';

// Widget to display source code of each algorithms
class CodeDisplayWidget extends StatelessWidget {
  const CodeDisplayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Card(
          elevation: 10,
          clipBehavior: Clip.hardEdge,
          child: Column(
            children: [
              SizedBox(
                width: 570.0,
                child: HighlightView(
                  '$code \n\n',
                  language: 'python',
                  theme: googlecodeTheme,
                  padding: const EdgeInsets.all(12.0),
                  textStyle: GoogleFonts.sourceCodePro(),
                ),
              ),
              Container(
                // height: 40.0,
                width: 570.0,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 248, 248, 248),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.zero,
                    topRight: Radius.zero,
                    bottomLeft: Radius.circular(16.0),
                    bottomRight: Radius.circular(16.0),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.only(
                    right: 12.0,
                    left: 12.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Python'),
                      CopyButton(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CopyButton extends StatefulWidget {
  const CopyButton({super.key});

  @override
  CopyButtonState createState() => CopyButtonState();
}

class CopyButtonState extends State<CopyButton> {
  bool isCopied = false;

  void _copyToClipboard() {
    setState(() {
      isCopied = true;
    });

    Clipboard.setData(const ClipboardData(text: code));

    Timer(const Duration(seconds: 3), () {
      setState(() {
        isCopied = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: isCopied
          ? const Text('Copied!')
          : const Icon(
              Icons.copy,
              size: 20.0,
            ),
      onPressed: _copyToClipboard,
    );
  }
}
