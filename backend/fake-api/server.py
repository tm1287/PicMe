from urllib import request
from flask import Flask, jsonify, request
import random

import psycopg2 as pc2
import psycopg2.extras

app = Flask(__name__)

conn = pc2.connect("dbname=picme user=tejas")
cur = conn.cursor(cursor_factory = psycopg2.extras.RealDictCursor)

@app.route("/photographer", methods=["GET"])
def photographers():
    if(request.method == "GET"):
        '''
        latitude = float(request.args.get("latitude"))
        longitude = float(request.args.get("longitude"))
        
        nearby = [{
            "latitude": random.uniform(-0.05, 0.05) + latitude,
            "longitude": random.uniform(-0.05, 0.05) + longitude,
            "name": "Photographer " + str(i)
        } for i in range(5)]'''

        cur.execute("SELECT latitude, longitude, first_name, last_name FROM photographer;")

        return {
            "photographers": cur.fetchall()
        }

@app.route("/test", methods=["GET"])
def test():
    cur.execute("SELECT latitude, longitude, first_name, last_name FROM photographer;")

    return {
        "results": cur.fetchall()
    }

if __name__ == '__main__':
  app.run(debug=True, host="0.0.0.0")