from flask import Flask, request, render_template
from fer import FER  # Import FER for emotion detection
import os

app = Flask(__name__)

# Load the FER model with MTCNN face detection
detector = FER(mtcnn=True)

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/predict', methods=['POST'])
def predict():
    # Check if a file is uploaded
    if 'upload' not in request.files:
        return render_template('index.html', error='No file uploaded')

    file = request.files['upload']
    
    # Check if file has no filename (empty file)
    if file.filename == '':
        return render_template('index.html', error='No selected file')
    
    # Save the uploaded image to the 'uploads' directory
    img_path = os.path.join('uploads', file.filename)
    if not os.path.exists('uploads'):
        os.makedirs('uploads')  # Create uploads directory if it doesn't exist
    file.save(img_path)

    # Detect emotions in the uploaded image
    result = detect_emotions(img_path)

    # Render the template with the result of emotion detection
    return render_template('index.html', result=result)

def detect_emotions(image_path):
    # Use the FER detector to analyze the image for emotions
    result = detector.detect_emotions(image_path)

    # Check if any faces were detected
    if not result:
        return "No faces detected in the image."

    # Collect emotions from the detected faces
    emotions = []
    for face in result:
        # Extract emotions for each face and return a dictionary of emotion scores
        emotions_dict = face['emotions']
        emotions.append(emotions_dict)

    return emotions

if __name__ == "__main__":
    app.run(debug=True)
