import 'package:frontend/models/algo_card.dart';
import 'package:frontend/widgets/placeholders/data/placeholder_data.dart';

final dummyAlgoCardData = [
  AlgoCardData(
    id: '1',
    title: 'NDVI over San Francisco',
    upVotes: 100,
    downVotes: 50,
    datePosted: DateTime(2023, 1, 21, 0, 0, 0),
    isBookmarked: true,
    image:
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSKe1LOSORO2tu42pb3kvxjBR906eTkxCFFGA&usqp=CAU",
    description: loremIpsum5,
  ),
  AlgoCardData(
    id: '2',
    title: 'Green Leaf Index in Nepal',
    upVotes: 200,
    downVotes: 100,
    datePosted: DateTime(2023, 1, 21, 0, 0, 0),
    isBookmarked: false,
    image:
        "https://images.squarespace-cdn.com/content/v1/59fc9bdfcd39c3f5ace09221/1548309805813-QLBHVE1C8AORIKQMK1ZP/RVI.jpg",
    description: loremIpsum2,
  ),
  AlgoCardData(
    id: '3',
    title: 'VARI',
    upVotes: 50,
    downVotes: 100,
    datePosted: DateTime(2023, 1, 21, 0, 0, 0),
    isBookmarked: false,
    image:
        "https://upload.wikimedia.org/wikipedia/commons/4/45/Dem.jpg",
    description: loremIpsum7,
  ),
  AlgoCardData(
    id: '4',
    title: 'Spectral Index GLSNA',
    upVotes: 40,
    downVotes: 100,
    datePosted: DateTime(2023, 1, 21, 0, 0, 0),
    isBookmarked: false,
    image:
        "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Fortaleza%2C_centro_da_cidade_e_aeroporto.JPG/1280px-Fortaleza%2C_centro_da_cidade_e_aeroporto.JPG",
    description: loremIpsum5,
  ),
  AlgoCardData(
    id: '5',
    title: 'Segmentation',
    upVotes: 1200,
    downVotes: 200,
    datePosted: DateTime(2023, 1, 21, 0, 0, 0),
    isBookmarked: true,
    image:
        "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e4/Crops_Kansas_AST_20010624.jpg/1024px-Crops_Kansas_AST_20010624.jpg",
    description: loremIpsum2,
  ),
];
