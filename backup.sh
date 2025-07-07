#!/bin/bash

# Usage: ./backup.sh /path/to/dir

set -e

if [ $# -ne 1 ]; then
	echo "Usage: $0 /path/to/dir"
	exit 1
fi

SRCDIR="$1"
BASENAME=$(basename "$SRCDIR")
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
ARCHIVE="${BASENAME}_${TIMESTAMP}.tar.gz"

tar -czf "$ARCHIVE" -C "$(dirname "$SRCDIR")" "$BASENAME"

sha256sum "$ARCHIVE" > "${ARCHIVE}.sha256"

echo "Backup complete:"
echo "	Archive: $ARCHIVE"
echo "	Checksum: ${ARCHIVE}.sha256"

