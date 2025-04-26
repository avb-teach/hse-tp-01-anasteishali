#!/bin/bash

input_dir="$1"
output_dir="$2"
max_depth="$3"


if [ -z "$input_dir" ] || [ -z "$output_dir" ]; then
  echo "Usage: $0 <input_dir> <output_dir> [max_depth]"
  exit 1
fi


mkdir -p "$output_dir"


if [ -z "$max_depth" ]; then
  files=$(find "$input_dir" -type f)
else
  files=$(find "$input_dir" -maxdepth "$max_depth" -type f)
fi


for filepath in $files; do
  filename=$(basename "$filepath")
  target="$output_dir/$filename"

  counter=1
  while [ -e "$target" ]; do
    target="$output_dir/${filename%.*}$counter.${filename##*.}"
    counter=$((counter + 1))
  done

  cp "$filepath" "$target"
done
