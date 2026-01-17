#!/bin/bash
# Extract fenced code blocks from HTML

set -e

OUTPUT_DIR="out/extracted"
PROVENANCE_DIR="docs/provenance"

for file in "$@"; do
    base=$(basename "$file" .html)
    output="$OUTPUT_DIR/${base}_extracted.md"
    
    # Extract code blocks (assuming ``` fenced)
    grep -A 1000 -B 2 '```' "$file" > "$output" 2>/dev/null || true
    
    # Create provenance
    hash=$(sha256sum "$file" | cut -d' ' -f1)
    json_file="$PROVENANCE_DIR/${base}_provenance.json"
    cat > "$json_file" << EOF
{
  "original_file": "$file",
  "hash": "$hash",
  "extraction_type": "html_fenced_code",
  "extracted_at": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "output_file": "$output"
}
EOF
    
    echo "Extracted: $file -> $output"
done