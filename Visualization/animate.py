import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation

# Load simulation data
df = pd.read_csv("data/simulation.csv")

# Detect theta columns automatically
theta_cols = [col for col in df.columns if col.startswith("theta")]
n = len(theta_cols)
lengths = np.ones(n)

# Split data by run
runs = [
    group.reset_index(drop=True)
    for _, group in df.groupby("run")
]

# Simulation timestep
dt = runs[0]["time"].iloc[1] - runs[0]["time"].iloc[0]

# Animation framerate
target_fps = 60

# Skip simulation steps so animation runs at approximately target_fps
stride = max(1, round(1.0 / (target_fps * dt)))

frames = range(0, len(runs[0]), stride)

# Create figure
fig, ax = plt.subplots()

total_length = np.sum(lengths)

ax.set_xlim(-total_length, total_length)
ax.set_ylim(-total_length, total_length)
ax.set_aspect("equal")
ax.invert_yaxis()
ax.axis("off")
ax.set_xlabel("x")
ax.set_ylabel("y")
ax.set_title(f"{n}-Pendulum Simulation")

# One line per simulation run
lines = [
    ax.plot([], [], linewidth = 2.5)[0]
    for _ in runs
]

def init():
    for line in lines:
        line.set_data([], [])

    return lines

def update(frame):
    for line, run in zip(lines, runs):

        # Current angles
        thetas = run.loc[frame, theta_cols].to_numpy(dtype=float)

        # Positions of pivot + all masses
        x = np.zeros(n + 1)
        y = np.zeros(n + 1)

        # Build linkage positions recursively
        for i in range(n):
            x[i + 1] = x[i] + lengths[i] * np.sin(thetas[i])
            y[i + 1] = y[i] + lengths[i] * np.cos(thetas[i])

        line.set_data(x, y)

    return lines

ani = FuncAnimation(
    fig,
    update,
    frames=frames,
    init_func=init,
    interval=800 / target_fps,
    blit=True,
    repeat=True
)

plt.show()