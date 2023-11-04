import cv2
import numpy as np
import os
import keyboard

# Load YOLO object detection model
net = cv2.dnn.readNet("yolov3.weights", "yolov3.cfg")
classes = []
with open("coco.names", "r") as f:
    classes = f.read().strip().split('\n')
layer_names = net.getUnconnectedOutLayersNames()

# Start capturing the live video feed from your computer's camera
cap = cv2.VideoCapture(0)  # Use the appropriate video source (usually 0 for the default camera)

# Create a directory to store the captured frames as images
if not os.path.exists("captured_frames"):
    os.mkdir("captured_frames")

frame_count = 0

while True:
    ret, frame = cap.read()
    if not ret:
        break

    height, width, _ = frame.shape
    blob = cv2.dnn.blobFromImage(frame, 0.00392, (416, 416), (0, 0, 0), True, crop=False)
    net.setInput(blob)
    outs = net.forward(layer_names)

    class_ids = []
    confidences = []
    boxes = []
    for out in outs:
        for detection in out:
            scores = detection[5:]
            class_id = int(np.argmax(scores))
            confidence = float(scores[class_id])
            if confidence > 0.5:
                center_x = int(detection[0] * width)
                center_y = int(detection[1] * height)
                w = int(detection[2] * width)
                h = int(detection[3] * height)
                x = int(center_x - w / 2)
                y = int(center_y - h / 2)
                class_ids.append(class_id)
                confidences.append(confidence)
                boxes.append([x, y, w, h])

    indexes = cv2.dnn.NMSBoxes(boxes, confidences, 0.5, 0.4)

    # Save each frame as an image
    frame_count += 1
    frame_filename = f"captured_frames/frame_{frame_count:04d}.jpg"
    cv2.imwrite(frame_filename, frame)

    # Print frame information
    print(f"Saved frame {frame_count}")

    # Capture keyboard input to exit the application
    if keyboard.is_pressed('q'):
        break

cap.release()
cv2.destroyAllWindows()
