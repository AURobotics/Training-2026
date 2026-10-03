#import "/Theme/report.typ": (
  brand-palette, cover-page, emphasis, pause-page-counting, report-template, resume-page-counting, watermark_text,
)

#import "@preview/calloutly:1.1.0": caution, important, note, tip
#import "/Theme/common.typ": setup-codly

#show: setup-codly

#cover-page(title: [Training '26], subtitle: [Software | Phase III], topic: "Computer Vision Workshop")

#show: report-template.with(ribbon-text: " Computer Vision Workshop")

= Introduction to Computer Vision Basics

Before we dive into the tasks, let's review the fundamental concepts you will be using today. In OpenCV, an image is just a *NumPy array* of pixel values. Here is a quick refresher on the components you'll need across all four tasks:

- *Image Array:* A `(height, width, 3)` `uint8` array, where each pixel holds a Blue/Green/Red (or Red/Green/Blue) triplet.
- *Slicing:* Assigning a color to a rectangular region of the array (e.g. `img[y0:y1, x0:x1] = color`) draws a filled rectangle.
- *Color Conversion:* `cv2.cvtColor()` converts between color spaces (e.g. `RGB2BGR`, `BGR2HSV`, `BGR2GRAY`).
- *Display Loop:* `cv2.imshow()` renders a frame, and `cv2.waitKey(ms)` both pauses for a duration and lets the window process events/keypresses.
- *HSV & Masking:* HSV separates *Hue*, *Saturation*, and *Value*, making it easier to isolate a color than in BGR. `cv2.inRange()` builds a binary mask from a color range.
- *Blurring & Edge Detection:* `cv2.GaussianBlur()` reduces noise before running `cv2.Canny()` for edge detection.
- *Contours & Shape Analysis:* `cv2.findContours()` extracts shape outlines from an edge map; `cv2.approxPolyDP()` and `cv2.moments()` help classify and locate them.

---------

= Task 1: Animated Night Building

*Goal:* Draw a night-time building scene with a grid of windows, then animate the scene so that on every frame, exactly 4 random windows are lit while all others stay dark.

== Guidance & Architecture
- *Static scene:* Fill the sky, ground, and building as solid colored rectangles using array slicing.
- *Window grid:* Precompute the `(row, col)` position of every window so it can be referenced by index.
- *Per-frame update:* Reset every window to "off," then pick 4 *distinct* window indices at random and set them to "on."
- *Render:* Convert the frame from RGB to BGR and display it, waiting long enough between frames to see the change.

#align(center)[
  #image("assets/night_building.png", width: 40%, height: 30%)
]

= Task 2: HSV Color Swapping with Masks

*Goal:* Load an image and cyclically swap three colors — every orange pixel becomes red, every red pixel becomes green, and every green pixel becomes orange.

== Guidance & Architecture
- *Color space:* Convert the image from BGR to *HSV*, since isolating a color by hue is far more reliable in HSV than in BGR.
- *Masking:* For each target color, define a `lower`/`upper` HSV range and build a binary mask with `cv2.inRange()` — a mask is `255` wherever a pixel falls in that color's range, `0` elsewhere.
- *Recoloring:* Use each mask to select only the matching pixels in the result image, and overwrite just those pixels with the new BGR color.

#tip[
  Isolating a color by hue is far more reliable in *HSV* than in BGR — convert first, then build a mask per color.
]

#note[
  There are *two* valid ways to apply a mask's color change, and both produce the *same result*:
  - *Vectorized (NumPy) method:* `result[mask > 0] = [B, G, R]` — recolors every matching pixel in one operation. This is the fast, idiomatic OpenCV/NumPy approach.
  - *Manual pixel loop:* nested `for y / for x` loops that check each mask value individually and recolor pixel-by-pixel. Slower, but makes explicit what the vectorized line is doing under the hood.

  *The NumPy way is better and faster than Manual way*
]

= Task 3: Real-Time Edge Detection on Video

*Goal:* Read a video file frame-by-frame and display a live edge-detected version of it.

== Guidance & Architecture
- *Video capture:* Open the video with `cv.VideoCapture()` and check `cap.isOpened()` before looping — a failed open should stop the program early.
- *Frame loop:* Call `cap.read()` each iteration; it returns `(ret, frame)`. When `ret` is `False`, the stream has ended (or a frame failed to read), so the loop should break.
- *Preprocessing:* Convert each frame to grayscale, then apply a *Gaussian blur* to reduce noise — edge detectors are sensitive to noise, so blurring first gives cleaner edges.
- *Edge detection:* Run `cv.Canny()` on the blurred grayscale frame to extract edges.
- *Display & exit:* Show each processed frame with `cv.imshow()`; `cv.waitKey(20)` both paces the playback and lets the *Esc* key (`27`) break the loop.
- *Cleanup:* Release the capture and destroy windows once the loop ends, so the video file handle isn't left open.

= Task 4: Shape Detection & Counting

*Goal:* Detect every shape on the sheet of paper, classify each one as a triangle, square, rectangle, or circle, label it on the image, and print a total count per shape.

== Guidance & Architecture
- *Preprocessing:* Convert to grayscale, blur to reduce noise, then run `Canny` edge detection — the same pipeline as Task 3, reused here as a precursor to contour detection.
- *Contours:* `cv2.findContours()` on the edge map returns the outline of every detected shape.
- *Noise filtering:* Skip any contour with a small `cv2.contourArea()` — these are stray edges/artifacts, not real shapes.
- *Polygon approximation:* `cv2.approxPolyDP()` simplifies each contour into a polygon; the number of resulting vertices tells us the shape family:
  - `3` vertices → *Triangle*
  - `4` vertices → *Square* or *Rectangle*, disambiguated by checking the bounding box's aspect ratio (close to `1.0` → Square, otherwise → Rectangle)
  - anything else → *Circle*
- *Centroid & labeling:* `cv2.moments()` gives the contour's centroid `(cx, cy)`, used to place the shape's name as text at its center.
- *Counting:* A `counts` dictionary tallies how many of each shape were found.

#note[
  *This image contains:*
  - 4 squares
  - 4 circles
  - 4 triangles
  - 3 rectangles

  Any other shape is considered noise.
]

== Input Image
\
#align(center)[
  #image("assets/Shapes.jpg", width: 80%)
]