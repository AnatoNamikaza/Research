import os
import mne
import numpy as np
from scipy.signal import butter, filtfilt
from tqdm import tqdm

DATASET_PATH = "data/physionet.org/files/chbmit/1.0.0"

WINDOW_SIZE = 5        # seconds
OVERLAP = 0.5          # 50% overlap


def bandpass_filter(data, lowcut=0.5, highcut=40, fs=256, order=5):
    nyq = 0.5 * fs
    low = lowcut / nyq
    high = highcut / nyq

    b, a = butter(order, [low, high], btype='band')
    filtered = filtfilt(b, a, data)

    return filtered


def normalize(data):
    return (data - np.mean(data)) / np.std(data)


def segment_signal(data, fs):

    window_samples = int(WINDOW_SIZE * fs)
    step = int(window_samples * (1 - OVERLAP))

    segments = []

    for start in range(0, data.shape[1] - window_samples, step):

        end = start + window_samples

        segment = data[:, start:end]

        segments.append(segment)

    return np.array(segments)


def process_file(file_path):

    raw = mne.io.read_raw_edf(file_path, preload=True, verbose=False)

    data = raw.get_data()

    fs = int(raw.info['sfreq'])

    processed = []

    for channel in data:

        filtered = bandpass_filter(channel, fs=fs)

        norm = normalize(filtered)

        processed.append(norm)

    processed = np.array(processed)

    segments = segment_signal(processed, fs)

    return segments


def main():

    output_dir = "data/processed"
    os.makedirs(output_dir, exist_ok=True)

    file_counter = 0

    for subject in os.listdir(DATASET_PATH):

        subject_path = os.path.join(DATASET_PATH, subject)

        if not os.path.isdir(subject_path):
            continue

        for file in tqdm(os.listdir(subject_path)):

            if file.endswith(".edf"):

                file_path = os.path.join(subject_path, file)

                segments = process_file(file_path)

                save_path = os.path.join(output_dir, f"segments_{file_counter}.npy")

                np.save(save_path, segments)

                file_counter += 1

if __name__ == "__main__":
    main()