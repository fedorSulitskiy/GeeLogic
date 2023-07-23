import 'package:flutter/material.dart';

const List<TutorialCard> tutorialCards = [
  TutorialCard(title: 'Cum'),
  TutorialCard(title: 'Piss'),
  TutorialCard(title: 'Shit'),
  TutorialCard(title: 'Dicks'),
  TutorialCard(title: 'Vagina'),
  TutorialCard(title: 'Yo'),
];

class TutorialCard extends StatelessWidget {
  const TutorialCard({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 450.0,
        height: 600.0,
        child: Card(
          color: const Color.fromARGB(255, 255, 255, 240),
          elevation: 10.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              Text('Some details'),
              Text('page indicators')
            ],
          ),
        ),
      ),
    );
  }
}
