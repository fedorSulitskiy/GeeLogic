import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/zenburn.dart';
import 'package:google_fonts/google_fonts.dart';

// Widget to display source code of each algorithms
class CodeDisplayWidget extends StatelessWidget {
  const CodeDisplayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return HighlightView(
      '''
Map = geemap.Map(center=[21.79, 70.87], zoom=3)
image = ee.Image('USGS/SRTMGL1_003')
vis_params = {
    'min': 0,
    'max': 6000,
    'palette': ['006633', 'E5FFCC', '662A00', 'D8D8D8', 'F5F5F5'],
}
Map.addLayer(image, vis_params, 'SRTM')
          ''',
      language: 'python',
      theme: zenburnTheme,
      padding: const EdgeInsets.all(12.0),
      textStyle: GoogleFonts.sourceCodePro(),
    );
  }
}
