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


def get_subdirectories(folder_path):
    """Retrieve all second-level directories (for rice varieties) under the first-level directory."""
    subdirs = []
    for item in os.listdir(folder_path):
        item_path = os.path.join(folder_path, item)
        if os.path.isdir(item_path):
            subdirs.append(item_path)

    print("Found subdirectories (rice varieties):")
    for subdir in subdirs:
        print(f"  - {os.path.basename(subdir)}")

    return subdirs


def get_ply_files_from_subdir(subdir_path):
    """Get all PLY files from the second-level directory."""
    ply_files = []

    for root, dirs, files in os.walk(subdir_path):
        for file in files:
            if file.endswith('.ply'):
                ply_files.append(os.path.normpath(os.path.join(root, file)))

    print(f"Found {len(ply_files)} PLY files in {os.path.basename(subdir_path)}:")
    for ply_file in ply_files:
        print(f"  - {os.path.basename(ply_file)}")

    return ply_files


def safe_translate(pcd, translation, relative=True):
    """
    Args:
    pcd: The point cloud object.
    translation: The translation vector [x, y, z].
    relative: Whether it is a relative translation.
    """
    try:
        # Try to use Open3D translate function
        return pcd.translate(translation, relative=relative)
    except Exception as e:
        print(f"Open3D translate failed: {e}, use alternative method")
        # Alternative approach: Directly manipulate the point cloud data
        points = np.asarray(pcd.points)
        if relative:
            points += translation
        else:
            points = points + translation - np.mean(points, axis=0)

        # Create a new point cloud object.
        new_pcd = o3d.geometry.PointCloud()
        new_pcd.points = o3d.utility.Vector3dVector(points)

        # Copy the colors and normals if available.
        if pcd.has_colors():
            new_pcd.colors = o3d.utility.Vector3dVector(np.asarray(pcd.colors))
        if pcd.has_normals():
            new_pcd.normals = o3d.utility.Vector3dVector(np.asarray(pcd.normals))

        return new_pcd


# Center alignment and rotation
def pcd_reset_position(pcd):
    z_max = 200
    z_min = 0

    points_np = np.asarray(pcd.points)

    min_index = np.where(points_np[:, 2] == np.min(points_np[:, 2]))
    min_index = min_index[0]
    min_points = points_np[min_index]

    invert = -min_points[0]
    print('before translate', pcd, invert)

    try:
        pcd = pcd.translate(invert, relative=True)
    except Exception as e:
        print('e:', e)
    print('after translate', pcd)

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


# Canopy simulation for multiple plants
def sim_multiple_plants(plant_pcds, group_count, distance, mean, std_dev,
                        lower_bound, upper_bound):
    """
    Args:
    plant_pcds: List of plant point cloud objects.
    group_count: Number of rows and columns in the grid.
    distance: Spacing distance between plants.
    mean: Mean value for height randomization.
    std_dev: Standard deviation for height randomization.
    """
    pcd_out = o3d.geometry.PointCloud()

    # Ensure there are enough plant point clouds.
    if len(plant_pcds) < group_count * group_count:
        print(
            f"Warning: Only {len(plant_pcds)} plants available, but need {group_count * group_count}"
        )
        # Reuse the existing plant point clouds.
        plant_pcds = plant_pcds * (
            group_count * group_count // len(plant_pcds) + 1)
        plant_pcds = plant_pcds[:group_count * group_count]
        # 随机打乱顺序
        np.random.shuffle(plant_pcds)

    plant_idx = 0

    for i in range(group_count):
        for j in range(group_count):
            # use point cloud from the list
            if plant_idx < len(plant_pcds):
                pcd_tmp = copy.deepcopy(plant_pcds[plant_idx])
                plant_idx += 1
            else:
                # if not enough, reuse the last one
                pcd_tmp = copy.deepcopy(plant_pcds[-1])

            # apply random rotation around Z-axis
            rotate_pcd_around_z(pcd_tmp)

            # apply random height adjustment
            height_random(pcd_tmp, mean, std_dev, lower_bound, upper_bound)

            # Get point cloud data
            points_np = np.asarray(pcd_tmp.points)

            # Calculate translation offsets
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

    # Check if colors and normals exist
    has_colors = pcd.has_colors()
    has_normals = pcd.has_normals()

    if has_colors:
        colors_np = np.asarray(pcd.colors)
    if has_normals:
        normals_np = np.asarray(pcd.normals)

    # Filter points within specified range
    mask = (points_np[:, 0] > min) & (points_np[:, 0] < max) & (
        points_np[:, 1] > min) & (points_np[:, 1] < max)
    filtered_points = points_np[mask]

    # Create new point cloud with filtered data
    filtered_pcd = o3d.geometry.PointCloud()
    filtered_pcd.points = o3d.utility.Vector3dVector(filtered_points)

    if has_colors:
        filtered_colors = colors_np[mask]
        filtered_pcd.colors = o3d.utility.Vector3dVector(filtered_colors)
    if has_normals:
        filtered_normals = normals_np[mask]
        filtered_pcd.normals = o3d.utility.Vector3dVector(filtered_normals)

    return filtered_pcd


# COV value calculation
def get_cov(pcd, in_value):
    cov_pcd = pcd.voxel_down_sample(in_value)
    count = np.asarray(cov_pcd.points)
    cov_value = len(count) * in_value**3
    print(f"COV value: {cov_value}")
    return cov_value


def process_variety(subdir_path, group_count, distance, mean, std_dev, lower_bound, upper_bound, csv_writer):
    """Process a single rice variety directory to compute COV values."""
    variety_name = os.path.basename(subdir_path)
    print(f"\nProcessing variety: {variety_name}")

    # get all PLY files in the subdirectory
    ply_files = get_ply_files_from_subdir(subdir_path)

    if len(ply_files) == 0:
        print(f"No PLY files found in {variety_name}")
        return

    # Load and preprocess all plant point clouds
    plant_pcds = []
    for ply_path in ply_files:
        try:
            ply = o3d.io.read_point_cloud(ply_path)
            pcd = o3d.geometry.PointCloud(ply)
            print(f"Processing plant: {os.path.basename(ply_path)}")

            # Center alignment and rotation
            pcd = pcd_reset_position(pcd)
            plant_pcds.append(pcd)

        except Exception as e:
            print(f"Error processing {ply_path}: {e}")

    if len(plant_pcds) == 0:
        print(f"No valid plant point clouds found in {variety_name}")
        return

    # Generate 6 canopy models for each variety and calculate COV
    for group_idx in range(6):
        print(f"Generating group {group_idx + 1}/6 for {variety_name}")

        # Shuffle plant point clouds
        np.random.shuffle(plant_pcds)

        # generate canopy model
        pcd_group = sim_multiple_plants(plant_pcds, group_count, distance, mean, std_dev, lower_bound, upper_bound)

        # save the generated canopy model
        # Create canopy directory path
        canopy_dir = os.path.join(subdir_path, "canopy")
        # Create directory if it doesn't exist
        os.makedirs(canopy_dir, exist_ok=True)
        # Save the canopy model
        group_ply_path = os.path.join(canopy_dir, f"{variety_name}_group{group_idx + 1}.ply")
        o3d.io.write_point_cloud(group_ply_path, pcd_group)

        # Extract central region
        min_val = distance / 2
        max_val = (group_count - 1) * distance - distance / 2

        pcd_group_final = get_group_center(pcd_group, min_val, max_val)

        # Calculate COV
        cov_in_value = 0.1
        cov = get_cov(pcd_group_final, cov_in_value)

        # Write to CSV 
        group_name = f"{variety_name}_group{group_idx + 1}"
        csv_writer.writerow([group_name, cov])
        print(f"Saved COV for {group_name}: {cov}")


# main program
folder = select_folder()
if not folder:
    print("No folder selected. Exiting.")
    sys.exit(1)

# get all subdirectories (rice varieties)
subdirectories = get_subdirectories(folder)

if len(subdirectories) == 0:
    print("No subdirectories found. Exiting.")
    sys.exit(1)

# record program start time
start_time = time.time()

# Parameters
group_count = 4  # row and column count
distance = 20    # spacing distance between plants
lower_bound = 0  # bottom bound
upper_bound = 5  # upper bound
mean = upper_bound / 2  # mean
std_dev = 2      # standard deviation

# create/open CSV file for writing results
csv_path = os.path.join(folder, 'covs_by_variety.csv')

with open(csv_path, mode='w', newline='', encoding='utf-8') as csv_file:
    print(f"Writing results to {csv_path}")
    csv_writer = csv.writer(csv_file)
    csv_writer.writerow(['variety_group', 'cov_value'])

    total_varieties = len(subdirectories)
    print(f"Total varieties to process: {total_varieties}")

    # process each variety
    for i, subdir_path in enumerate(subdirectories):
        variety_name = os.path.basename(subdir_path)
        print(f"\nProcessing variety {i + 1}/{total_varieties}: {variety_name}")

        try:
            process_variety(subdir_path, group_count, distance, mean, std_dev,
                           lower_bound, upper_bound, csv_writer)
        except Exception as e:
            print(f"Error processing variety {variety_name}: {e}")

        # Progress bar
        progress = (i + 1) / total_varieties
        bar_length = 30
        block = int(round(bar_length * progress))
        progress_str = f'\r[{"█" * block + "-" * (bar_length - block)}] {i + 1}/{total_varieties} ({progress * 100:.2f}%) Processing varieties'
        sys.stdout.write(progress_str)
        sys.stdout.flush()

# record program end time
end_time = time.time()
elapsed_time = end_time - start_time

# print output
print(f"\nComputation completed!")
print(f"Total time: {elapsed_time:.2f} seconds")
print(f"Results saved to: {csv_path}")
