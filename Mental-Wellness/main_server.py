from flask import Flask, redirect, url_for
import subprocess
from threading import Thread

app = Flask(__name__)

# Define functions to start each app
def start_facial_app():
    subprocess.run(["python", "./models/facial/app.py"])

def start_audio_app():
    subprocess.run(["python", "./models/audio/app.py"])

def start_text_app():
    subprocess.run(["python", "./models/text/app.py"])

# Route for the Test Selection page
@app.route('/')
def test_selection():
    return '''<!DOCTYPE html>
    <html>
    <head><title>Select a Test</title></head>
    <body>
        <a href="/start_facial">Facial Test</a><br>
        <a href="/start_audio">Audio Test</a><br>
        <a href="/start_text">Text Test</a><br>
    </body>
    </html>'''

# Routes for each test button
@app.route('/start_facial')
def start_facial():
    Thread(target=start_facial_app).start()
    return redirect("http://127.0.0.1:5000/")  # Redirect to the running app

@app.route('/start_audio')
def start_audio():
    Thread(target=start_audio_app).start()
    return redirect("http://127.0.0.1:5000/")

@app.route('/start_text')
def start_text():
    Thread(target=start_text_app).start()
    return redirect("http://127.0.0.1:5000/")

if __name__ == "__main__":
    app.run(port=5000)
