import 'package:flutter/material.dart';

/// The content of the [AboutScreen] widget.
class AboutContent extends StatelessWidget {
  const AboutContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 25.0, width: MediaQuery.of(context).size.width),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'About ',
                  style: TextStyle(fontSize: 50.0, height: -1),
                ),
                Image.asset(
                  'assets/logo_bold.png',
                  width: 400.0,
                  // height: 40.0,
                ),
              ],
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: const Divider(),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Text(
                'This project aims to develop a proof-of-concept service for '
                'researchers and developers to easily share their algorithms in '
                'the area of Earth Observation. GeeLogic, as it was named, utilises '
                'Google Earth Engine API to rapidly access the results of these '
                'algorithms, allowing for immediate user intractability.',
                style: Theme.of(context).textTheme.bodyLarge!),
          ),
          const SizedBox(height: 15.0),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Text(
                'Ever since the first images of Earth were taken from outer space in '
                '1947 researchers and scientists have found ways to extract useful '
                'information from them and apply it. Space technologies and orbital '
                'imagery applications have become integral tools for supporting the '
                'lifestyle of hundreds of millions of people, from climate '
                'forecasting to state security. However, despite developing for the '
                'last 76 years this industry’s growth is only accelerating due to '
                'increasing accessibility of space to private companies and greater '
                'amount of better and more easily accessible data.',
                style: Theme.of(context).textTheme.bodyLarge!),
          ),
          const SizedBox(height: 15.0),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Text(
                'Earth observation industry along with the rest of the Space Industry '
                'is going through a quiet renaissance. Hence this project aims to '
                'contribute to this incredible development. ',
                style: Theme.of(context).textTheme.bodyLarge!),
          ),
          const SizedBox(height: 15.0),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Text(
                'Google Earth Engine (GEE) is a powerful cloud computing service '
                'that aims to gather most freely available sources of Earth '
                'observation imagery such as the data from the Landsat and '
                'Sentinel satellites. It allows real time analysis and extraction of '
                'data, driving innovation trough making access to relevant data very '
                'easy. geemap is a python package that provides easy access to '
                'GEE’s API in python! Many professional researchers use both GEE '
                'and geemap for their studies, '
                'however there is a notable absence of a dedicated platform to '
                'accessibly share their findings. This is where GeeLogic (Google '
                'Earth Engine Logic) serves to fill this demand!',
                style: Theme.of(context).textTheme.bodyLarge!),
          ),
          const SizedBox(height: 30.0),
        ],
      ),
    );
  }
}
