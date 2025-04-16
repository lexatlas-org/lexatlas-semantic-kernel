#!/bin/bash

set -euo pipefail

DIR_PATH="$1"

print_file_content() {
    local file="$1"

    if [[ ! -f "$file" ]]; then
        printf "Skipping non-regular file: %s\n" "$file" >&2
        return
    fi

    local abs_path; abs_path=$(realpath "$file")
    if [[ -z "$abs_path" ]]; then
        printf "Failed to resolve absolute path for %s\n" "$file" >&2
        return
    fi

    printf "\n-----------------------------\n"
    printf "Content of %s\n" "$abs_path"
    printf "\n"
    if ! content=$(<"$file"); then
        printf "Failed to read content of %s\n" "$file" >&2
        return
    fi
    printf "%s\n" "$content"
}

collect_and_print_files() {
    local base="$1"

    if [[ ! -d "$base" ]]; then
        printf "Directory does not exist or is not a directory: %s\n" "$base" >&2
        return 1
    fi

    local file;
    while IFS= read -r -d '' file; do
        print_file_content "$file"
    done < <(find "$base" -type f -print0)
}

main() {
    if [[ -z "${DIR_PATH// /}" ]]; then
        printf "Usage: %s <directory>\n" "$0" >&2
        return 1
    fi

    collect_and_print_files "$DIR_PATH"
}

main "$@"
