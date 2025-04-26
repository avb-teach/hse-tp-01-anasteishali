#!/bin/bash

max_depth=""
input_dir=""
output_dir=""

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --max_depth)
            max_depth="$2"
            shift 2
            ;;
        *)
            if [ -z "$input_dir" ]; then
                input_dir="$1"
            elif [ -z "$output_dir" ]; then
                output_dir="$1"
            else
                echo "Неизвестный параметр: $1"
                exit 1
            fi
            shift
            ;;
    esac
done

if [ -z "$input_dir" ] || [ -z "$output_dir" ]; then
    echo "Использование: $0 [--max_depth N] <входная_директория> <выходная_директория>"
    exit 1
fi

if [ ! -d "$input_dir" ]; then
    echo "Ошибка: входная директория не существует"
    exit 1
fi

mkdir -p "$output_dir"

copy_with_suffix() {
    local src="$1"
    local dest_dir="$2"
    local filename=$(basename "$src")
    local base="${filename%.*}"
    local ext="${filename##*.}"
    local counter=1
    local dest="$dest_dir/$filename"
    
    while [ -e "$dest" ]; do
        dest="$dest_dir/${base}_$counter.$ext"
        ((counter++))
    done
    
    cp "$src" "$dest"
}

export -f copy_with_suffix

find_cmd="find \"$input_dir\" -type f"
if [ -n "$max_depth" ]; then
    find_cmd="$find_cmd -maxdepth $max_depth"
fi

eval "$find_cmd" -exec bash -c 'copy_with_suffix "$0" "$1"' {} "$output_dir" \;
