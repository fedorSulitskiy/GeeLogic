from flask import Flask
from flask_cors import CORS
import geemap

app = Flask(__name__)
CORS(app)

# API mechanism to import the map widget HTML code as string
@app.route('/get_map_widget', methods=['GET'])
def get_map_widget():
    # Authorize my GEE account
    geemap.ee_initialize()

    # Create a map using GEE API and geemap
    Map = geemap.Map(center=[21.79, 70.87], zoom=3)
    image = geemap.ee.Image('USGS/SRTMGL1_003')
    vis_params = {
        'min': 0,
        'max': 6000,
        'palette': ['006633', 'E5FFCC', '662A00', 'D8D8D8', 'F5F5F5'],
    }
    Map.addLayer(image, vis_params, 'SRTM')
    Map.setControlVisibility(fullscreenControl=False)

    # Get my HTML string
    html_string = Map.to_html(title='My Map', width='100%', height='300px')
    return html_string

if __name__ == '__main__':
    app.run()