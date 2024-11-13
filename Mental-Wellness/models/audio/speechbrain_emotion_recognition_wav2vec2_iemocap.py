from speechbrain.pretrained import EncoderClassifier
from speechbrain.inference.interfaces import foreign_class
from speechbrain.pretrained import EncoderClassifier
import torch
import torchaudio
import numpy as np

class CustomEncoderWav2vec2Classifier:
    def __init__(self, source, savedir):
        self.model = EncoderClassifier.from_hparams(source=source, savedir=savedir)

    def classify_file(self, audio_file):
        # Uses the classifier to predict the emotion
        prediction = self.model.classify_file(audio_file)
        out_prob, score, index = prediction[1], prediction[2], prediction[3]
        text_lab = prediction[0]
        return out_prob, score, index, text_lab

"""Initializing model (speechbrain/emotion-recognition-wav2vec2-IEMOCAP)"""

# Initialize the custom classifier using foreign_class
classifier = foreign_class(
    source="speechbrain/emotion-recognition-wav2vec2-IEMOCAP",
    pymodule_file="custom_interface.py",
    classname="CustomEncoderWav2vec2Classifier"
)

"""Import your speech file (.wav)"""

# Path to your audio file (make sure to upload or access a valid path)
audio_file_path = "/content/That-s a really good idea 1.wav"  # Replace with your actual file path

# Run the classifier on the audio file
out_prob, score, index, text_lab = classifier.classify_file(audio_file_path)
print(f"Predicted Emotion: {text_lab}")

"""Available Output labels"""

# Retrieve all emotion labels by reversing the label-to-index dictionary
emotion_labels = list(model.hparams.label_encoder.lab2ind.keys())
print("Emotion Labels:", emotion_labels)