from flask import Flask, jsonify
import mysql.connector
import os

app = Flask(__name__)

# Establish connection to MySQL database
db = mysql.connector.connect(
    host="localhost",
    user="root",
    password=os.getenv('MySQLpwd'),
    database="accents"
)
cursor = db.cursor()

# Define Flask routes
@app.route('/speaker_info/<int:speaker_id>')
def get_speaker_info(speaker_id):
    try:
        # Execute SQL query to retrieve speaker information
        query = "SELECT 'native language', age, sex FROM accents.saa_bios as acc WHERE speaker_id = %s"
        cursor.execute(query, (speaker_id,))
        result = cursor.fetchone()
        
        # Check if speaker information exists
        if result:
            # Construct speaker_info dictionary
            speaker_info = {
                'native language': result[0],
                'age': result[1],
                'sex': result[2]
            }
            
            # Log speaker_info object
            app.logger.info(f"Speaker Info: {speaker_info}")
            
            # Return speaker_info as JSON response
            return jsonify(speaker_info)
        else:
            # Return message if speaker not found
            return jsonify({'message': 'Speaker not found'}), 404
    except Exception as e:
        # Return error message if an exception occurs
        return jsonify({'message': str(e)}), 500

# Run Flask app
if __name__ == '__main__':
    app.run(port=8080)

