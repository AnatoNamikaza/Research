# Version 2: Deutsch-Jozsa algorithm (Parallelized)

# The provided code demonstrates the Deutsch-Jozsa algorithm for multiple input states and parallelizes its execution using Python's multiprocessing library.
# The key points:

# 1. **Quantum Circuit**: 
# The code defines a quantum circuit to implement the Deutsch-Jozsa algorithm. It includes an oracle, Hadamard gates, and measurements.
#
# 2. **Parallelization**: 
# The code parallelizes the execution of the Deutsch-Jozsa circuit for multiple input states using the multiprocessing library.
# It runs each instance of the circuit in parallel processes.
#
# 3. **Input States**:
# The code specifies a list of input states (0, 1, 2, 3) for which the algorithm is executed.
# You can modify this list to include different input states.
#
# 4. **Simulation**:
# The code simulates the quantum circuit using the BasicAer simulator and collects measurement results for each input state.
#
# 5. **Execution Time**:
# It measures the total execution time of all parallelized instances. The execution time may vary depending on your hardware and the number of input states.
#
# 6. **Results**:
# For each input state, it prints the measurement results (counts), showing the probabilities of measuring each possible outcome.
#
# 7. **Total Execution Time**:
# The code prints the total execution time, indicating the time it took to run all instances in parallel.

#-------------------------------------------------------------------------------------------------------------------------------------

from qiskit import QuantumCircuit, transpile, execute, BasicAer
from qiskit.visualization import plot_histogram
import time
import multiprocessing

# Define the Deutsch-Jozsa oracle for a constant function (0) or a balanced function (1)
def deutsch_jozsa_oracle(qc, f):
    if f == 1:
        qc.cx(0, 1)

# Create a function to run the Deutsch-Jozsa circuit for a given input state
def run_deutsch_jozsa(input_state):
    # Create a quantum circuit with 2 qubits and 1 classical bit
    n = 2
    qc = QuantumCircuit(n, 1)

    # Apply Hadamard gate to the first qubit
    qc.h(0)

    # Apply the Deutsch-Jozsa oracle for a balanced function
    deutsch_jozsa_oracle(qc, 1)  # Change to 0 for a constant function

    # Apply Hadamard gates to both qubits
    qc.h(0)
    qc.h(1)

    # Measure the first qubit and store the result in the classical bit
    qc.measure(0, 0)

    # Simulate the circuit using the BasicAer simulator
    simulator = BasicAer.get_backend('qasm_simulator')
    compiled_circuit = transpile(qc, simulator)
    job = execute(compiled_circuit, simulator, shots=1024)
    result = job.result()

    # Get and return the measurement results
    counts = result.get_counts()
    return counts

if __name__ == "__main__":
    input_states = [0, 1, 2, 3]  # List of input states to parallelize
    num_processes = len(input_states)

    start_time = time.time()

    with multiprocessing.Pool(processes=num_processes) as pool:
        results = pool.map(run_deutsch_jozsa, input_states)

    end_time = time.time()
    total_execution_time = end_time - start_time

    for input_state, counts in zip(input_states, results):
        print(f"Input State {input_state}: {counts}")

    print(f"Total Execution Time: {total_execution_time} seconds")
