import numpy as np
from PIL import Image
from fer import FER
import os
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense, Flatten

def create_model():
    # Create a simple model for emotion detection
    model = Sequential()
    model.add(Flatten(input_shape=(64, 64, 3)))  # Adjust input shape as necessary
    model.add(Dense(128, activation='relu'))
    model.add(Dense(7, activation='softmax'))  # Assuming 7 emotion classes for FER

    model.compile(optimizer='adam', loss='categorical_crossentropy', metrics=['accuracy'])

    # Save the model
    model.save('model.h5')
    print("Model created and saved as model.h5")

def detect_emotions(image_path):
    detector = FER(mtcnn=True)
    result = detector.detect_emotions(image_path)
    
    if not result:
        print("No faces detected.")
        return

    for face in result:
        emotions = face['emotions']
        print("Detected emotions:", emotions)

    print("Faces detected:", len(result))

if __name__ == "__main__":
    create_model()  # Call the function to create and save the model
