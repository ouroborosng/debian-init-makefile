#!/bin/bash
set -e

echo "🎯 Restricting compiler access to root and trusted users only..."
COMPILERS=(/usr/bin/gcc /usr/bin/g++ /usr/bin/clang /usr/bin/clang++)

for COMPILER in "${COMPILERS[@]}"; do
    if [ -f "$COMPILER" ]; then
        echo "ℹ️ Setting permissions for $COMPILER"
        chown root:root $COMPILER
        chmod 750 $COMPILER
    fi
done

echo "✅ Compiler access has been restricted."