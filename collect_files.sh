#!/usr/bin/env python3
import os
import sys
import shutil

def copy_files(src_dir, dest_dir, max_depth=None):
    file_count = {}
    
    for root, dirs, files in os.walk(src_dir):
        current_depth = root[len(src_dir):].count(os.sep)
        
        if max_depth is not None and current_depth > max_depth:
            continue
            
        rel_path = os.path.relpath(root, src_dir)
        dest_path = os.path.join(dest_dir, rel_path)
        os.makedirs(dest_path, exist_ok=True)
        
        for file in files:
            src_file = os.path.join(root, file)
            base, ext = os.path.splitext(file)
            
            dest_file = os.path.join(dest_path, file)
            counter = 1
            while os.path.exists(dest_file):
                dest_file = os.path.join(dest_path, f"{base}_{counter}{ext}")
                counter += 1
                
            shutil.copy2(src_file, dest_file)

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: ./collect_files.sh <source_dir> <dest_dir> [max_depth]")
        sys.exit(1)
        
    src_dir = sys.argv[1]
    dest_dir = sys.argv[2]
    
    
    max_depth = None
    if len(sys.argv) > 3:
        try:
            max_depth = int(sys.argv[3]) if sys.argv[3].strip() != '' else None
        except ValueError:
            print("Error: max_depth must be an integer or empty")
            sys.exit(1)
    
    if not os.path.exists(src_dir):
        print(f"Error: Source directory '{src_dir}' does not exist")
        sys.exit(1)
        
    try:
        copy_files(src_dir, dest_dir, max_depth)
        print(f"Files copied successfully from {src_dir} to {dest_dir}")
    except Exception as e:
        print(f"Error: {str(e)}")
        sys.exit(1)
