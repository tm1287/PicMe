from urllib import request
from flask import Flask, jsonify, request
import random

app = Flask(__name__)

@app.route("/photographer", methods=["GET"])
def photographers():
    if(request.method == "GET"):
        latitude = float(request.args.get("latitude"))
        longitude = float(request.args.get("longitude"))
        
        nearby = [{
            "latitude": random.uniform(-0.05, 0.05) + latitude,
            "longitude": random.uniform(-0.05, 0.05) + longitude,
            "name": "Photographer " + str(i)
        } for i in range(5)]

        return {
            "photographers": nearby
        }

if __name__ == '__main__':
  app.run(debug=True, host="0.0.0.0")