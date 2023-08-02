from flask import Flask, request, abort
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

# import geemap
# geemap.ee_initialize(credentials = )

# Sample code that works
# Create a map using GEE API and geemap\nMap = geemap.Map(center=[21.79, 70.87], zoom=3, zoom_ctrl=True, data_ctrl=False, fullscreen_ctrl=False, search_ctrl=False, draw_ctrl=False, scale_ctrl=False, measure_ctrl=False, toolbar_ctrl=False, layer_ctrl=False, attribution_ctrl=False)\nimage = geemap.ee.Image('USGS/SRTMGL1_003')\nvis_params = {'min': 0, 'max': 6000, 'palette': ['006633', 'E5FFCC', '662A00', 'D8D8D8', 'F5F5F5']}\nMap.addLayer(image, vis_params, 'SRTM')

# API mechanism to import the map widget HTML code as string
@app.route('/get_map_widget', methods=['POST'])
def get_map_widget():
    
    # Get data from front-end
    height = request.args.get('height', 300)
    user_code = request.form.get('code', '')
    user_code = user_code.replace('\\n', '\n')
    
    # Add geemap import and initialization
    code = f"import geemap\ngeemap.ee_initialize()\n{str(user_code)}"
            
    try:
        # Execute user code
        namespace = {}
        exec(code, namespace)

        # Access the Map object from the namespace
        Map = namespace['Map']
        
        # Get my HTML string
        html_string = Map.to_html(title='My Map', width='100%', height=f'{height}px')
        return html_string
    except:
        error_message = "Bad Request: Your code doesn't work."
        abort(400, description=error_message)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=3001)