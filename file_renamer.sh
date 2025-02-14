#!/bin/bash

rename_files() {
  local root_dir="$1"
  local old_text="$2"
  local new_text="$3"

  while IFS= read -r -d '' file; do
    # Rename file if it contains the old text
    new_filename="${file//$old_text/$new_text}"
    if [[ "$new_filename" != "$file" ]]; then
      mv "$file" "$new_filename"
      echo "Renamed file: $file -> $new_filename"
      file="$new_filename"
    fi

    # Replace text within the file
    if file "$file" | grep -q "text"; then
      if ! sed -i "s/$old_text/$new_text/g" "$file"; then
        echo "Error replacing text in: $file"
      else
        echo "Replaced text in: $file"
      fi
    else
      echo "Skipped binary file: $file"
    fi
  done < <(find "$root_dir" -type f -print0)
}

read -p "Enter the root directory: " root_dir
read -p "Enter the old text to replace: " old_text
read -p "Enter the new text to replace: " new_text

rename_files "$root_dir" "$old_text" "$new_text"
echo "Finished."