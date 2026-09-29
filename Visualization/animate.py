import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation

df = pd.read_csv("data/simulation.csv", header = None, names = ["time", "theta1", "theta2", "omega1", "omeag2", "energy"])

L1 = 1.0
L2 = 1.0
theta1 = df["theta1"].to_numpy()
theta2 = df["theta2"].to_numpy()

x1 = L1 * np.sin(theta1)
y1 = L1 * np.cos(theta1)
x2 = x1 + L2 * np.sin(theta2)
y2 = y1 + L2 * np.cos(theta2)

fig, ax = plt.subplots()

ax.set_aspect("equal")
ax.set_xlim(-L1 - L2, L1 + L2)
ax.set_ylim(-L1 - L2, L1 + L2)
ax.invert_yaxis()
rod1, = ax.plot([], [], "o-", linewidth = 2)
rod2, = ax.plot([], [], "o-", linewidth = 2)

def update(frame):
    rod1.set_data(
        [0, x1[frame]],
        [0, y1[frame]]
    )
    rod2.set_data(
        [x1[frame], x2[frame]],
        [y1[frame], y2[frame]]
    )
    return rod1, rod2

dt = df["time"].iloc[1] - df["time"].iloc[0]
target_fps = 60
stride = max(1, round(1.0 / (target_fps * dt)))

animation = FuncAnimation(
    fig,
    update,
    frames = range(0, len(df), stride),
    interval = 1000 / target_fps,
    blit = False
)

plt.show()
print(theta1[0], theta2[0])
print(x1[0], y1[0])
print(x2[0], y2[0])