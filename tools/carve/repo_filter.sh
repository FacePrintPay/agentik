#!/bin/bash
# Filter repo to subdirectory

set -e

OUTPUT_DIR="out/extracted"
PROVENANCE_DIR="docs/provenance"

for repo_dir in "$@"; do
    if [ ! -d "$repo_dir/.git" ]; then
        echo "Not a git repo: $repo_dir"
        continue
    fi
    
    base=$(basename "$repo_dir")
    output="$OUTPUT_DIR/${base}_filtered"
    
    # Clone and filter (assume git-filter-repo available)
    git clone "$repo_dir" "$output"
    cd "$output"
    git filter-repo --to-subdirectory-filter src/ || echo "Filter failed, keeping original"
    cd - > /dev/null
    
    # Provenance
    hash=$(find "$repo_dir" -type f -exec sha256sum {} \; | sha256sum | cut -d' ' -f1)
    json_file="$PROVENANCE_DIR/${base}_provenance.json"
    cat > "$json_file" << EOF
{
  "original_repo": "$repo_dir",
  "hash": "$hash",
  "extraction_type": "repo_filter",
  "extracted_at": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "output_dir": "$output"
}
EOF
    
    echo "Filtered: $repo_dir -> $output"
done