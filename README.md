# 16px Labs — website

Static site (no build step). `index.html` + assets in `a/`.

- `a/<game>.mp4` — background gameplay loops (1280 px, 24 fps, Figma edge fade baked in)
- `a/demo_<game>.mp4` — clean gameplay for "Play demo", loaded only on click
- `a/p_<game>.jpg` — first frames shown while a video loads

Deployed on Vercel; every push to `main` goes live.
