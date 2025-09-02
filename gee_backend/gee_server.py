from flask import Flask, request, jsonify
import ee

# Initialize the Earth Engine API (after authentication)
ee.Initialize()

app = Flask(__name__)

@app.route('/gee/ndvi', methods=['POST'])
def get_ndvi():
    data = request.json
    coords = data.get('coordinates')  # Expect [[lng, lat], [lng, lat], ...]
    if not coords or len(coords) < 3:
        return jsonify({'error': 'Invalid coordinates'}), 400

    # Create a polygon geometry in Earth Engine
    polygon = ee.Geometry.Polygon(coords)

    # Get the first Sentinel-2 image in the region
    image = ee.ImageCollection('COPERNICUS/S2').filterBounds(polygon).first()
    if not image:
        return jsonify({'error': 'No image found for region'}), 404

    # Calculate NDVI and clip to polygon
    ndvi = image.normalizedDifference(['B8', 'B4']).clip(polygon)

    # Get a thumbnail URL for the NDVI image
    url = ndvi.getThumbURL({
        'region': polygon,
        'dimensions': 512,
        'min': 0,
        'max': 1,
        'palette': ['red', 'yellow', 'green']
    })

    # Calculate mean NDVI value for the polygon
    mean_dict = ndvi.reduceRegion(
        reducer=ee.Reducer.mean(),
        geometry=polygon,
        scale=10,
        maxPixels=1e9
    ).getInfo()
    mean_ndvi = mean_dict.get('nd', None)  # 'nd' is the default band name for normalizedDifference

    return jsonify({'thumb_url': url, 'ndvi_value': mean_ndvi})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)