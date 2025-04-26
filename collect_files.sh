#!/bin/bash

if [ "$#" -lt 2 ]; then
    echo "Usage: $0 [--max_depth N] <input_dir> <output_dir>"
    exit 1
fi

MAX_DEPTH=""
INPUT_DIR=""
OUTPUT_DIR=""

if [[ "$1" == "--max_depth" ]]; then
    MAX_DEPTH="$2"
    INPUT_DIR="$3"
    OUTPUT_DIR="$4"
else
    INPUT_DIR="$1"
    OUTPUT_DIR="$2"
fi

if [ ! -d "$INPUT_DIR" ]; then
    echo "Input directory does not exist"
    exit 1
fi

mkdir -p "$OUTPUT_DIR"

declare -A file_counters

copy_files() {
    local input_dir="$1"
    local output_dir="$2"
    local max_depth="$3"
    local input_dir_depth=$(echo "$input_dir" | grep -o "/" | wc -l)

    if [ -n "$max_depth" ]; then
        find "$input_dir" -type f | while read filepath; do
            current_depth=$(echo "$filepath" | grep -o "/" | wc -l)
            relative_depth=$((current_depth - input_dir_depth))
            if [ "$relative_depth" -le "$max_depth" ]; then
                echo "$filepath"
            fi
        done
    else
        find "$input_dir" -type f
    fi
}

while IFS= read -r filepath; do
    filename=$(basename "$filepath")

    if [[ -e "$OUTPUT_DIR/$filename" ]]; then
        base="${filename%.*}"
        ext="${filename##*.}"
        ((file_counters["$filename"]++))
        new_filename="${base}_${file_counters["$filename"]}.$ext"
    else
        file_counters["$filename"]=0
        new_filename="$filename"
    fi

    cp "$filepath" "$OUTPUT_DIR/$new_filename"
done < <(copy_files "$INPUT_DIR" "$OUTPUT_DIR" "$MAX_DEPTH")
