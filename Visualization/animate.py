import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation

df = pd.read_csv("data/simulation.csv", header = None, names = ["run", "time", "theta1", "theta2", "omega1", "omega2", "energy"])
runs = [
    group.reset_index(drop=True)
    for _, group in df.groupby("run")
]

L1 = 1.0
L2 = 1.0
plt.style.use('dark_background')
fig, ax = plt.subplots()

ax.set_aspect("equal")
ax.set_xlim(-L1 - L2, L1 + L2)
ax.set_ylim(-L1 - L2, L1 + L2)
ax.invert_yaxis()
ax.axis('off')

pendulums = []

for run in runs:
    rod, = ax.plot([], [], "-", linewidth = 2)
    pendulums.append(rod)

def update(frame):
    artists = []

    for run, rod in zip(runs, pendulums):
        theta1 = run["theta1"].iloc[frame]
        theta2 = run["theta2"].iloc[frame]
        x1 = L1 * np.sin(theta1)
        y1 = L1 * np.cos(theta1)
        x2 = x1 + L2 * np.sin(theta2)
        y2 = y1 + L2 * np.cos(theta2)

        rod.set_data(
            [0, x1, x2],
            [0, y1, y2]
        )

        artists.append(rod)
    return artists


dt = df["time"].iloc[1] - df["time"].iloc[0]
target_fps = 60
stride = max(1, round(1.0 / (target_fps * dt)))

animation = FuncAnimation(
    fig,
    update,
    frames = range(0, len(runs[0]), stride),
    interval = 1000 / target_fps,
    blit = False
)

update(0)
plt.show()