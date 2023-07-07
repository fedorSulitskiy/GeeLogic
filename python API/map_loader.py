import ee
import geemap
import os
from ipywidgets import HTML

# geemap.ee_initialize()

# Map = geemap.Map(center=[21.79, 70.87], zoom=3)
# image = ee.Image('USGS/SRTMGL1_003')
# vis_params = {
#     'min': 0,
#     'max': 6000,
#     'palette': ['006633', 'E5FFCC', '662A00', 'D8D8D8', 'F5F5F5'],
# }
# Map.addLayer(image, vis_params, 'SRTM')

# current_directory = os.getcwd()
# download_dir = os.path.abspath(os.path.join(current_directory, '../golden_eye_draft/assets'))

# html_file = os.path.join(download_dir, 'my_map.html')
# Map.to_html(filename=html_file, title='My Map', width='100%', height='300px')


def main():
    # Authorise my GEE account
    geemap.ee_initialize()

    # Create a map using GEE API
    Map = geemap.Map(center=[21.79, 70.87], zoom=3)
    image = ee.Image('USGS/SRTMGL1_003')
    vis_params = {
        'min': 0,
        'max': 6000,
        'palette': ['006633', 'E5FFCC', '662A00', 'D8D8D8', 'F5F5F5'],
    }
    Map.addLayer(image, vis_params, 'SRTM')

    # Get my HTML string
    print(HTML(value = Map.to_html(title='My Map', width='100%', height='300px')).value)
    
if __name__ == '__main__':
    main()