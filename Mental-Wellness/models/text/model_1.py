from transformers import AutoTokenizer, AutoModelForSequenceClassification
import torch
import torch.nn.functional as F

# Load the pretrained DistilBERT model fine-tuned on GoEmotions dataset
model_name = "bhadresh-savani/distilbert-base-uncased-emotion"  # Pretrained on GoEmotions
tokenizer = AutoTokenizer.from_pretrained(model_name)
model = AutoModelForSequenceClassification.from_pretrained(model_name)

# Define labels based on GoEmotions categories + sentiment groups
emotion_labels = ["sadness", "joy", "neutral", "anger", "fear", "disgust", "surprise"]  # Adaptable to GoEmotions schema
sentiment_labels = ["negative", "neutral", "positive"]

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
    print(emotion_labels)
    emotion_prob = probabilities[0][emotion_index].item()

    # Sentiment determination: Map emotions to sentiments
    if predicted_emotion in ["anger", "disgust", "fear", "sadness"]:
        sentiment = "negative"
    elif predicted_emotion in ["joy", "surprise"]:
        sentiment = "positive"
    else:
        sentiment = "neutral"

    return {
        "text": text,
        "predicted_emotion": predicted_emotion,
        "emotion_probability": emotion_prob,
        "predicted_sentiment": sentiment
    }

dssample_text = "I will beat you if you dont complete your work by tmrw"
result = predict_emotion_and_sentiment(sample_text)

# Display the results
print(f"Text: {result['text']}")
print(f"Predicted Emotion: {result['predicted_emotion']} (Confidence: {result['emotion_probability']:.2f})")
print(f"Predicted Sentiment: {result['predicted_sentiment']}")