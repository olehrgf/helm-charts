#!/bin/bash

cd "$1" || exit

for file in *; do
  if [ -d "$file" ]; then
    echo "Packing $file chart..."
    helm package "./$file"
    echo "Done"
  fi
done

echo "Indexing charts..."
helm repo index . --merge index.yaml
echo "Done"
