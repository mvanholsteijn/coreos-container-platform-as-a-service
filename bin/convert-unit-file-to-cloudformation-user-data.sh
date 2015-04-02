#!/bin/bash

(
echo "  units:"
for f in $@ ; do
	echo "    - name: $f"
	echo "      command: start"
	echo "      content: |"
	sed -e '/Global=true/d' -e 's/^/        /' $f
done
) | sed -e 's/"/\\"/g' -e 's/^/	"/' -e 's/$/\\n",/'
