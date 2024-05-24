import os
import logging
import threading
import time

import numpy as np
from numpy.random import rand
from scipy.io import loadmat
from sklearn.metrics import classification_report
from sklearn.model_selection import StratifiedKFold
from sklearn.neighbors import KNeighborsClassifier
from matplotlib import pyplot as plt

# logging.basicConfig(level=logging.DEBUG)
logging.basicConfig(level=logging.INFO)

kfold = 10
k = 5
N = 10
T = 100
parties = 8
lambda_max = 1.0
pl = 0.4
gl = 0.7
areas = parties
members = parties
population_size = parties * members
runs = 10


opts = {
    "k": 5,
    "Model": StratifiedKFold(n_splits=kfold),
    "clf": KNeighborsClassifier(n_neighbors=k),
}

#####################################################################################################
#####################################################################################################
##############                           Model Settings Above                          ##############
#####################################################################################################
#####################################################################################################


def initializations(dim):
    # return rand(parties, areas, dim)
    return np.random.randint(2, size=(parties, areas, dim))


def jfitness_function(position_vector, dim, X, Y):
    alpha = 0.99
    beta = 0.01
    max_feat = dim
    new_pos_vector = position_vector
    for d in range(dim):
        assert new_pos_vector[d] == 0 or new_pos_vector[d] == 1
        # tf = transfer_function(new_pos_vector[d])
        # r1 = rand()
        # new_pos_vector[d] = int(tf >= r1)

    if np.count_nonzero(new_pos_vector) == 0:
        return float("inf")

    error = jwrapper_knn(X[:, np.where(new_pos_vector == 1)[0]], Y)
    nsf = np.count_nonzero(new_pos_vector)
    return (alpha * error) + (beta * (nsf / max_feat))


def jwrapper_knn(s_feat, label):
    # k = opts["k"]
    model = opts["Model"]
    clf = opts["clf"]

    acc = []
    # f1 = []

    for trainId, testId in model.split(s_feat, label):
        clf.fit(s_feat[trainId], label[trainId])
        y_pred = clf.predict(s_feat[testId])
        dic = classification_report(
            label[testId], y_pred, output_dict=True, zero_division=0
        )
        # f1.append(dic['macro avg']['f1-score'])
        acc.append(dic["accuracy"])

    return 1 - np.mean(acc)


def election(positions, leader_pos, leader_score, dim, X, Y):
    fitness = np.zeros((parties, areas))

    for p in range(parties):
        for a in range(areas):
            fitness[p, a] = jfitness_function(positions[p, a], dim, X, Y)

            if fitness[p, a] < leader_score:
                leader_score = fitness[p, a]
                leader_pos = positions[p, a].copy()

    party_leaders = np.zeros((parties, dim))
    party_leaders_fitness = np.zeros(parties)

    constituency_winners = np.zeros((areas, dim))
    constituency_winners_fitness = np.zeros(areas)
    constituency_winners_party = np.zeros(areas, dtype=int)

    for p in range(parties):
        min_value, min_col_index = np.min(fitness[p]), np.argmin(fitness[p])
        party_leaders[p] = positions[p, min_col_index].copy()
        party_leaders_fitness[p] = min_value

    for a in range(areas):
        min_value, min_row_index = np.min(fitness[:, a]), np.argmin(fitness[:, a])
        constituency_winners[a] = positions[min_row_index, a].copy()
        constituency_winners_fitness[a] = min_value
        constituency_winners_party[a] = min_row_index

    return (
        fitness,
        leader_score,
        leader_pos,
        party_leaders,
        party_leaders_fitness,
        constituency_winners,
        constituency_winners_fitness,
        constituency_winners_party,
    )


def election_compaign(
    positions,
    prev_positions,
    fitness,
    prev_fitness,
    party_leaders,
    constituency_winners,
    dim
):
    for which_method in range(2):
        for p in range(parties):
            for a in range(areas):
                for d in range(dim):
                    if which_method == 0:
                        center = party_leaders[p, d]
                    elif which_method == 1:
                        center = constituency_winners[a, d]

                    # logging.debug("center %s", center)
                    # if abs(positions[p, a, d]) > 1000:
                    #     exit(0)

                    if fitness[p, a] <= prev_fitness[p, a]:
                        if (
                            prev_positions[p, a, d] <= positions[p, a, d] <= center
                        ) or (prev_positions[p, a, d] >= positions[p, a, d] >= center):
                            # logging.debug("Hello1 %s", positions[p, a, d])
                            positions[p, a, d] = center + (
                                rand() * (center - positions[p, a, d])
                            )
                            # logging.debug("Hello1 %s", positions[p, a, d])
                        elif (
                            prev_positions[p, a, d] <= center <= positions[p, a, d]
                        ) or (prev_positions[p, a, d] >= center >= positions[p, a, d]):
                            # logging.debug("Hello2 %s", positions[p, a, d])
                            positions[p, a, d] = center + (
                                (2 * rand() - 1) * (abs(positions[p, a, d] - center))
                            )
                            # logging.debug("Hello2 %s", positions[p, a, d])
                        elif (
                            center <= prev_positions[p, a, d] <= positions[p, a, d]
                        ) or (center >= prev_positions[p, a, d] >= positions[p, a, d]):
                            # logging.debug("Hello3 %s", positions[p, a, d])
                            positions[p, a, d] = center + (
                                (2 * rand() - 1)
                                * (abs(prev_positions[p, a, d] - center))
                            )
                            # logging.debug("Hello3 %s", positions[p, a, d])
                    else:
                        if (
                            prev_positions[p, a, d] <= positions[p, a, d] <= center
                        ) or (prev_positions[p, a, d] >= positions[p, a, d] >= center):
                            # logging.debug("Hello4 %s", positions[p, a, d])
                            positions[p, a, d] = center + (
                                (2 * rand() - 1) * (abs(positions[p, a, d] - center))
                            )
                            # logging.debug("Hello4 %s", positions[p, a, d])
                        elif (
                            prev_positions[p, a, d] <= center <= positions[p, a, d]
                        ) or (prev_positions[p, a, d] >= center >= positions[p, a, d]):
                            # logging.debug("Hello5 %s", positions[p, a, d])
                            positions[p, a, d] = prev_positions[p, a, d] + (
                                rand() * (positions[p, a, d] - prev_positions[p, a, d])
                            )
                            # logging.debug("Hello5 %s", positions[p, a, d])
                        elif (
                            center <= prev_positions[p, a, d] <= positions[p, a, d]
                        ) or (center >= prev_positions[p, a, d] >= positions[p, a, d]):
                            # logging.debug("Hello6 %s", positions[p, a, d])
                            positions[p, a, d] = center + (
                                (2 * rand() - 1)
                                * (abs(center - prev_positions[p, a, d]))
                            )
                            # logging.debug("Hello6 %s", positions[p, a, d])


def party_switching(
    positions,
    fitness,
    t,
    lamda,
):
    psr = (1 - t * (1 / T)) * lamda

    for p in range(parties):
        for a in range(areas):
            if rand() < psr:
                to_party = np.random.randint(parties)
                while to_party == p:
                    to_party = np.random.randint(parties)

                to_party_least_fit = np.argmax(fitness[to_party])

                positions[[to_party, to_party_least_fit], [p, a]] = positions[
                    [p, a], [to_party, to_party_least_fit]
                ]
                # positions[to_party, to_party_least_fit], positions[p, a] = (
                #     positions[p, a],
                #     positions[to_party, to_party_least_fit],
                # )

                fitness[to_party, to_party_least_fit], fitness[p, a] = (
                    fitness[p, a],
                    fitness[to_party, to_party_least_fit],
                )


def parliamentarism(
    positions,
    fitness,
    constituency_winners,
    constituency_winners_fitness,
    constituency_winners_party,
    dim,
    X,
    Y
):
    for a in range(areas):
        new_area_winner = constituency_winners[a].copy()
        p = constituency_winners_party[a]

        to_area = np.random.randint(areas)
        while to_area == a:
            to_area = np.random.randint(areas)

        to_area_winner = constituency_winners[to_area]

        for d in range(dim):
            distance = abs(to_area_winner[d] - new_area_winner[d])
            new_area_winner[d] = to_area_winner[d] + (2 * rand() - 1) * distance
            tf = transfer_function(new_area_winner[d])
            r1 = rand()
            new_area_winner[d] = int(tf >= r1)

        new_area_winner_fitness = jfitness_function(new_area_winner, dim, X, Y)

        if new_area_winner_fitness < constituency_winners_fitness[a]:
            positions[p, a] = new_area_winner.copy()
            fitness[p, a] = new_area_winner_fitness
            constituency_winners[a] = new_area_winner.copy()


def transfer_function(x):
    return np.abs(x / np.sqrt(1 + x**2))


def hlpus(
    positions,
    party_leaders,
    leader_pos,
    dim
):
    for p in range(parties):
        for a in range(areas):
            for d in range(dim):
                r1 = rand()

                if 0 <= r1 < pl:
                    # r2 = rand()
                    # positions[i, j, k] = int(tf >= r2)

                    # if r2 < tf:
                    #     positions[i, j, k] = 1 - positions[i, j, k]
                    continue
                elif pl <= r1 < gl:
                    positions[p, a, d] = party_leaders[p, d]
                else:
                    positions[p, a, d] = leader_pos[d]


def transfer_values(positions, dim):
    for p in range(parties):
        for a in range(areas):
            for d in range(dim):
                tf = transfer_function(positions[p, a, d])
                r1 = rand()
                positions[p, a, d] = int(tf >= r1)

def hlbpo(dataset_name, dim, T, lambda_max, X, Y):
    leader_pos = np.zeros(dim)
    leader_score = float("inf")
    convergence_curve = np.zeros(T)
    positions = initializations(dim)

    aux_positions = positions.copy()
    prev_positions = positions.copy()

    (
        fitness,
        leader_score,
        leader_pos,
        party_leaders,
        party_leaders_fitness,
        constituency_winners,
        constituency_winners_fitness,
        constituency_winners_party,
    ) = election(positions, leader_pos, leader_score, dim, X, Y)

    aux_fitness = fitness.copy()
    prev_fitness = fitness.copy()

    t = 0
    lamda = lambda_max

    # Open a text file to record iteration results
    with open(f"results_record/{dataset_name}_iterations.txt", "w") as file:
        while t < T:
            prev_fitness = aux_fitness.copy()
            prev_positions = aux_positions.copy()

            aux_fitness = fitness.copy()
            aux_positions = positions.copy()

            election_compaign(
                positions,
                prev_positions,
                fitness,
                prev_fitness,
                party_leaders,
                constituency_winners,
                dim
            )

            # if t % 25 == 0 and t != 0:
            #     logging.info("transfering values %s", t)
            transfer_values(positions, dim)

            party_switching(
                positions,
                fitness,
                t,
                lamda,
            )

            (
                fitness,
                leader_score,
                leader_pos,
                party_leaders,
                party_leaders_fitness,
                constituency_winners,
                constituency_winners_fitness,
                constituency_winners_party,
            ) = election(positions, leader_pos, leader_score, dim, X, Y)

            parliamentarism(
                positions,
                fitness,
                constituency_winners,
                constituency_winners_fitness,
                constituency_winners_party,
                dim,
                X,
                Y
            )

            hlpus(positions, party_leaders, leader_pos, dim)

            transfer_values(positions, dim)

            lamda = lamda - lambda_max / T
            convergence_curve[t] = leader_score
            t += 1

            # Log and write to file
            log_message = f"iteration: {t}, error: {leader_score} pos: {leader_pos}"
            logging.info(log_message)
            file.write(log_message + "\n")
            file.flush()  # Ensure the data is written to the file
    
    # Plot and save the convergence curve
    plt.plot(convergence_curve)
    plt.xlabel("Iteration")
    plt.ylabel("Leader Score")
    plt.title(f"Convergence Curve for {dataset_name}")
    plt.savefig(f"result_plots/{dataset_name}_convergence.png")
    plt.close()
    
#####################################################################################################
#####################################################################################################
##############                          hlbpo algorithm Above                          ##############
#####################################################################################################
#####################################################################################################
# Ensure the required directories exist
os.makedirs("results_record", exist_ok=True)
os.makedirs("result_plots", exist_ok=True)

# List of datasets
# datasets = [
#     'arrhythmia',
#     'colon',
#     'dermatology',    #
#     'glass',
#     'hepatitis',      #
#     'horse_colic',
#     'ilpd',
#     'ionosphere',
#     'leukemia',
#     'libras_movement',
#     'lsvt',
#     'lung_discrete',
#     'lympho',         #
#     'musk_1',
#     'primary_tumor',  #
#     'scadi',
#     'seeds',
#     'soybean',        #
#     'spect_heart',
#     'tox_171',
#     'zoo'
# ]

datasets = ['ilpd.mat']


#with threading

# def process_dataset(dataset):
#     data = loadmat(f"datasets/{dataset}")
#     logging.debug(data.keys())

#     # Check for the presence of keys to use for X and Y
#     if 'X' in data and 'Y' in data:
#         X = data["X"]
#         Y = data["Y"].ravel()
#     elif 'feat' in data and 'label' in data:
#         X = data["feat"]
#         Y = data["label"].ravel()
#     else:
#         logging.error(f"Unknown keys in dataset {dataset}")
#         return

#     logging.debug("%s, %s", X.shape, Y.shape)

#     dim = X.shape[1]

#     dataset_name = os.path.splitext(dataset)[0]  # Get the dataset name without extension
#     hlbpo(dataset_name, dim, T, lambda_max, X, Y)

# if __name__ == "__main__":
#     start_time = time.time()

#     threads = []
#     for dataset in datasets:
#         thread = threading.Thread(target=process_dataset, args=(dataset,))
#         thread.start()
#         threads.append(thread)

#     for thread in threads:
#         thread.join()

#     end_time = time.time()
#     total_execution_time = end_time - start_time
#     logging.info(f"Total execution time: {total_execution_time} seconds")

#without threading

if __name__ == "__main__":

    for dataset in datasets:
        data = loadmat(f"datasets/{dataset}")
        logging.debug(data.keys())

        # Check for the presence of keys to use for X and Y
        if 'X' in data and 'Y' in data:
            X = data["X"]
            Y = data["Y"].ravel()
        elif 'feat' in data and 'label' in data:
            X = data["feat"]
            Y = data["label"].ravel()
        else:
            logging.error(f"Unknown keys in dataset {dataset}")
            continue

        logging.debug("%s, %s", X.shape, Y.shape)

        dim = X.shape[1]

        dataset_name = os.path.splitext(dataset)[0]  # Get the dataset name without extension
        hlbpo(dataset_name, dim, T, lambda_max, X, Y)