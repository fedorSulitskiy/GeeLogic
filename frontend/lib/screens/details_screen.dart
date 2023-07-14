import 'package:flutter/material.dart';
import 'package:frontend/models/algo_card.dart';
import 'package:frontend/widgets/algo_details/details_content.dart';
import 'package:frontend/widgets/common/app_bar.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key, required this.data});

  final AlgoCardData data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[

          // Content
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: DetailsContent(data: data),
          ),

          // App Bar
          const Positioned(
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