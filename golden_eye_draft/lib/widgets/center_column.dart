import 'package:flutter/material.dart';
import 'package:golden_eye_draft/widgets/code_widget.dart';
import 'package:golden_eye_draft/widgets/gee_map_widget.dart';

const String description =
    '''The Shuttle Radar Topography Mission (SRTM) payload flew aboard the Space Shuttle Endeavour during the STS-99 mission. SRTM collected topographic data over nearly 80% of Earth's land surfaces, creating the first-ever near-global dataset of land elevations.

The SRTM payload consisted of two radar antennas, one located in the shuttle's payload bay and the other installed on the end of a 200-foot mast that extended from the payload bay. Each SRTM radar assembly contained two types of antenna panels: C-band and X-band. C-band radar data were used to create near-global topographic maps of Earth called Digital Elevation Models (DEMs).

Data from the X-band radar were used to create slightly higher resolution DEMs but without the global coverage of the C-band radar. The two radar datasets were combined to create interferogramatic maps of scanned areas. SRTM measurements took place February 11-22, 2000''';

class CenterColumn extends StatefulWidget {
  const CenterColumn({super.key});

  @override
  State<CenterColumn> createState() => _CenterColumnState();
}

class _CenterColumnState extends State<CenterColumn> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Title',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Theme.of(context).colorScheme.primary),
          ),
          const MapWidget(),
          // const PlaceholderMap(),
          const Card(
            clipBehavior: Clip.hardEdge,
            child: SizedBox(
              width: 500,
              child: CodeDisplayWidget(),
            ),
          ),
          const SizedBox(height: 15,),
          const PlaceholderCard(title: description),
          const PlaceholderCard(title: 'Tags or sth'),
        ],
      ),
    );
  }
}

class PlaceholderMap extends StatelessWidget {
  const PlaceholderMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      width: 700,
      color: Colors.blue,
    );
  }
}

class PlaceholderCard extends StatelessWidget {
  const PlaceholderCard({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: Container(
            padding: const EdgeInsets.all(10),
            width: 500,
            child: Center(child: Text(title)),
          ),
        ),
        const SizedBox(
          height: 15,
        )
      ],
    );
  }
}
