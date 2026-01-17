#!/bin/bash
# Extract text from PDF and carve code blocks

set -e

OUTPUT_DIR="out/extracted"
PROVENANCE_DIR="docs/provenance"

for file in "$@"; do
    base=$(basename "$file" .pdf)
    txt_file="$OUTPUT_DIR/${base}.txt"
    output="$OUTPUT_DIR/${base}_extracted.md"
    
    # Convert PDF to text
    pdftotext "$file" "$txt_file"
    
    # Extract code blocks (heuristic: lines starting with common keywords)
    grep -E '^(def |function |class |import |from )' "$txt_file" > "$output" || true
    
    # Provenance
    hash=$(sha256sum "$file" | cut -d' ' -f1)
    json_file="$PROVENANCE_DIR/${base}_provenance.json"
    cat > "$json_file" << EOF
{
  "original_file": "$file",
  "hash": "$hash",
  "extraction_type": "pdf_text_code",
  "extracted_at": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "output_file": "$output"
}
EOF
    
    echo "Extracted: $file -> $output"
done