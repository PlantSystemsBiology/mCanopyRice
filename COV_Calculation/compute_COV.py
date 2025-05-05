# Import required libraries
import open3d as o3d
import numpy as np
import math
import time
import copy
import os
import sys
import csv
import os.path
from tqdm import tqdm
import tkinter as tk
from tkinter import filedialog


def select_folder():
    # Create hidden root window
    root = tk.Tk()
    root.withdraw()  # Hide root window

    # Open folder selection dialog
    folder_path = filedialog.askdirectory(title="Select Folder")
    driver_letter = os.path.splitdrive(folder_path)[0]
    # Close root window
    root.destroy()
    # Check if folder was selected
    if folder_path:
        print(f"Selected folder: {folder_path}")
        return folder_path
    else:
        print("No folder selected.")
        return


def get_ply_files(folder_path):
    ply_files = []

    for root, dirs, files in os.walk(folder_path):
        for file in files:
            if file.endswith('.ply'):
                ply_files.append(os.path.normpath(os.path.join(root, file)))

    print("PLY files to process:")
    for i in ply_files:
        print(i)

    return ply_files


# Center alignment and rotation
def pcd_reset_position(pcd):

    z_max = 2
    z_min = 0

    points_np = np.asarray(pcd.points)

    min_index = np.where(points_np[:, 2] == np.min(points_np[:, 2]))

    min_index = min_index[0]

    min_points = points_np[min_index]

    invert = -min_points[0]

    pcd = pcd.translate(invert, relative=True)

    # Center alignment
    points_np = np.asarray(pcd.points)

    filtered_points = points_np[np.logical_and(points_np[:, 2] >= z_min,
                                               points_np[:, 2] <= z_max)]

    if len(filtered_points) == 0:
        raise ValueError("No points found in the specified z range.")

    # Calculate centroid (mean of coordinates)
    centroid = np.mean(filtered_points, axis=0)

    x_shift = centroid[0]
    y_shift = centroid[1]

    pcd = pcd.translate([-x_shift, -y_shift, 0], relative=True)

    # Convert points to NumPy array
    points_np = np.asarray(pcd.points)
    x = points_np[:, 0]
    y = points_np[:, 1]

    slope = np.polyfit(x, y, deg=1)[0]
    # Calculate rotation angle from slope
    rotation_angle_rad = math.atan(slope)
    # Convert to degrees
    rotation_angle_deg = math.degrees(rotation_angle_rad)
    # Generate rotation matrix
    rotation_matrix = pcd.get_rotation_matrix_from_xyz(
        (0, 0, -rotation_angle_deg))
    # Apply rotation
    pcd.rotate(rotation_matrix, (0, 0, 0))

    return pcd


# Generate rotation matrix with random axis/angle and apply to point cloud
def rotate_pcd_randomly(pcd):
    # Generate random rotation axis and angle
    random_axis = np.random.rand(3)  # Random rotation axis
    random_axis = random_axis / np.linalg.norm(random_axis)  # Normalize axis

    random_angle = np.random.uniform(0, 2 * np.pi)  # Random angle (0-2π radians)

    # Generate rotation matrix
    rotation_matrix = o3d.geometry.get_rotation_matrix_from_axis_angle(
        random_axis * random_angle)

    # Rotate around origin (0, 0, 0)
    pcd.rotate(rotation_matrix, center=(0, 0, 0))

    return pcd


# Rotate point cloud around Z-axis with random angle
def rotate_pcd_around_z(pcd):
    # Generate random rotation angle (0-2π)
    random_angle = np.random.uniform(0, 2 * np.pi)

    # Generate Z-axis rotation matrix
    rotation_matrix = o3d.geometry.get_rotation_matrix_from_xyz(
        (0, 0, random_angle))

    # Apply rotation
    pcd.rotate(rotation_matrix, center=(0, 0, 0))

    return pcd


# Generate normal distributed random number within specified range
def generate_normal_random_within_range(mean, std_dev, lower_bound,
                                        upper_bound):
    while True:
        # Generate normally distributed random number
        number = np.random.normal(mean, std_dev)

        # Check if within bounds
        if lower_bound <= number <= upper_bound:
            return number


# Random height adjustment
def height_random(pcd, mean, std_dev, lower_bound, upper_bound):

    points_np = np.asarray(pcd.points)

    random_z = generate_normal_random_within_range(mean, std_dev, lower_bound,
                                                   upper_bound)

    # Add random Z value to all points
    points_np[:, 2] += random_z

    # Update point coordinates
    pcd.points = o3d.utility.Vector3dVector(points_np)


# Canopy simulation
def sim(group_count, distance, pcd, mean, std_dev, lower_bound, upper_bound):

    pcd_out = o3d.geometry.PointCloud()

    for i in range(group_count):
        for j in range(group_count):

            # Create copy of point cloud
            pcd_tmp = copy.deepcopy(pcd)

            # Apply random rotation
            rotate_pcd_around_z(pcd_tmp)

            # Apply random height adjustment
            height_random(pcd_tmp, mean, std_dev, lower_bound, upper_bound)

            # Get point coordinates
            points_np = np.asarray(pcd_tmp.points)

            # Offset coordinates
            points_np[:, 0] += distance * i
            points_np[:, 1] += distance * j

            # Update point coordinates
            pcd_tmp.points = o3d.utility.Vector3dVector(points_np)

            pcd_out += pcd_tmp

    return pcd_out


# Extract central region of point cloud
def get_group_center(pcd, min, max):
    # Get point cloud data
    points_np = np.asarray(pcd.points)
    colors_np = np.asarray(pcd.colors)
    normals_np = np.asarray(pcd.normals)

    # Filter points within specified range
    mask = (points_np[:, 0] > min) & (points_np[:, 0] < max) & (
        points_np[:, 1] > min) & (points_np[:, 1] < max)
    filtered_points = points_np[mask]
    filtered_colors = colors_np[mask]
    filtered_normals = normals_np[mask]

    # Create new point cloud with filtered data
    filtered_pcd = o3d.geometry.PointCloud()
    filtered_pcd.points = o3d.utility.Vector3dVector(filtered_points)
    filtered_pcd.colors = o3d.utility.Vector3dVector(filtered_colors)
    filtered_pcd.normals = o3d.utility.Vector3dVector(filtered_normals)

    return filtered_pcd


# COV value calculation
def get_cov(pcd, in_value):

    cov_pcd = pcd.voxel_down_sample(in_value)

    count = np.asarray(cov_pcd.points)

    cov_value = len(count) * in_value**3

    return cov_value


folder = select_folder()

ply_list = get_ply_files(folder)

# Record program start time
start_time = time.time()

# Set parameters
# Row and column number of plants in the canopy
group_count = 4

# Plant spacing
distance = 20

# Lower bound
lower_bound = 0

# Upper bound
upper_bound = 5

# Set mean to midpoint of range
mean = upper_bound / 2

# Standard deviation
std_dev = 2

csv_path = os.path.join(folder, 'covs.csv')

with open(csv_path, mode='w', newline='') as csv_file:
    csv_writer = csv.writer(csv_file)

    csv_writer.writerow(['file_name'] + ['cov_value'])

    total_files = len(ply_list)
    for i, ply_path in enumerate(ply_list):

        pure_name = os.path.splitext(os.path.basename(ply_path))[0]

        ply = o3d.io.read_point_cloud(ply_path)
        pcd = o3d.geometry.PointCloud(ply)

        # Center alignment and rotation correction
        pcd = pcd_reset_position(pcd)

        # Generate canopy (group of plants) simulation
        pcd_group = sim(group_count, distance, pcd, mean, std_dev, lower_bound,
                        upper_bound)

        # Select central region
        min = distance / 2

        max = (group_count - 1) * distance - distance / 2

        pcd_group_final = get_group_center(pcd_group, min, max)

        # Calculate COV value
        cov_in_value = 0.1

        cov = get_cov(pcd_group_final, cov_in_value)

        # Write to CSV
        csv_writer.writerow([pure_name, cov])

        # Calculate and display progress
        progress = (i + 1) / total_files

        # Progress bar length
        bar_length = 30

        block = int(round(bar_length * progress))
        progress_str = f'\r[{"█" * block + "-" * (bar_length - block)}] {i + 1}/{total_files} ({progress * 100:.2f}%)Processing:{pure_name}'
        sys.stdout.write(progress_str)
        sys.stdout.flush()


# Record program end time
end_time = time.time()
elapsed_time = end_time - start_time

# Print program execution time
print()
print(f"Computation time: {elapsed_time:.2f} seconds")

