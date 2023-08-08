import 'package:flutter/material.dart';
import 'package:frontend/widgets/_archive/login_details.dart';

const iconGrey = Color.fromARGB(255, 110, 110, 110);
const backgroundColor = Color.fromARGB(255, 254, 251, 255);

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});
  
  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu>
    with TickerProviderStateMixin {
  bool _isOpened = true;
  bool _renderTitle = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 16.0,
        left: 16.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MenuOption(
            title: '',
            icon: Icons.menu,
            onPressed: () {
              if (_isOpened) {
                Future.delayed(const Duration(milliseconds: 300), () {
                  setState(() {
                    _renderTitle = false;
                  });
                });
              } else {
                setState(() {
                  _renderTitle = true;
                });
              }
              setState(() {
                _isOpened = !_isOpened;
              });
            },
            iconSize: 30.0,
            isOpened: _isOpened,
            renderTitle: _renderTitle,
            isMenu: true,
          ),
          _MenuOption(
            title: 'profile',
            icon: Icons.person_outline_rounded,
            onPressed: () {},
            iconSize: 30.0,
            isOpened: _isOpened,
            renderTitle: _renderTitle,
          ),
          _MenuOption(
            title: 'all algorithms',
            icon: Icons.language,
            onPressed: () {},
            iconSize: 30.0,
            isOpened: _isOpened,
            renderTitle: _renderTitle,
          ),
          _MenuOption(
            title: 'python api',
            icon: Icons.javascript,
            onPressed: () {},
            iconSize: 30.0,
            isOpened: _isOpened,
            renderTitle: _renderTitle,
          ),
          _MenuOption(
            title: 'javaScript api',
            icon: Icons.javascript,
            onPressed: () {},
            iconSize: 30.0,
            isOpened: _isOpened,
            renderTitle: _renderTitle,
          ),
          _MenuOption(
            title: 'google earth engine',
            icon: Icons.g_mobiledata_sharp,
            onPressed: () {},
            iconSize: 30.0,
            isOpened: _isOpened,
            renderTitle: _renderTitle,
          ),
          _MenuOption(
            title: 'geemap',
            icon: Icons.g_mobiledata,
            onPressed: () {},
            iconSize: 30.0,
            isOpened: _isOpened,
            renderTitle: _renderTitle,
          ),
          _MenuOption(
            title: 'tutorials',
            icon: Icons.lightbulb_outline_rounded,
            onPressed: () {},
            iconSize: 30.0,
            isOpened: _isOpened,
            renderTitle: _renderTitle,
          ),
          _MenuOption(
            title: 'about',
            icon: Icons.info_outline_rounded,
            onPressed: () {},
            iconSize: 30.0,
            isOpened: _isOpened,
            renderTitle: _renderTitle,
          ),
          Expanded(
            child: Container(
              color: Colors.red,
            ),
          )
        ],
      ),
    );
  }
}

class _MenuOption extends StatefulWidget {
  const _MenuOption({
    required this.title,
    required this.icon,
    required this.onPressed,
    required this.isOpened,
    required this.iconSize,
    required this.renderTitle,
    this.isMenu = false,
  });

  final String title;
  final IconData icon;
  final void Function() onPressed;
  final bool isOpened;
  final double iconSize;
  final bool renderTitle;
  final bool isMenu;

  @override
  State<_MenuOption> createState() => __MenuOptionState();
}

class __MenuOptionState extends State<_MenuOption> {
  // There are two ways of getting width of the text widget in this widget
  // One involves approximating using calculateTextWidth() executed in the build
  // method and the other involves GlobalKey being meddled with in the initState
  Color color = iconGrey;

  final GlobalKey _textKey = GlobalKey();
  double _textWidth = 0.0;
  double _textHeight = 0.0;
  double _approximateWidth = 0.0;

  double calculateTextWidth(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    return textPainter.width;
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Get the size of the Text widget after it has been rendered
      final RenderBox textRenderBox =
          _textKey.currentContext?.findRenderObject() as RenderBox;
      setState(() {
        _textWidth = textRenderBox.size.width;
        _textHeight = textRenderBox.size.height;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _approximateWidth = calculateTextWidth(
          widget.title,
          Theme.of(context).textTheme.labelSmall!.copyWith(
                fontSize: 18.0,
                color: color,
              ),
        ) +
        16.0;

    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
        onTap: widget.onPressed,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: IntrinsicWidth(
          child: MouseRegion(
            onEnter: (event) {
              setState(() {
                color = googleBlue;
              });
            },
            onExit: (event) {
              setState(() {
                color = iconGrey;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(
                    widget.icon,
                    size: widget.iconSize,
                    color: color,
                  ),
                  widget.isMenu
                      ? Container()
                      : AnimatedContainer(
                          duration: const Duration(milliseconds: 1),
                          width: widget.renderTitle ? _approximateWidth : 0.0,
                          child: Stack(
                            children: [
                              Row(
                                key: _textKey,
                                children: [
                                  const SizedBox(width: 8.0),
                                  Text(
                                    widget.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall!
                                        .copyWith(
                                          fontSize: 18.0,
                                          color: color,
                                        ),
                                  ),
                                ],
                              ),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                color: backgroundColor,
                                width: widget.isOpened ? 0.0 : _textWidth,
                                height: _textHeight,
                              ),
                            ],
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
