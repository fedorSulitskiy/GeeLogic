import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Colours unique to App Bar (for now)
const Color defaultColour = Color.fromARGB(255, 30, 30, 30);
const Color dividerColour = Color.fromARGB(255, 161, 161, 161);
const Color onHoverColour = Color.fromARGB(255, 66, 133, 244);
const Color eyeLogoColour = Color.fromARGB(255, 255, 187, 0);

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({super.key});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
          ],
        ),
        const SizedBox(
          height: 64,
          width: 960,
          child: Card(
            elevation: 10.0,
            surfaceTintColor: Colors.white,
            shape: BeveledRectangleBorder(),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MenuButton(text: 'Tutorials'),
                VerticalDivider(
                    color: dividerColour,
                    thickness: 1,
                    endIndent: 15,
                    indent: 15,
                    width: 1),
                MenuButton(text: 'Indices'),
                VerticalDivider(
                    color: dividerColour,
                    thickness: 1,
                    endIndent: 15,
                    indent: 15,
                    width: 1),
                MenuButton(text: 'Algos'),
                EyeLogo(),
                MenuButton(text: 'GEE'),
                VerticalDivider(
                    color: dividerColour,
                    thickness: 1,
                    endIndent: 15,
                    indent: 15,
                    width: 1),
                MenuButton(text: 'geemap'),
                VerticalDivider(
                    color: dividerColour,
                    thickness: 1,
                    endIndent: 15,
                    indent: 15,
                    width: 1),
                MenuButton(text: 'About'),
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
            IconButton(
              onPressed: () {
                // TODO: use this button properly and migrate the signout
                //  button elsewhere
                FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.person),
            ),
          ],
        ),
      ],
    );
  }
}

class MenuButton extends StatefulWidget {
  const MenuButton({super.key, required this.text});

  final String text;

  @override
  State<MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton> {
  Color textColour = defaultColour;

  void _onExit(PointerEvent details) {
    setState(() {
      textColour = defaultColour;
    });
  }

  void _onHover(PointerEvent details) {
    setState(() {
      textColour = onHoverColour;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: _onHover,
      onExit: _onExit,
      child: TextButton(
        onPressed: () {},
        child: Text(
          widget.text,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: textColour,
              ),
        ),
      ),
    );
  }
}

class EyeLogo extends StatelessWidget {
  const EyeLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 72,
      decoration: const BoxDecoration(
        color: eyeLogoColour,
        borderRadius: BorderRadius.all(
          Radius.circular(100),
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.remove_red_eye,
          size: 50,
          color: Colors.white,
        ),
      ),
    );
  }
}
