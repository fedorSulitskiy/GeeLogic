/// HERE I'M STROING TEMPORARY PLACEHOLDER DATA UNTIL I GET A PROPER BACKEND

const String description =
    '''The Shuttle Radar Topography Mission (SRTM) payload flew aboard the Space Shuttle Endeavour during the STS-99 mission. SRTM collected topographic data over nearly 80% of Earth's land surfaces, creating the first-ever near-global dataset of land elevations.

The SRTM payload consisted of two radar antennas, one located in the shuttle's payload bay and the other installed on the end of a 200-foot mast that extended from the payload bay. Each SRTM radar assembly contained two types of antenna panels: C-band and X-band. C-band radar data were used to create near-global topographic maps of Earth called Digital Elevation Models (DEMs).

Data from the X-band radar were used to create slightly higher resolution DEMs but without the global coverage of the C-band radar. The two radar datasets were combined to create interferogramatic maps of scanned areas. SRTM measurements took place February 11-22, 2000''';

const String code = '''
Map = geemap.Map(center=[21.79, 70.87], zoom=3)
image = ee.Image('USGS/SRTMGL1_003')
vis_params = {
    'min': 0,
    'max': 6000,
    'palette': ['006633', 'E5FFCC', '662A00', 'D8D8D8', 'F5F5F5'],
}
Map.addLayer(image, vis_params, 'SRTM')
          ''';