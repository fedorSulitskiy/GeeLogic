import 'package:flutter/material.dart';
import 'package:frontend/widgets/app_bar.dart';
import 'package:frontend/widgets/catalogue_content.dart';

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
        alignment: Alignment.center,
        children: <Widget>[
          // this will be fill the entire screen
          // Positioned.fill(
          //   child: Image.network('https://i.imgur.com/SJGDZUp.png'),
          // ),

          // Content
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: CatalogueContent(),
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
