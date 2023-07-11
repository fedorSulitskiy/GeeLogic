import 'package:flutter/material.dart';
import 'package:frontend/widgets/appBar.dart';

class CatalogueScreen extends StatefulWidget {
  const CatalogueScreen({super.key});

  @override
  State<CatalogueScreen> createState() => _CatalogueScreenState();
}

class _CatalogueScreenState extends State<CatalogueScreen> {
  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        CustomAppBar(),
      ],
    );
  }
}