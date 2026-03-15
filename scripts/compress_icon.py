from PIL import Image
import os

input_path = "assets/logo/app_icon.png"
output_path = "assets/logo/app_icon.png"

# Load image
img = Image.open(input_path)

# Resize to 192x192 (Perfect balance for launcher icons and file size)
img = img.resize((192, 192), Image.Resampling.LANCZOS)

# Convert to Palette mode (8-bit colors) for extreme compression
img = img.convert("P", palette=Image.Palette.ADAPTIVE, colors=256)

# Save with optimization and maximum compression level
img.save(output_path, "PNG", optimize=True, compress_level=9)

print(f"Icon aggressively compressed. New size: {os.path.getsize(output_path) // 1024} KB")
