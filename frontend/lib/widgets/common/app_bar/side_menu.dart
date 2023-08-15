import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/helpers/custom_icons/custom_icons_icons.dart';
import 'package:frontend/providers/catalogue_api_provider.dart';
import 'package:frontend/providers/catalogue_page_selection_provider.dart';
import 'package:frontend/screens/about_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:frontend/screens/catalogue_screen.dart';
import 'package:frontend/screens/tutorial_screen.dart';
import 'package:frontend/screens/user_screen.dart';
import 'package:frontend/widgets/_archive/login_details.dart';

const iconGrey = Color.fromARGB(255, 110, 110, 110);
const backgroundColor = Color.fromARGB(255, 254, 251, 255);

/// Displays the menu of options visible on the left side of the screen.
class SideMenu extends ConsumerStatefulWidget {
  const SideMenu({super.key});

  @override
  ConsumerState<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends ConsumerState<SideMenu> with TickerProviderStateMixin {
  /// Indicates if the menu is "opened" (is the text visible or are just icons shown)
  bool _isOpened = true;

  /// Secondary to _isOpened as it controls if the [AnimatedContainer]
  /// containing the text has width of 0.0 or not.
  bool _renderTitle = true;

  final Uri geemapURL = Uri.parse('https://geemap.org/');
  final Uri googleEarthEngineURL = Uri.parse('https://earthengine.google.com/');

  _launchURL(url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10.0,
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
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const UserScreen(),
              ));
            },
            iconSize: 30.0,
            isOpened: _isOpened,
            renderTitle: _renderTitle,
          ),
          _MenuOption(
            title: 'all algorithms',
            icon: Icons.language,
            onPressed: () {
              ref.read(catalogueSelectedApiProvider.notifier).selectApi("0,1");
              ref.read(selectedPageProvider.notifier).setPage(0);
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const CatalogueScreen(),
              ));
            },
            iconSize: 30.0,
            isOpened: _isOpened,
            renderTitle: _renderTitle,
          ),
          _MenuOption(
            title: 'python api',
            icon: CustomIcons.python,
            onPressed: () {
              ref.read(catalogueSelectedApiProvider.notifier).selectApi("1");
              ref.read(selectedPageProvider.notifier).setPage(0);
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const CatalogueScreen(),
              ));
            },
            iconSize: 30.0,
            isOpened: _isOpened,
            renderTitle: _renderTitle,
          ),
          _MenuOption(
            title: 'javaScript api',
            icon: CustomIcons.jsSquare,
            onPressed: () {
              ref.read(catalogueSelectedApiProvider.notifier).selectApi("0");
              ref.read(selectedPageProvider.notifier).setPage(0);
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const CatalogueScreen(),
              ));
            },
            iconSize: 30.0,
            isOpened: _isOpened,
            renderTitle: _renderTitle,
          ),
          _MenuOption(
            title: 'earth engine',
            icon: CustomIcons.google,
            onPressed: () {
              _launchURL(googleEarthEngineURL);
            },
            iconSize: 30.0,
            isOpened: _isOpened,
            renderTitle: _renderTitle,
          ),
          _MenuOption(
            title: 'geemap',
            icon: CustomIcons.geemap,
            onPressed: () {
              _launchURL(geemapURL);
            },
            iconSize: 30.0,
            isOpened: _isOpened,
            renderTitle: _renderTitle,
          ),
          _MenuOption(
            title: 'tutorials',
            icon: Icons.lightbulb_outline_rounded,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const TutorialScreen(),
              ));
            },
            iconSize: 30.0,
            isOpened: _isOpened,
            renderTitle: _renderTitle,
          ),
          _MenuOption(
            title: 'about',
            icon: Icons.info_outline_rounded,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const AboutScreen(),
              ));
            },
            iconSize: 30.0,
            isOpened: _isOpened,
            renderTitle: _renderTitle,
          ),
          Expanded(child: Container())
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
    this.iconContainerSize,
  });

  final String title;
  final IconData icon;
  final void Function() onPressed;
  final bool isOpened;
  final double iconSize;
  final bool renderTitle;
  final bool isMenu;
  final double? iconContainerSize;

  @override
  State<_MenuOption> createState() => __MenuOptionState();
}

class __MenuOptionState extends State<_MenuOption> {
  Color color = iconGrey;
  double _approximateWidth = 0.0;

  double calculateTextWidth(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    return textPainter.width;
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
                                width:
                                    widget.isOpened ? 0.0 : _approximateWidth,
                                height: 24,
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
