import 'package:flutter/material.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/code_provider.dart';
import 'package:frontend/widgets/_archive/login_details.dart';
import 'package:frontend/widgets/input/input_content.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlight/languages/python.dart';
import 'package:highlight/languages/javascript.dart';
import 'package:flutter_highlight/themes/googlecode.dart';

import 'package:frontend/widgets/input/verify_button.dart';

const workingCode =
    "# Create a map using GEE API and geemap\nMap = geemap.Map(\n\t\t\tcenter=[21.79, 70.87], \n\t\t\tzoom=3, \n\t\t\tzoom_ctrl=True, \n\t\t\tdata_ctrl=False, \n\t\t\tfullscreen_ctrl=False, \n\t\t\tsearch_ctrl=False, \n\t\t\tdraw_ctrl=False, \n\t\t\tscale_ctrl=False, \n\t\t\tmeasure_ctrl=False, \n\t\t\ttoolbar_ctrl=False, \n\t\t\tlayer_ctrl=False, \n\t\t\tattribution_ctrl=False)\n\nimage = geemap.ee.Image('USGS/SRTMGL1_003')\n\nvis_params = {\n\t\t\t'min': 0, \n\t\t\t'max': 6000, \n\t\t\t'palette': ['006633', 'E5FFCC', '662A00', 'D8D8D8', 'F5F5F5']}\n\nMap.addLayer(image, vis_params, 'SRTM')";

class CodeInput extends ConsumerStatefulWidget {
  const CodeInput({super.key});

  @override
  ConsumerState<CodeInput> createState() => _CodeInputState();
}

class _CodeInputState extends ConsumerState<CodeInput> {
  CodeController? _codeController;
  final _language = python;
  var _isPython = true;
  var _codeChanged = false;

  @override
  void initState() {
    super.initState();
    const source = workingCode;
    //  "print('Hello Google Earth Engine!')";
    // Instantiate the CodeController
    _codeController = CodeController(
      text: source,
      language: _language,
    );
  }

  @override
  void dispose() {
    _codeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentCode = ref.watch(codeProvider);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Card(
          elevation: 2,
          clipBehavior: Clip.hardEdge,
          child: Column(
            children: [
              SizedBox(
                width: 900.0,
                child: CodeTheme(
                  data: const CodeThemeData(styles: googlecodeTheme),
                  child: CodeField(
                    controller: _codeController!,
                    textStyle: GoogleFonts.sourceCodePro(),
                    onChanged: (code) {
                      ref.read(codeProvider.notifier).getCode(code);
                      ref.read(isValidProvider.notifier).setValid(null);
                      setState(() {
                        _codeChanged = true;
                      });
                    },
                  ),
                ),
              ),
              Container(
                // height: 40.0,
                width: 900.0,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 248, 248, 248),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.zero,
                    topRight: Radius.zero,
                    bottomLeft: Radius.circular(16.0),
                    bottomRight: Radius.circular(16.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 12.0,
                    left: 12.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Python or JavaScript API
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isPython = true;
                                _codeController!.language = python;
                                _codeController!.text = _codeChanged ? currentCode : "print('Hello Google Earth Engine!')";
                              });
                            },
                            child: Text(
                              '<< Python',
                              style: GoogleFonts.sourceCodePro(
                                color: _isPython ? googleBlue : Colors.black87,
                              ),
                            ),
                          ),
                          Text(
                            '/',
                            style: GoogleFonts.sourceCodePro(
                                fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isPython = false;
                                _codeController!.language = javascript;
                                _codeController!.text = _codeChanged ? currentCode : "console.log('Hello Google Earth Engine!');";
                              });
                            },
                            child: Text(
                              'JavaScript >>',
                              style: GoogleFonts.sourceCodePro(
                                color:
                                    _isPython ? Colors.black87 : googleYellow,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Verify code
                      const VerifyButton(),
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
