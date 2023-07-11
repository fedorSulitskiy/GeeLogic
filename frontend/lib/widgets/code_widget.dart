import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/zenburn.dart';
import 'package:google_fonts/google_fonts.dart';

// Placeholder code
import 'package:frontend/widgets/placeholders/data/placeholder_data.dart';

// Widget to display source code of each algorithms
class CodeDisplayWidget extends StatelessWidget {
  const CodeDisplayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return HighlightView(
      code,
      language: 'python',
      theme: zenburnTheme,
      padding: const EdgeInsets.all(12.0),
      textStyle: GoogleFonts.sourceCodePro(),
    );
  }
}
