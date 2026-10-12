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

difference_text = plt.text(
    0,
    -total_length,
    "",
    ha="center",
    va="top"
)

trail_length = 300
lines = []
trail_lines = []

for _ in runs:
    line = ax.plot([], [], linewidth=2.5)[0]
    color = line.get_color()
    trail = ax.plot([], [], linewidth=1.0, alpha=0.5, color=color)[0]

    lines.append(line)
    trail_lines.append(trail)

trails_x = [[] for _ in runs]
trails_y = [[] for _ in runs]

def angle_difference(a, b):
    return np.abs((a - b + np.pi) % (2 * np.pi) - np.pi)

def get_max_angle_difference(frame):
    if len(runs) < 2:
        return 0.0

    theta_values = [
        run.loc[frame, theta_cols].to_numpy(dtype=float)
        for run in runs
    ]

    max_difference = 0.0

    for i in range(len(theta_values)):
        for j in range(i + 1, len(theta_values)):
            differences = angle_difference(
                theta_values[i],
                theta_values[j]
            )

            max_difference = max(
                max_difference,
                np.max(differences)
            )

    return max_difference

def init():
    for line in lines:
        line.set_data([], [])

    for trail in trail_lines:
        trail.set_data([], [])

    difference_text.set_text("")

    return lines + trail_lines + [difference_text]

def update(frame):
    max_difference = get_max_angle_difference(frame)

    difference_text.set_text(
        f"Max Difference: {max_difference:.3f} rad"
    )

    for j, (line, trail, run) in enumerate(zip(lines, trail_lines, runs)):
        thetas = run.loc[frame, theta_cols].to_numpy(dtype=float)

        x = np.zeros(n + 1)
        y = np.zeros(n + 1)

        for i in range(n):
            x[i + 1] = x[i] + lengths[i] * np.sin(thetas[i])
            y[i + 1] = y[i] + lengths[i] * np.cos(thetas[i])

        line.set_data(x, y)

        trails_x[j].append(x[-1])
        trails_y[j].append(y[-1])

        if len(trails_x[j]) > trail_length:
            trails_x[j].pop(0)
            trails_y[j].pop(0)

        trail.set_data(trails_x[j], trails_y[j])

    return lines + trail_lines + [difference_text]

ani = FuncAnimation(
    fig,
    update,
    frames=frames,
    init_func=init,
    interval= 1000 / target_fps,
    blit=False,
    repeat=True
)

plt.show()