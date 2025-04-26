#!/bin/bash

if [[ "$1" == "--max_depth" ]]; then
    MAX_DEPTH="$2"
    INPUT_DIR="$3"
    OUTPUT_DIR="$4"
else
    INPUT_DIR="$1"
    OUTPUT_DIR="$2"
    MAX_DEPTH=""
fi

if [ -z "$INPUT_DIR" ] || [ -z "$OUTPUT_DIR" ]; then
    echo "Usage: $0 [--max_depth N] <input_dir> <output_dir>"
    exit 1
fi

mkdir -p "$OUTPUT_DIR"

declare -A seen

copy_files() {
    local input_dir="$1"
    local output_dir="$2"
    local max_depth="$3"

    local input_dir_abs=$(realpath "$input_dir")

    find "$input_dir" -type f | while read -r filepath; do
        local filepath_abs=$(realpath "$filepath")

       
        local relative_path="${filepath_abs#$input_dir_abs/}"

      
        if [[ "$relative_path" == *"/"* ]]; then
            depth=$(grep -o "/" <<< "$relative_path" | wc -l)
        else
            depth=0
        fi

      
        if [[ -n "$max_depth" && "$depth" -gt "$max_depth" ]]; then
            continue
        fi

        local filename=$(basename "$filepath")
        local target="$output_dir/$filename"

        if [[ -e "$target" ]]; then
            counter=${seen["$filename"]}
            counter=$((counter + 1))
            seen["$filename"]=$counter
            extension="${filename##*.}"
            name="${filename%.*}"
            target="$output_dir/${name}_${counter}.$extension"
        else
            seen["$filename"]=0
        fi

        cp "$filepath" "$target"
    done
}

copy_files "$INPUT_DIR" "$OUTPUT_DIR" "$MAX_DEPTH"
