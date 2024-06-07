#!/bin/bash

compress_with_best_level() {
    local FILE=$1
    local BEST_SIZE=$(stat -c%s "$FILE")
    local BEST_LEVEL=0
    local TEMP_FILE="${FILE}.temp"

    # Test Brotli compression with different levels
    for LEVEL in {1..11}; do
        brotli -c --quality=$LEVEL "$FILE" > "$TEMP_FILE"
        COMPRESSED_SIZE=$(stat -c%s "$TEMP_FILE")

        if [ $COMPRESSED_SIZE -lt $BEST_SIZE ]; then
            BEST_SIZE=$COMPRESSED_SIZE
            BEST_LEVEL=$LEVEL
        fi
    done

    if [ $BEST_LEVEL -gt 0 ]; then
        brotli -c --quality=$BEST_LEVEL "$FILE" > "${FILE}.br"
        echo "Brotli compression successful for $FILE with level $BEST_LEVEL."
    else
        echo "Brotli compression not efficient for $FILE, keeping original."
    fi

    # Test Gzip compression with different levels
    for LEVEL in {1..9}; do
        gzip -c -$LEVEL "$FILE" > "$TEMP_FILE"
        COMPRESSED_SIZE=$(stat -c%s "$TEMP_FILE")

        if [ $COMPRESSED_SIZE -lt $BEST_SIZE ]; then
            BEST_SIZE=$COMPRESSED_SIZE
            BEST_LEVEL=$LEVEL
        fi
    done

    if [ $BEST_LEVEL -gt 0 ]; then
        gzip -c -$BEST_LEVEL "$FILE" > "${FILE}.gz"
        echo "Gzip compression successful for $FILE with level $BEST_LEVEL."
    else
        echo "Gzip compression not efficient for $FILE, keeping original."
    fi

    rm -f "$TEMP_FILE"
}

compress_directory() {
    local DIR=$1
    for FILE in $(find $DIR -type f -name "*.*"); do
        compress_with_best_level "$FILE"
    done
}

compress_directory $1
