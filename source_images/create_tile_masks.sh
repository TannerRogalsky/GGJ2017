#!/bin/bash
for filename in source_images/Tiles/*.png; do
  basename=$(basename "$filename" .png)
  convert $filename -fuzz 20% -transparent '#6cd0fe' -alpha extract -negate source_images/Tile_Masks/"$basename"_mask.png
done
