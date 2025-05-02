import os
import shutil
import sys

input_dir = sys.argv[1]
output_dir = sys.argv[2]

if not os.path.exists(output_dir):
    os.makedirs(output_dir)

used_names = {}

for root, _, files in os.walk(input_dir):
    rel_dir = os.path.relpath(root, input_dir)
    depth = 0 if rel_dir == '.' else rel_dir.count(os.sep) + 1

    for file in files:
        full_path = os.path.join(root, file)
        base, ext = os.path.splitext(file)
        new_name = f"{base}_d{depth}{ext}"

        if new_name in used_names:
            used_names[new_name] += 1
            new_name = f"{base}_d{depth}_{used_names[new_name]}{ext}"
        else:
            used_names[new_name] = 1

        shutil.copy2(full_path, os.path.join(output_dir, new_name))
