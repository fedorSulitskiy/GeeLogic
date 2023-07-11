import 'package:flutter/material.dart';
import 'package:frontend/widgets/app_bar.dart';

class CatalogueScreen extends StatefulWidget {
  const CatalogueScreen({super.key});

  @override
  State<CatalogueScreen> createState() => _CatalogueScreenState();
}

class _CatalogueScreenState extends State<CatalogueScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: <Widget>[
          // this will be fill the entire screen
          // Positioned.fill(
          //   child: Image.network('https://i.imgur.com/SJGDZUp.png'),
          // ),

          Positioned(
            top: 85,
            child: Expanded(
              child: Center(
                child: Text('Body of my catalogue'),
              ),
            ),
          ),

          // App Bar
          Positioned(
            top: 15,
            left: 50,
            right: 50,
            child: CustomAppBar(),
          ),
        ],
      ),
    );
  }
}
