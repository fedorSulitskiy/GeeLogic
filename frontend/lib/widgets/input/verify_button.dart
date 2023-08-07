import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/map_html_code_provider.dart';
import 'package:frontend/widgets/input/input_content.dart';
import 'package:http/http.dart' as http;

import 'package:frontend/providers/code_provider.dart';

const double borderRadius = 15.0;
const List<double> buttonDimensions = [32.0, 80.0];

class VerifyButton extends ConsumerStatefulWidget {
  const VerifyButton({super.key});

  @override
  ConsumerState<VerifyButton> createState() => _SignInButtonState();
}

class _SignInButtonState extends ConsumerState<VerifyButton> {
  List<Color> colorList = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow
  ];
  List<Alignment> alignmentList = [
    Alignment.bottomLeft,
    Alignment.bottomRight,
    Alignment.topRight,
    Alignment.topLeft,
  ];
  int index = 0;
  Color bottomColor = Colors.red;
  Color topColor = Colors.yellow;
  Alignment begin = Alignment.bottomLeft;
  Alignment end = Alignment.topRight;

  var _isLoading = false;
  // dynamic _isValid = Null;

  SnackBar snackBar({
    required Color color,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return SnackBar(
      backgroundColor: color,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 45.0,
          ),
          const SizedBox(width: 5.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Text(
                subtitle,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Colors.white),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 2), () {
      ref.read(isValidProvider.notifier).setValid(null);
      if (mounted) {
        setState(() {
          bottomColor = Colors.blue;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final code = ref.watch(codeProvider);
    final isValid = ref.watch(isValidProvider);
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Center(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            AnimatedContainer(
              height: buttonDimensions[0],
              width: buttonDimensions[1],
              duration: const Duration(seconds: 2),
              curve: Curves.linear,
              onEnd: () {
                setState(() {
                  index = index + 1;
                  // animate the color
                  bottomColor = colorList[index % colorList.length];
                  topColor = colorList[(index + 1) % colorList.length];

                  // animate the alignment
                  begin = alignmentList[index % alignmentList.length];
                  end = alignmentList[(index + 2) % alignmentList.length];
                });
              },
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.all(Radius.circular(borderRadius)),
                gradient: LinearGradient(
                  begin: begin,
                  end: end,
                  colors: [bottomColor, topColor],
                ),
              ),
            ),
            SizedBox(
              height: buttonDimensions[0],
              width: buttonDimensions[1],
              child: TextButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(borderRadius)),
                    ),
                  ),
                ),
                onPressed: () async {
                  if (code.isEmpty) {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      snackBar(
                        color: googleYellow,
                        icon: Icons.warning_rounded,
                        subtitle: "Please submit new code!",
                        title: "Empty code",
                      ),
                    );
                    return;
                  }

                  final messenger = ScaffoldMessenger.of(context);

                  setState(() {
                    _isLoading = true;
                    colorList = [
                      Colors.red,
                      Colors.blue,
                      Colors.green,
                      Colors.yellow
                    ];
                  });
                  final url = Uri.parse('http://127.0.0.1:3001/get_map_widget');
                  final headers = {
                    'Content-Type': 'application/x-www-form-urlencoded'
                  };
                  final body = {'code': code};

                  final response =
                      await http.post(url, headers: headers, body: body);
                  ref
                      .read(mapWidgetHTMLCodeProvider.notifier)
                      .getCode(response.body);

                  setState(() {
                    _isLoading = false;
                  });

                  if (response.statusCode == 200) {
                    // Request was successful, handle the response here
                    ref.read(isValidProvider.notifier).setValid(true);
                    setState(() {
                      colorList = const [
                        Color.fromARGB(255, 59, 183, 143),
                        Color.fromARGB(255, 11, 171, 100),
                      ];
                    });
                    messenger.clearSnackBars();
                    messenger.showSnackBar(
                      snackBar(
                        color: googleGreen,
                        icon: Icons.check_circle_outline_outlined,
                        subtitle: "Perfect, you can submit the algorithm!",
                        title: "Code Verified",
                      ),
                    );
                  } else {
                    // Request failed, handle the error here
                    print('Error: ${response.statusCode}');
                    setState(() {
                      // _isValid = false;
                      ref.read(isValidProvider.notifier).setValid(false);
                      colorList = const [
                        Color.fromARGB(255, 217, 131, 36),
                        Color.fromARGB(255, 164, 6, 6),
                      ];
                    });
                    messenger.clearSnackBars();
                    messenger.showSnackBar(
                      snackBar(
                        color: googleRed,
                        icon: Icons.error_outline_rounded,
                        subtitle:
                            "Please try to rewrite your code to specification!",
                        title: "Invalid code",
                      ),
                    );
                  }
                },
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: child,
                    );
                  },
                  child: _isLoading
                      ? const SizedBox(
                          height: 25.0,
                          width: 25.0,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : isValid.isValid.isNull
                          ? Text(
                              'Verify',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                      color: Colors.white, fontSize: 20.0),
                            )
                          : isValid.isValid!
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 25.0,
                                )
                              : const Icon(
                                  Icons.clear,
                                  color: Colors.white,
                                  size: 25.0,
                                ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
