from flask import Flask, request, render_template
import torch
import torchaudio
from speechbrain.pretrained import EncoderClassifier
from speechbrain.inference.interfaces import foreign_class

app = Flask(__name__)

# Initialize the custom classifier using foreign_class
classifier = foreign_class(
    source="speechbrain/emotion-recognition-wav2vec2-IEMOCAP",
    pymodule_file="models/audio/custom_interface.py",  # Update to your actual path
    classname="CustomEncoderWav2vec2Classifier"
)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/predict', methods=['POST'])
def predict():
    if 'file' not in request.files:
        return 'No file part'
    
    file = request.files['file']
    if file.filename == '':
        return 'No selected file'
    
    # Save the file temporarily
    file_path = f"uploads/{file.filename}"
    file.save(file_path)

    # Run the model
    out_prob, score, index, text_lab = classifier.classify_file(file_path)

    # Return result to the frontend
    return render_template('index.html', prediction=text_lab[0])

if __name__ == "__main__":
    app.run(debug=True)
