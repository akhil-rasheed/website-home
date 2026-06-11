# akhilrasheed.com

## Photography Workflow

To add a new photo gallery to the site:

1. **Prepare Images**: Place your JPEGs in a local folder.
2. **Run Automation Script**: Use `new-gallery.sh` to generate the front matter and upload images to Cloudflare R2.
   ```bash
   R2_BUCKET=your-bucket-name ./new-gallery.sh ~/path/to/photos gallery-slug
   ```
   * The script requires `ImageMagick` (`identify`) and `rclone` (configured with a remote named `r2`).
   * It will output a YAML `photos` block to stdout.
3. **Create Post**: Create a new markdown file in `posts/` (e.g., `posts/my-trip.md`).
4. **Add Front Matter**: Paste the generated `photos` block into the front matter, set `layout: gallery`, and add a `cover` image.
   ```yaml
   ---
   title: "Gallery Title"
   date: 2025-12-02
   layout: gallery
   tags: [photography]
   cover: gallery-slug/image.jpg
   photos:
     # ... pasted from script output
   ---
   ```

The site automatically handles image resizing via Cloudflare Image Transforms and provides a lightbox experience using PhotoSwipe.
