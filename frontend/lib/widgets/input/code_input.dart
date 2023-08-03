import 'package:flutter/material.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:google_fonts/google_fonts.dart';
// Import the language & theme
import 'package:highlight/languages/python.dart';
import 'package:flutter_highlight/themes/googlecode.dart';

class CodeInput extends StatefulWidget {
  const CodeInput({super.key});

  @override
  State<CodeInput> createState() => _CodeInputState();
}

class _CodeInputState extends State<CodeInput> {
  CodeController? _codeController;

  @override
  void initState() {
    super.initState();
    const source = "# Create a map using GEE API and geemap\nMap = geemap.Map(\n\t\t\tcenter=[21.79, 70.87], \n\t\t\tzoom=3, \n\t\t\tzoom_ctrl=True, \n\t\t\tdata_ctrl=False, \n\t\t\tfullscreen_ctrl=False, \n\t\t\tsearch_ctrl=False, \n\t\t\tdraw_ctrl=False, \n\t\t\tscale_ctrl=False, \n\t\t\tmeasure_ctrl=False, \n\t\t\ttoolbar_ctrl=False, \n\t\t\tlayer_ctrl=False, \n\t\t\tattribution_ctrl=False)\n\nimage = geemap.ee.Image('USGS/SRTMGL1_003')\n\nvis_params = {\n\t\t\t'min': 0, \n\t\t\t'max': 6000, \n\t\t\t'palette': ['006633', 'E5FFCC', '662A00', 'D8D8D8', 'F5F5F5']}\n\nMap.addLayer(image, vis_params, 'SRTM')";
    // Instantiate the CodeController
    _codeController = CodeController(
      text: source,
      language: python,
    );
  }

  @override
  void dispose() {
    _codeController?.dispose();
    super.dispose();
  }

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
                width: 700.0,
                child: CodeTheme(
                  data: const CodeThemeData(styles: googlecodeTheme),
                  child: CodeField(
                    controller: _codeController!,
                    textStyle: GoogleFonts.sourceCodePro(),
                  ),
                ),
              ),
              Container(
                // height: 40.0,
                width: 700.0,
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
                      Text('JS'),
                      Text('Verify'),
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
