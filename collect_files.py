
import os
import shutil
import sys

input_dir = sys.argv[1]
output_dir = sys.argv[2]

if not os.path.exists(output_dir):
    os.makedirs(output_dir)

used_names = {}

for root, _, files in os.walk(input_dir):
    for file in files:
        full_path = os.path.join(root, file)
        rel_path = os.path.relpath(full_path, input_dir)
        depth = rel_path.count(os.sep)

        base, ext = os.path.splitext(file)
        new_name = file

        if file in used_names:
            count = used_names[file] + 1
            new_name = f"{base}_d{depth}_{count}{ext}"
            used_names[file] = count
        else:
            new_name = f"{base}_d{depth}{ext}"
            used_names[file] = 1

        shutil.copy2(full_path, os.path.join(output_dir, new_name))
