#!/usr/bin/env python3
"""Sign result CSVs with SHA-256 and append Data-SHA trailer."""
import hashlib
import pathlib
import sys

def main():
    results_dir = pathlib.Path("results")
    if not results_dir.exists():
        results_dir.mkdir(parents=True)
    
    paths = list(results_dir.glob("**/*.csv"))
    if not paths:
        print("No CSV results found to sign")
        return
    
    digest = hashlib.sha256()
    for p in sorted(paths):  # Sort for deterministic hashing
        print(f"Signing: {p}")
        digest.update(p.read_bytes())
    
    sha = digest.hexdigest()
    print(f"Data-SHA: {sha}")
    
    # Write signature file
    sha_file = results_dir / "DATA_SHA.txt"
    sha_file.write_text(f"{sha}\n")
    print(f"Signature written to: {sha_file}")

if __name__ == "__main__":
    main()