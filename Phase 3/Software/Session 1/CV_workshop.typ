#import "/Theme/report.typ": (
  brand-palette, cover-page, emphasis, pause-page-counting, report-template, resume-page-counting, watermark_text,
)

#import "@preview/calloutly:1.1.0": caution, important, note, tip
#import "/Theme/common.typ": setup-codly

#show: setup-codly

#cover-page(title: [Training '26], subtitle: [Software | Phase III], topic: "Computer Vision Workshop")

#show: report-template.with(ribbon-text: " Computer Vision Workshop")

= Introduction to Computer Vision Basics

Before we dive into the task, let's review the fundamental concepts you will be using today. In OpenCV, an image is just a *NumPy array* of pixel values, and building a scene is really just filling regions of that array with color. Here is a quick refresher on the components we will use:

- *Image Array:* A `(height, width, 3)` `uint8` array, where each pixel holds a Blue/Green/Red (or Red/Green/Blue) triplet.
- *Slicing:* Assigning a color to a rectangular region of the array (e.g. `img[y0:y1, x0:x1] = color`) draws a filled rectangle — this is how the sky, ground, building, and windows are drawn.
- *Color Conversion:* `cv2.cvtColor()` converts between color orderings (e.g. RGB to BGR) before display, since OpenCV expects BGR.
- *Display Loop:* `cv2.imshow()` renders a frame, and `cv2.waitKey(ms)` both pauses for a duration and lets the window process events/keypresses — this is what drives an animation loop.

---

= Task 1: Animated Night Building

*Goal:* Draw a night-time building scene with a grid of windows, then animate the scene so that on every frame, exactly 4 random windows are lit while all others stay dark.

== Guidance & Architecture
For this task, the scene is built once, then repeatedly updated inside a loop:
- *Static scene:* Fill the sky, ground, and building as solid colored rectangles using array slicing.
- *Window grid:* Precompute the `(row, col)` position of every window so it can be referenced by index.
- *Per-frame update:* Reset every window to "off," then pick 4 *distinct* window indices at random and set them to "on."
- *Render:* Convert the frame from RGB to BGR and display it, waiting long enough between frames to see the change.

== Code

```python
import numpy as np
import cv2

height = 800
width = 600
SKY_COLOR         = (25, 25, 40)     # dark navy night sky
GROUND_COLOR       = (30, 50, 35)    # dark green ground
BUILDING_COLOR      = (90, 90, 100)  # grey building
WINDOW_OFF_COLOR   = (20, 20, 30)    # dark window
WINDOW_ON_COLOR    = (255, 220, 120) # warm yellow light

img = np.zeros((height, width, 3), dtype=np.uint8)
img[:] = SKY_COLOR
img[int(height * 0.85):height, :] = GROUND_COLOR
img[int(height * 0.1):int(height * 0.9), int(width * 0.2):int(width * 0.8)] = BUILDING_COLOR
windows = [(i, j) for i in range(6) for j in range(5)]

def draw_window(img, i, j, color):
    y0 = int(height * 0.1) + i * 100 + 20
    y1 = int(height * 0.1) + i * 100 + 70
    x0 = int(width * 0.2) + j * 75 + 15
    x1 = int(width * 0.2) + j * 75 + 45
    img[y0:y1, x0:x1] = color

#not neccessary, but just to draw the initial state of the building windows
for (i, j) in windows:
    draw_window(img, i, j, WINDOW_OFF_COLOR)

while True:
    # turn off every window first
    for (i, j) in windows:
        draw_window(img, i, j, WINDOW_OFF_COLOR)

    # then light up exactly 4 distinct windows
    chosen = np.random.choice(len(windows), size=4)
    for idx in chosen:
        i, j = windows[idx]
        draw_window(img, i, j, WINDOW_ON_COLOR)

    #change the color space from RGB to BGR for OpenCV display
    display_img = cv2.cvtColor(img, cv2.COLOR_RGB2BGR)
    
    cv2.imshow("Night", display_img)
    # wait for 1 second or until the user presses 'esc' to exit
    if cv2.waitKey(1000) == 27:  # 27 is the ASCII code for the 'ESC' key
        break
        
cv2.destroyAllWindows()
```

#align(center)[
  #image("assets/night_building.png", width: 40%, height: 30%)
]


= Task 2: HSV Color Swapping with Masks

*Goal:* Load an image and cyclically swap three colors — every orange pixel becomes red, every red pixel becomes green, and every green pixel becomes orange.

== Guidance & Architecture
- *Color space:* Convert the image from BGR to *HSV*, since isolating a color by hue is far more reliable in HSV than in BGR.
- *Masking:* For each target color, define a `lower`/`upper` HSV range and build a binary mask with `cv2.inRange()` — a mask is `255` wherever a pixel falls in that color's range, `0` elsewhere.
- *Recoloring:* Use each mask to select only the matching pixels in the result image, and overwrite just those pixels with the new BGR color.

#note[
  There are *two* ways shown in the code to apply a mask's color change, and both produce the *same result*:
  - *Vectorized (NumPy) method:* `result[mask > 0] = [B, G, R]` — recolors every matching pixel in one operation. This is the fast, idiomatic OpenCV/NumPy approach.
  - *Manual pixel loop:* nested `for y / for x` loops that check each mask value individually and recolor pixel-by-pixel. This is slower but makes explicit what the vectorized line is doing under the hood.

  In the code below, both methods run one after another on the same `result` image — the loop simply repeats the same recoloring the vectorized lines already did. In practice you'd only keep *one* of the two.
]

== Code

```python
import cv2
import numpy as np

# Load image
image = cv2.imread("task2.jpg")

# Convert BGR → HSV
hsv = cv2.cvtColor(image, cv2.COLOR_BGR2HSV)

# 1. CREATE THE MASKS

# Orange
lower_orange = np.array([5, 100, 100])
upper_orange = np.array([25, 255, 255])

orange_mask = cv2.inRange(hsv, lower_orange, upper_orange)

# Red
lower_red = np.array([0, 100, 100])
upper_red = np.array([10, 255, 255])

red_mask = cv2.inRange(hsv, lower_red, upper_red)

# Green
lower_green = np.array([35, 80, 80])
upper_green = np.array([90, 255, 255])

green_mask = cv2.inRange(hsv, lower_green, upper_green)

# 2. CREATE RESULT
result = image.copy()

# Advanced method using masks to change colors

# Orange → Red
result[orange_mask > 0] = [0, 0, 255]

# Red → Green
result[red_mask > 0] = [0, 255, 0]

# Green → Orange
# BGR value for orange
result[green_mask > 0] = [0, 165, 255]

height, width = image.shape[:2]

# Loop through each pixel and apply the color changes based on the masks
for y in range(height):
    for x in range(width):

        # Orange → Red
        if orange_mask[y, x] > 0:
            result[y, x] = [0, 0, 255]

        # Red → Green
        if red_mask[y, x] > 0:
            result[y, x] = [0, 255, 0]

        # Green → Orange
        if green_mask[y, x] > 0:
            result[y, x] = [0, 165, 255]

cv2.imshow("Original", image)
cv2.imshow("Result", result)

cv2.waitKey(0)
cv2.destroyAllWindows()
```


= Task 3: Shape Detection & Counting

*Goal:* Detect every shape on the sheet of paper, classify each one as a triangle, square, rectangle, or circle, label it on the image, and print a total count per shape.

#note[
 
   *This image contains:*
  - 4 squares
  - 4 circles
  - 4 triangles
  - 3 rectangles

  Any other shape is considered noise.
]

== Guidance & Architecture
- *Preprocessing:* Convert to grayscale, blur to reduce noise, then run `Canny` edge detection - reused here as a precursor to contour detection.
- *Contours:* `cv2.findContours()` on the edge map returns the outline of every detected shape.
- *Noise filtering:* Skip any contour with a small `cv2.contourArea()` — these are stray edges/artifacts, not real shapes.
- *Polygon approximation:* `cv2.approxPolyDP()` simplifies each contour into a polygon; the number of resulting vertices tells us the shape family:
  - `3` vertices → *Triangle*
  - `4` vertices → *Square* or *Rectangle*, disambiguated by checking the bounding box's aspect ratio (close to `1.0` → Square, otherwise → Rectangle)
  - anything else → *Circle*
- *Centroid & labeling:* `cv2.moments()` gives the contour's centroid `(cx, cy)`, used to place the shape's name as text at its center.
- *Counting:* A `counts` dictionary tallies how many of each shape were found.

== Input Image

#align(center)[
  #image("assets/Shapes.jpg", width: 40%)
]
