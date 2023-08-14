# *  LIBRARIES USED IN THIS ENVIRONMENT:
#   -   flask
#   -   flask_cors
#   -   selenium
#   -   geemap
#   -   ipywidgets v7.7.5 or sth
#   -   python-dotenv
#   -   google
# *#


from flask import Flask, request, abort
from flask_cors import CORS
from google.oauth2.credentials import Credentials
from dotenv import load_dotenv
import os
import geemap
import ee

# Set up service account credentials for authorization
# NOTE: for the service account to be discoverable the command prompt must be in its directory.
load_dotenv()
service_account = os.getenv("SERVICE_ACCOUNT_KEY_NAME")
service_email = os.getenv("SERVICE_ACCOUNT_EMAIL")
credentials = ee.ServiceAccountCredentials(
    email=service_email, key_file=service_account
)

app = Flask(__name__)
CORS(app)

# Sample code that works
# Create a map using GEE API and geemap\nMap = geemap.Map(center=[21.79, 70.87], zoom=3, zoom_ctrl=True, data_ctrl=False, fullscreen_ctrl=False, search_ctrl=False, draw_ctrl=False, scale_ctrl=False, measure_ctrl=False, toolbar_ctrl=False, layer_ctrl=False, attribution_ctrl=False)\nimage = geemap.ee.Image('USGS/SRTMGL1_003')\nvis_params = {'min': 0, 'max': 6000, 'palette': ['006633', 'E5FFCC', '662A00', 'D8D8D8', 'F5F5F5']}\nMap.addLayer(image, vis_params, 'SRTM')


# API mechanism to import the map widget HTML code as string
@app.route("/python_api/get_map_widget/python", methods=["POST"])
def get_map_widget_py():
    # Get data from front-end
    height = request.args.get("height", 300)
    user_code = request.form.get("code", "")
    user_code = user_code.replace("\\n", "\n")
    user_code = user_code.replace("\\t", "")

    # Initialize default attributes
    default_options = {
        "zoom_ctrl": True,
        "data_ctrl": False,
        "fullscreen_ctrl": False,
        "search_ctrl": False,
        "draw_ctrl": False,
        "scale_ctrl": False,
        "measure_ctrl": False,
        "toolbar_ctrl": False,
        "layer_ctrl": False,
        "attribution_ctrl": False,
    }

    # Add geemap import and initialization
    code = f"ee.Initialize(credentials=credentials)\n{str(user_code)}"

    try:
        # Execute user code
        namespace = {"credentials": credentials, "Map": None, "default_options": default_options, "geemap":geemap, "ee":ee}
        exec(code, namespace)

        # Access the Map object from the namespace
        Map = namespace["Map"]

        # Get my HTML string
        html_string = Map.to_html(title="My Map", width="100%", height=f"{height}px")
        return html_string
    except:
        error_message = "Bad Request: Your code doesn't work."
        abort(400, description=error_message)

# API mechanism to import the map widget HTML code as string
@app.route("/python_api/get_map_widget/js", methods=["POST"])
def get_map_widget_js():
    # Get data from front-end
    height = request.args.get("height", 300)
    user_code = request.form.get("code", "")
    user_code = user_code.replace("\\n", "\n")
    user_code = user_code.replace("\\t", "")

    # Set up service account credentials for authorization
    # NOTE: for the service account to be discoverable the command prompt must be in its directory.
    service_account = os.getenv("SERVICE_ACCOUNT_KEY_NAME")
    service_email = os.getenv("SERVICE_ACCOUNT_EMAIL")
    credentials = ee.ServiceAccountCredentials(
        email=service_email, key_file=service_account
    )

    # Initialize default attributes
    default_options = {
        "zoom_ctrl": True,
        "data_ctrl": False,
        "fullscreen_ctrl": False,
        "search_ctrl": False,
        "draw_ctrl": False,
        "scale_ctrl": False,
        "measure_ctrl": False,
        "toolbar_ctrl": False,
        "layer_ctrl": False,
        "attribution_ctrl": False,
    }
    
    try:
        # Convert javaScript to Python
        python_code = geemap.js_snippet_to_py(user_code, show_map=False, add_new_cell=False)
        Map = geemap.Map(**default_options)
        
        python_code = "".join(python_code)
        
        # Initialize code
        code = f"ee.Initialize(credentials=credentials)\n{str(python_code)}"
        
        # return code
        
        # Execute user code
        namespace = {"credentials": credentials, "Map": Map, "geemap":geemap, "ee":ee}
        exec(code, namespace)

        # Access the Map object from the namespace
        Map = namespace["Map"]

        # Get my HTML string
        html_string = Map.to_html(title="My Map", width="100%", height=f"{height}px")
        return html_string
    except:
        error_message = "Bad Request: Your code doesn't work."
        abort(400, description=error_message)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=3001)
