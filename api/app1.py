from flask import Flask, jsonify, request
from flask_swagger_ui import get_swaggerui_blueprint
import mysql.connector
import pymysql
import os

app = Flask(__name__)

db = mysql.connector.connect(
    host="localhost",
    user="root",
    password=os.getenv('MySQLpwd'),
    database="accents"
)
cursor = db.cursor()

SWAGGER_URL = '/swagger'
API_URL = '/static/openapi.yaml'
swaggerui_blueprint = get_swaggerui_blueprint(
    SWAGGER_URL,
    API_URL,
    config={'app_name': "Swagger"}
)
app.register_blueprint(swaggerui_blueprint, url_prefix=SWAGGER_URL)

@app.route('/speaker_info/<int:speaker_id>')
def get_speaker_info(speaker_id):
    try:
        query = "SELECT 'native language', age, sex FROM saa_bios WHERE speaker_id = %s"
        cursor.execute(query, (speaker_id,))
        result = cursor.fetchone()
        if result:
            speaker_info = {
                'native_language': result[0],
                'age': result[1],
                'sex': result[2]
            }
            return jsonify(speaker_info)
        else:
            return jsonify({'message': 'Speaker not found'}), 404
    except Exception as e:
        return jsonify({'message': str(e)}), 500

@app.route('/locations')
def get_locations():
    try:
        query = "SELECT location FROM locations"
        cursor.execute(query)
        results = cursor.fetchall()
        locations = [result[0] for result in results]
        return jsonify(locations)
    except Exception as e:
        return jsonify({'message': str(e)}), 500

if __name__ == '__main__':
    app.run(port=8080)

