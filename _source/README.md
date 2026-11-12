# Source files (not deployed)

- `encode/enc.sh` + `encode/mask16.png`: how the gameplay videos in `a/` were made from the original
  CleanShot recordings (1920x1082 @ 60 fps, Figma fade baked in with the 16-bit mask, seamless loop,
  H.264 + AV1, plus the clean `demo_*` files).
- `artwork-hires/`: covers, logos and icons rendered from Figma at 3-4x (PNG masters of the `.webp` files in `a/`).

`.vercelignore` keeps this folder out of the deployed site.
