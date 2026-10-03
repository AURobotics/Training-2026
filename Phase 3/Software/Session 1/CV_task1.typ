#import "/Theme/report.typ": (
  brand-palette, cover-page, emphasis, pause-page-counting, report-template, resume-page-counting, watermark_text,
)

#import "@preview/calloutly:1.1.0": caution, important, note, tip
#import "/Theme/common.typ": setup-codly

#show: setup-codly

#cover-page(title: [Training '26], subtitle: [Software | Phase III], topic: "Task 1: Computer Vision")

#show: report-template.with(ribbon-text: " Task 1")

= Introduction

In this task you'll work with noisy images and video to practice denoising, edge detection, and shape detection/counting.

= Subtask 1 — Denoising & Face Edge Detection

*Goal:* Search for a noisy face image and denoise it using three different filters — *Average*, *Median*, and *Gaussian* blur. Run *Canny* edge detection on each denoised result, and tune the blur and Canny parameters until the detected edges trace the facial features as accurately as possible. Display the original image, all three denoised versions, and their corresponding edge maps together in a *single* window using *matplotlib*.

#tip[
  `plt.subplot()` (or `plt.subplots()`) lets you arrange multiple images in a grid within one figure window.
]

== Solution

Denoises a noisy face image three ways (Average / Median / Gaussian blur), runs Canny edge detection on each, and displays the original plus all six results in one `matplotlib` figure.

```python
"""
Phase 3 - Task 1 - Subtask 1
Denoising & Face Edge Detection
"""

import cv2
import matplotlib.pyplot as plt

img = cv2.imread("noisy_face.jpg")
gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

# three denoising filters
avg = cv2.blur(gray, (5, 5))
med = cv2.medianBlur(gray, 5)
gau = cv2.GaussianBlur(gray, (5, 5), 0)

# Canny edges on each
edges_avg = cv2.Canny(avg, 50, 150)
edges_med = cv2.Canny(med, 50, 150)
edges_gau = cv2.Canny(gau, 50, 150)

titles = ["Original", "Average Blur", "Median Blur", "Gaussian Blur",
          "", "Average Edges", "Median Edges", "Gaussian Edges"]
images = [cv2.cvtColor(img, cv2.COLOR_BGR2RGB), avg, med, gau,
          None, edges_avg, edges_med, edges_gau]

plt.figure(figsize=(14, 7))
for i, (title, image) in enumerate(zip(titles, images), start=1):
    plt.subplot(2, 4, i)
    if image is not None:
        plt.imshow(image, cmap=None if image.ndim == 3 else "gray")
    plt.title(title)
    plt.axis("off")

plt.tight_layout()
plt.show()
```

= Subtask 2 — Detecting & Labeling Red Circles and Blue Squares in Video

*Goal:* Process the given video and detect every *red circle* and every *blue square* that appears. For each detected shape, draw its *contour* (using `cv2.drawContours()`) around the shape, and label it directly on the frame using `cv2.putText()` — draw the text (e.g. `"Red Circle"` / `"Blue Square"`) right on or next to the outlined object, so every detected shape is visually outlined and tagged in place.


*Video*:https://drive.google.com/file/d/1ls42KCLiYHgkXDZ8w870vVMWxcnM3DPJ/view?usp=sharing

#note[
  Hey, just flagging — the video for Subtask 2 has noise in it, which makes clean shape detection (red circles / blue squares) harder without extra preprocessing.
]

#important(title: "OOP Requirement")[
  For Subtask 2 must be implemented using *Object-Oriented Programming* — no standalone functions/scripts. All the processing logic (reading the video, detecting the shapes, drawing the counter) should live inside a *single class*, with a `main` section outside the class used only to instantiate it and run it.
]

== Solution — base version (detect & label)

Single class `ShapeDetector`: masks red and blue regions in HSV, uses `cv2.approxPolyDP` to tell circles from squares by vertex count, then outlines and labels each match.

```python
"""
Phase 3 - Task 1 - Subtask 2 (base version)
Detecting & Labeling Red Circles and Blue Squares in Video
"""

import cv2


class ShapeDetector:
    def __init__(self, video_path):
        self.cap = cv2.VideoCapture(video_path)

    def get_mask(self, hsv, color):
        if color == "red":
            m1 = cv2.inRange(hsv, (0, 100, 80), (10, 255, 255))
            m2 = cv2.inRange(hsv, (170, 100, 80), (180, 255, 255))
            return cv2.bitwise_or(m1, m2)
        return cv2.inRange(hsv, (100, 100, 60), (130, 255, 255))

    def label_shapes(self, frame, mask, shape, color, text):
        contours, _ = cv2.findContours(mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
        for c in contours:
            if cv2.contourArea(c) < 400:
                continue
            approx = cv2.approxPolyDP(c, 0.04 * cv2.arcLength(c, True), True)
            is_circle = shape == "circle" and len(approx) > 6
            is_square = shape == "square" and len(approx) == 4
            if not (is_circle or is_square):
                continue
            cv2.drawContours(frame, [c], -1, color, 2)
            x, y, w, h = cv2.boundingRect(c)
            cv2.putText(frame, text, (x, y - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.6, color, 2)

    def run(self):
        while True:
            ok, frame = self.cap.read()
            if not ok:
                break

            blurred = cv2.medianBlur(frame, 5)
            hsv = cv2.cvtColor(blurred, cv2.COLOR_BGR2HSV)

            self.label_shapes(frame, self.get_mask(hsv, "red"), "circle", (0, 0, 255), "Red Circle")
            self.label_shapes(frame, self.get_mask(hsv, "blue"), "square", (255, 0, 0), "Blue Square")

            cv2.imshow("Detection", frame)
            if cv2.waitKey(20) & 0xFF == ord("q"):
                break

        self.cap.release()
        cv2.destroyAllWindows()


if __name__ == "__main__":
    ShapeDetector("shapes_video.mp4").run()
```

== Solution — bonus version (count via tracking)

Single class `ShapeCounter`: same detection as the base version, plus a simple nearest-centroid tracker so each shape is only counted once even while it moves across frames.

```python
"""
Phase 3 - Task 1 - Subtask 2 (bonus version)
Counting Red Circles and Blue Squares via Tracking
"""

import cv2
import numpy as np


class ShapeCounter:
    def __init__(self, video_path):
        self.cap = cv2.VideoCapture(video_path)
        self.tracks = {"circle": [], "square": []}   # each track: [x, y, missed_frames]
        self.counts = {"circle": 0, "square": 0}

    def get_mask(self, hsv, color):
        if color == "red":
            m1 = cv2.inRange(hsv, (0, 100, 80), (10, 255, 255))
            m2 = cv2.inRange(hsv, (170, 100, 80), (180, 255, 255))
            return cv2.bitwise_or(m1, m2)
        return cv2.inRange(hsv, (100, 100, 60), (130, 255, 255))

    def find_shapes(self, mask, shape):
        found = []
        contours, _ = cv2.findContours(mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
        for c in contours:
            if cv2.contourArea(c) < 400:
                continue
            approx = cv2.approxPolyDP(c, 0.04 * cv2.arcLength(c, True), True)
            is_circle = shape == "circle" and len(approx) > 6
            is_square = shape == "square" and len(approx) == 4
            if not (is_circle or is_square):
                continue
            M = cv2.moments(c)
            if M["m00"] == 0:
                continue
            found.append((M["m10"] / M["m00"], M["m01"] / M["m00"], c))
        return found

    def update_tracks(self, shape, detections):
        tracks = self.tracks[shape]
        matched = set()

        # try to match each existing track to the closest new detection
        for track in tracks:
            best_i, best_dist = None, 50  # px, matching distance threshold
            for i, (cx, cy, _) in enumerate(detections):
                if i in matched:
                    continue
                dist = np.hypot(track[0] - cx, track[1] - cy)
                if dist < best_dist:
                    best_i, best_dist = i, dist
            if best_i is not None:
                track[0], track[1], track[2] = detections[best_i][0], detections[best_i][1], 0
                matched.add(best_i)
            else:
                track[2] += 1

        # drop tracks that vanished for too long
        self.tracks[shape] = [t for t in tracks if t[2] < 15]

        # unmatched detections are brand-new shapes
        for i, (cx, cy, _) in enumerate(detections):
            if i not in matched:
                self.tracks[shape].append([cx, cy, 0])
                self.counts[shape] += 1

    def run(self):
        while True:
            ok, frame = self.cap.read()
            if not ok:
                break

            blurred = cv2.medianBlur(frame, 5)
            hsv = cv2.cvtColor(blurred, cv2.COLOR_BGR2HSV)

            red = self.find_shapes(self.get_mask(hsv, "red"), "circle")
            blue = self.find_shapes(self.get_mask(hsv, "blue"), "square")

            self.update_tracks("circle", red)
            self.update_tracks("square", blue)

            for _, _, c in red:
                cv2.drawContours(frame, [c], -1, (0, 0, 255), 2)
            for _, _, c in blue:
                cv2.drawContours(frame, [c], -1, (255, 0, 0), 2)

            cv2.putText(frame, f"Red Circles: {self.counts['circle']}", (10, 30),
                        cv2.FONT_HERSHEY_SIMPLEX, 0.7, (0, 0, 255), 2)
            cv2.putText(frame, f"Blue Squares: {self.counts['square']}", (10, 60),
                        cv2.FONT_HERSHEY_SIMPLEX, 0.7, (255, 0, 0), 2)

            cv2.imshow("Counting", frame)
            if cv2.waitKey(20) & 0xFF == ord("q"):
                break

        self.cap.release()
        cv2.destroyAllWindows()
        print(self.counts)


if __name__ == "__main__":
    ShapeCounter("shapes_video.mp4").run()
```


= Submission

- In your *GitHub repository* Make a folder for *Phase 3* and inside it a folder for *Task 1* then push your code and images you search #text(fill: red)[*Do not push the video of subtask 2*]

- Record a short video *explaining the code you wrote* for both subtasks — walk through your approach, key parameters/choices, and a demo of the output.

- Upload the video to *Google Drive* or *YouTube* and get a shareable link.

- Submit via the form: include the *GitHub repo link* and the *video link*.: https://forms.gle/AZA7jWvTavH64eQ78

#note[
  Make sure the repo is public and the video link permissions are set to "anyone with the link can view."
]

#emphasis("Deadline: Wednesday, September 16th -- 11:59 pm")
