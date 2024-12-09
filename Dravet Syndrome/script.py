import mne
import matplotlib.pyplot as plt
import os

# Set the path to the folder and file
dataset_folder = "dataset"
edf_file = os.path.join(dataset_folder, "111822.edf")

# Load the EDF file
raw_data = mne.io.read_raw_edf(edf_file, preload=True)

# Display basic information about the data
print(raw_data)
print("\nInfo about the channels:")
print(raw_data.info)

# Plot the data to visualize the signals
raw_data.plot(n_channels=10, duration=10, title="EEG Signals (First 10 Channels)")

# Get the data as a NumPy array (optional)
data, times = raw_data.get_data(return_times=True)

# Plot a specific channel (e.g., the first channel)
plt.figure(figsize=(10, 4))
plt.plot(times, data[0], label='Channel 1')
plt.xlabel('Time (s)')
plt.ylabel('Amplitude (μV)')
plt.title('EEG Signal for Channel 1')
plt.legend()
plt.show()
