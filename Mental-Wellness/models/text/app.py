from flask import Flask, request, jsonify, render_template, redirect, url_for
from werkzeug.utils import secure_filename
from transformers import AutoTokenizer, AutoModelForSequenceClassification
import torch
import torch.nn.functional as F
import os

app = Flask(__name__)

# Define folder for uploading files
UPLOAD_FOLDER = 'uploads/'
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

# Allow only .txt files
ALLOWED_EXTENSIONS = {'txt'}

# Load the tokenizer and model from Hugging Face
model_name = "bhadresh-savani/distilbert-base-uncased-emotion"  # Pretrained on GoEmotions
tokenizer = AutoTokenizer.from_pretrained(model_name)
model = AutoModelForSequenceClassification.from_pretrained(model_name)

# Define emotion labels
emotion_labels = ["sadness", "joy", "neutral", "anger", "fear", "disgust", "surprise"]

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

def predict_emotion_and_sentiment(text):
    # Tokenize the input text
    inputs = tokenizer(text, return_tensors="pt", truncation=True, padding=True)

    # Perform inference using the model
    with torch.no_grad():
        outputs = model(**inputs)

    # Get raw logits and apply softmax to normalize into probabilities
    logits = outputs.logits
    probabilities = F.softmax(logits, dim=-1)

    # Get predicted emotion label
    emotion_index = torch.argmax(probabilities, dim=-1).item()
    predicted_emotion = emotion_labels[emotion_index]
    emotion_prob = probabilities[0][emotion_index].item()

    # Sentiment determination: Map emotions to sentiments
    if predicted_emotion in ["anger", "disgust", "fear", "sadness"]:
        sentiment = "negative"
    elif predicted_emotion in ["joy", "surprise"]:
        sentiment = "positive"
    else:
        sentiment = "neutral"

    return {
        "predicted_emotion": predicted_emotion,
        "emotion_probability": emotion_prob,
        "predicted_sentiment": sentiment
    }

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/predict', methods=['POST'])
def predict():
    if 'upload' not in request.files:
        return jsonify({'error': 'No file uploaded'}), 400

    file = request.files['upload']
    if file and allowed_file(file.filename):
        filename = secure_filename(file.filename)
        filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)
        file.save(filepath)

        # Read the text from the uploaded file
        with open(filepath, 'r') as f:
            text = f.read()

        # Run emotion detection on the file content
        result = predict_emotion_and_sentiment(text)

        return render_template('index.html', result=[{result['predicted_emotion']: result['emotion_probability']}])

    return jsonify({'error': 'File format not allowed. Only .txt files are allowed'}), 400

if __name__ == '__main__':
    if not os.path.exists(UPLOAD_FOLDER):
        os.makedirs(UPLOAD_FOLDER)
    app.run(debug=True)
