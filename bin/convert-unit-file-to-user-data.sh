#!/bin/bash

(
echo "  units:"
for f in $@ ; do
	echo "    - name: $f"
	echo "      command: start"
	echo "      content: |"
	sed -e 's/^/        /' $f
done
)
