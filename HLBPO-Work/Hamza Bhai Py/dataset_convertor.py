import os
import numpy as np
from sklearn.impute import KNNImputer
from scipy.io import loadmat, savemat

# Initialize KNN Imputer
imputer = KNNImputer()

# List of dataset names
datasets = [
    'arrhythmia',
    'colon',
    'dermatology',
    'glass',
    'hepatitis',
    'horse_colic',
    'ilpd',
    'ionosphere',
    'leukemia',
    'libras_movement',
    'lsvt',
    'lung_discrete',
    'lympho',
    'musk_1',
    'primary_tumor',
    'scadi',
    'seeds',
    'soybean',
    'spect_heart',
    'tox_171',
    'zoo'
]

# Create directory for imputed datasets if it doesn't exist
os.makedirs("Imputed_datasets", exist_ok=True)

def load_dataset(data):
    """Load dataset and handle different key names."""
    if "feat" in data and "label" in data:
        X = data["feat"]
        Y = data["label"].ravel()
    elif "X" in data and "y" in data:
        X = data["X"]
        Y = data["y"].ravel()
    else:
        raise ValueError("Dataset structure not recognized")
    return X, Y

for dataset in datasets:
    # Load the dataset
    data = loadmat(f"./datasets/{dataset}.mat")

    # Load the dataset with proper keys
    X, Y = load_dataset(data)

    # Apply KNN Imputer to the features
    X_imputed = imputer.fit_transform(X)

    # Save the imputed dataset
    imputed_data = {'X': X_imputed, 'Y': Y}
    savemat(f"./Imputed_datasets/{dataset}_imputed.mat", imputed_data)

    print(f"{dataset} has been imputed and saved in Imputed_datasets.")
