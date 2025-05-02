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
        new_name = f"{base}_d{depth}{ext}"

      
        final_name = new_name
        counter = 1
        while final_name in used_names:
            final_name = f"{base}_d{depth}_{counter}{ext}"
            counter += 1

        used_names[final_name] = True
        shutil.copy2(full_path, os.path.join(output_dir, final_name))
