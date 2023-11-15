from qiskit import Aer, QuantumCircuit, transpile, assemble
from qiskit.aqua import QuantumInstance
from qiskit.aqua.algorithms import QSVM
from qiskit.aqua.components.feature_maps import SecondOrderExpansion
from qiskit.ml.datasets import ad_hoc_data
from qiskit.visualization import plot_histogram

# Generate a synthetic dataset
feature_dim = 2
training_dataset_size = 20
testing_dataset_size = 10
random_seed = 10598
sample_Total, training_input, test_input, class_labels = ad_hoc_data(
    training_size=training_dataset_size,
    test_size=testing_dataset_size,
    n=feature_dim,
    gap=0.3,
    PLOT_DATA=True
)

# Create a quantum feature map
feature_map = SecondOrderExpansion(feature_dimension=feature_dim, depth=2, entanglement='linear')

# Create a quantum support vector machine
svm = QSVM(feature_map, training_input, test_input)

# Run the algorithm on a quantum backend
backend = Aer.get_backend('qasm_simulator')
quantum_instance = QuantumInstance(backend, shots=1024, seed_simulator=random_seed, seed_transpiler=random_seed)

result = svm.run(quantum_instance)

# Display the results
print("Testing success ratio: {}".format(result['testing_accuracy']))
print("Prediction for the test set: {}".format(result['predicted_classes']))

# Plot the decision boundary
svm.visualize(backend=backend)
