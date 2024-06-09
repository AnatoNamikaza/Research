def warn(*args, **kwargs):
    pass


import warnings
import matplotlib.pyplot as plt
import os


warnings.warn = warn
import logging

import numpy as np
from numpy.random import rand
from pandas import DataFrame
from scipy.io import loadmat
from sklearn.metrics import classification_report
from sklearn.model_selection import StratifiedKFold
from sklearn.neighbors import KNeighborsClassifier

# logging.basicConfig(level=logging.DEBUG)
logging.basicConfig(level=logging.INFO)

kfold = 10
k = 5
N = 10
T = 100
# T = 5
parties = 3
lambda_max = 1.0
pl = 0.4
gl = 0.7
areas = 2
# areas = parties
members = parties
population_size = parties * members
runs = 10
dataset = "zoo"

opts = {
    "k": 5,
    "Model": StratifiedKFold(n_splits=kfold, shuffle=True),
    "clf": KNeighborsClassifier(n_neighbors=k),
}

runs_df = DataFrame(columns=("run", "iteration", "error"))
data = loadmat(f"./datasets/{dataset}.mat")
logging.debug(data.keys())

# X = data["X"]
# Y = data["Y"].ravel()

X = data["feat"]
Y = data["label"].ravel()

logging.debug("%s, %s", X.shape, Y.shape)
# exit(0)

dim = X.shape[1]


def initializations():
    # return rand(parties, areas, dim)
    return np.random.randint(2, size=(parties, areas, dim))


def jfitness_function(position_vector):
    alpha = 0.99
    beta = 0.01
    max_feat = dim
    new_pos_vector = position_vector.copy()

    if np.count_nonzero(new_pos_vector) == 0:
        return float("inf")

    error = jwrapper_knn(X[:, np.where(new_pos_vector == 1)[0]], Y)
    nsf = np.count_nonzero(new_pos_vector)
    return (alpha * error) + (beta * (nsf / max_feat))


def jwrapper_knn(s_feat, label):
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


def election(positions, leader_pos, leader_score):
    fitness = np.zeros((parties, areas))

    for p in range(parties):
        for a in range(areas):
            fitness[p, a] = jfitness_function(positions[p, a])

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
):
    for which_method in range(2):
        for p in range(parties):
            for a in range(areas):
                for d in range(dim):
                    if which_method == 0:
                        center = party_leaders[p, d]
                    elif which_method == 1:
                        center = constituency_winners[a, d]

                    if fitness[p, a] <= prev_fitness[p, a]:
                        if (
                            prev_positions[p, a, d] <= positions[p, a, d] <= center
                        ) or (prev_positions[p, a, d] >= positions[p, a, d] >= center):

                            positions[p, a, d] = center + (
                                rand() * (center - positions[p, a, d])
                            )

                        elif (
                            prev_positions[p, a, d] <= center <= positions[p, a, d]
                        ) or (prev_positions[p, a, d] >= center >= positions[p, a, d]):

                            positions[p, a, d] = center + (
                                (2 * rand() - 1) * (abs(positions[p, a, d] - center))
                            )

                        elif (
                            center <= prev_positions[p, a, d] <= positions[p, a, d]
                        ) or (center >= prev_positions[p, a, d] >= positions[p, a, d]):

                            positions[p, a, d] = center + (
                                (2 * rand() - 1)
                                * (abs(prev_positions[p, a, d] - center))
                            )

                    else:
                        if (
                            prev_positions[p, a, d] <= positions[p, a, d] <= center
                        ) or (prev_positions[p, a, d] >= positions[p, a, d] >= center):

                            positions[p, a, d] = center + (
                                (2 * rand() - 1) * (abs(positions[p, a, d] - center))
                            )

                        elif (
                            prev_positions[p, a, d] <= center <= positions[p, a, d]
                        ) or (prev_positions[p, a, d] >= center >= positions[p, a, d]):

                            positions[p, a, d] = prev_positions[p, a, d] + (
                                rand() * (positions[p, a, d] - prev_positions[p, a, d])
                            )

                        elif (
                            center <= prev_positions[p, a, d] <= positions[p, a, d]
                        ) or (center >= prev_positions[p, a, d] >= positions[p, a, d]):

                            positions[p, a, d] = center + (
                                (2 * rand() - 1)
                                * (abs(center - prev_positions[p, a, d]))
                            )


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
                positions[[to_party, p], [to_party_least_fit, a]] = positions[
                    [p, to_party], [a, to_party_least_fit]
                ]

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
            new_area_winner[d] = transfer_function(new_area_winner[d])

        new_area_winner_fitness = jfitness_function(new_area_winner)

        if new_area_winner_fitness < constituency_winners_fitness[a]:
            positions[p, a] = new_area_winner.copy()
            fitness[p, a] = new_area_winner_fitness
            constituency_winners[a] = new_area_winner.copy()
            constituency_winners_fitness[a] = new_area_winner_fitness


def transfer_function(x):
    r1 = rand()
    tf = np.abs(x / np.sqrt(1 + x**2))
    return int(tf >= r1)


def hlpus(
    positions,
    party_leaders,
    leader_pos,
):
    for p in range(parties):
        for a in range(areas):
            for d in range(dim):
                r1 = rand()

                if 0 <= r1 < pl:
                    continue
                elif pl <= r1 < gl:
                    positions[p, a, d] = party_leaders[p, d]
                else:
                    positions[p, a, d] = leader_pos[d]


def transfer_values(positions):
    for p in range(parties):
        for a in range(areas):
            for d in range(dim):
                positions[p, a, d] = transfer_function(positions[p, a, d])


def hlbpo(run):
    leader_pos = np.zeros(dim)
    leader_score = float("inf")

    convergence_curve = np.zeros((T + 1, 3))

    positions = initializations()

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
    ) = election(positions, leader_pos, leader_score)
    convergence_curve[0] = [run, 0, leader_score]

    logging.info("iteration: 0, error: %s", leader_score)

    aux_fitness = fitness.copy()
    prev_fitness = fitness.copy()

    t = 1
    lamda = lambda_max

    while t <= T:
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
        )

        # if t % 25 == 0 and t != 0:
        #     logging.info("transfering values %s", t)
        # transfer_values(positions)

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
        ) = election(positions, leader_pos, leader_score)

        parliamentarism(
            positions,
            fitness,
            constituency_winners,
            constituency_winners_fitness,
            constituency_winners_party,
        )

        # logging.debug("%s", positions)
        hlpus(positions, party_leaders, leader_pos)

        # transfer_values(positions)

        lamda = lamda - lambda_max / T
        convergence_curve[t] = [run, t, leader_score]
        logging.info("run: %s, iteration: %s, error: %s", run, t, leader_score)
        t += 1


    # Add the following lines before "return convergence_curve"

    # Create the result_plots directory if it does not exist
    os.makedirs('result_plots', exist_ok=True)

    plt.figure(figsize=(10, 6))
    for i in range(run + 1):
        plt.plot(convergence_curve[convergence_curve[:, 0] == i, 1], 
                convergence_curve[convergence_curve[:, 0] == i, 2], label=f'Run {i + 1}')

    plt.xlabel('Iteration')
    plt.ylabel('Leader Score (Error)')
    plt.title(f'Convergence Curves for {dataset}')
    plt.legend()
    plt.grid(True)

    # Save the plot
    plot_path = f'result_plots/{dataset}_convergence.png'
    plt.savefig(plot_path)
    plt.close()

    return convergence_curve
    # plt.plot(convergence_curve)


if __name__ == "__main__":
    scores = np.array([hlbpo(run=run) for run in range(runs)])
    np.savetxt(f"results_record/{dataset}.csv", scores.reshape(-1, 3), delimiter=",")
    #
    # logging.info("scores: %s %s %s", min(scores), np.mean(scores), max(scores))
    # runs_df.to_csv(f"{dataset}.csv", index=False)
