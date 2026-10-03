#import "/Theme/report.typ": (
  brand-palette, cover-page, emphasis, pause-page-counting, report-template, resume-page-counting, watermark_text,
)

#import "@preview/calloutly:1.1.0": caution, important, note, tip
#import "/Theme/common.typ": setup-codly

#show: setup-codly

#cover-page(title: [Training '26], subtitle: [Software | Phase III], topic: "Task 4: Radar Speed Detector")

#show: report-template.with(ribbon-text: " Task 4")

= Introduction

In this task you'll build a *radar speed detector* for vehicles. You will *train your own YOLO model* to find the vehicles, use *ByteTrack* to follow each vehicle so it keeps the same ID from frame to frame, and then calculate the speed from *distance ÷ time* using two virtual lines drawn on the road. You will write the whole task using *Object-Oriented Programming (OOP)*.

= Task — Car Speed Detection

*Goal:* Train a YOLO model on a vehicle dataset, then use it on a road video to *measure the speed of every vehicle in km/h* and display it on the frame next to the vehicle.

#important(title: "Video you will work on")[
  Use this video for your task:

  #align(center)[
    #link("https://drive.google.com/file/d/1mQeoSUyEl6FRhqK_ewITG2tKGPZ7BO6R/view?usp=drive_link")[*▶ Watch the Video you will work on*]
  ]
]

*Requirements:*
+ *Get a dataset* — either a dataset you *made yourself* (record or collect road images and label them) or an *existing dataset* from Kaggle, Roboflow Universe, etc.
+ *Train a YOLO model* on that dataset and check its results (mAP, Precision, Recall).
+ *Track* the detected vehicles with *ByteTrack* so each vehicle has a stable ID.
+ Draw *two horizontal lines* (A and B) on the frame. The real-world distance between them is known: *9.144 m*.
+ Measure the *time* each vehicle takes to travel from line A to line B, then convert it to *km/h*.
+ Show the speed on the video next to the vehicle's box.
+ *Write the code using OOP* — organize it in classes (see the *Code Structure (OOP)* section below).

#tip(title: "Choosing a dataset")[
  Search Roboflow Universe or Kaggle for "vehicle detection". Pick a dataset whose images look like your video (camera angle, lighting, road type) and whose classes include the vehicles you need (car, bus, truck...).
]

== Object Tracking with ByteTrack

After training, load your `best.pt` and run it on every frame with the *track* function:

```python
results = model.track(frame, 
  persist=True, 
  tracker="bytetrack.yaml", 
  conf=conf
)
```

*Why tracking and not `predict`?* `predict` only detects: it treats each frame alone, so it can't tell you that the car in this frame is the same car as in the previous one. To measure the time between line A and line B you must follow *the same car*, so we use `track`, which gives every vehicle an *ID*.

*What does `track` do?* It runs the detector, then ByteTrack matches the new boxes with the previous ones, so each vehicle keeps the same ID from frame to frame.

#caution(title: "Don't forget persist=True")[
  `persist=True` keeps the tracker's memory between frames. Without it the IDs reset every frame, and you can't follow the same car.
]

*What does it return?* A list of `Results`, one per frame, so use `results[0].boxes`:
- `boxes.xyxy` — box corners `[x1, y1, x2, y2]` in pixels.
- `boxes.id` — the *track ID* of each box.
- `boxes.conf` and `boxes.cls` — confidence and class of each box.

#caution(title: "boxes.id can be None")[
  `boxes.id` is `None` when nothing is tracked yet. Always check it first, or your code will crash on those frames.
]

```python
boxes = results[0].boxes

if boxes.id is not None:
    for (x1, y1, x2, y2), track_id in zip(boxes.xyxy.int().tolist(), boxes.id.int().tolist()):
        cx, cy = (x1 + x2) // 2, (y1 + y2) // 2   # center point of the vehicle
```

#tip(title: "Tracker docs")[
  For more information about ByteTrack: #link("https://academy.ultralytics.com/courses/yolo-in-production/tracking-with-bytetrack-and-botsort")[*Docs*]
]


== The two lines


#align(center)[
  #image("assets/RoadLines.png", width: 40%)
]

Use these constants. The lines are in *pixel coordinates of your video frame* (adjust them to your own video).

```python
DISTANCE_M = 9.144   # real distance between line A and line B (meters)

# Lines are in real pixel coordinates of YOUR video frame (adjust them to your video)
# line A
ax1 = 70
ay = 90
ax2 = 230
# line B
bx1 = 15
by = 125
bx2 = 225
```

#table(
  columns: (auto, auto, auto),
  align: center,
  [*Line*], [*x range (pixels)*], [*y (pixels)*],
  [A], [70 → 230], [90],
  [B], [15 → 225], [125],
)

```text
 y = 90   ---------- line A ----------      (start the timer)
               |
               |   car drives through
               v
 y = 125  ---------- line B ----------      (stop the timer)

 real distance between A and B = 9.144 m
```

== How to get the time (step by step)

The time is *not* measured with a clock — it comes from the video itself: *frame number ÷ FPS*.

+ *Track the car.* ByteTrack gives every car an ID, so you can follow "car 3" across frames.
+ *Get the car's center point* $(c_x, c_y)$ from its bounding box every frame, and remember its $c_y$ from the previous frame.
+ *Detect the crossing of line A.* The car crossed a line when its center was on one side of the line in the previous frame and is on the other side in the current frame (and $c_x$ is inside the line's x range). At that moment, save the *frame number* as `cross_a[id]`.
+ *Detect the crossing of line B* the same way and save `cross_b[id]`.
+ *Compute the time:* `t = (cross_b - cross_a) / FPS` seconds.
+ *Compute the speed:* `DISTANCE_M / t * 3.6` km/h, and keep it for that car so it's calculated only once.

#important(title: "Why frames / FPS and not time.time()")[
  `time.time()` measures how long *your computer* took to process the frames, which changes with your CPU/GPU. The video's own timeline is always correct: at 30 FPS, 15 frames are exactly 0.5 s no matter how slow the code runs. Get FPS with `cap.get(cv2.CAP_PROP_FPS)`.
]

#note(title: "Line crossing check")[
  Check the crossing with "previous side vs current side" instead of `cy == line_y`, because a fast car can jump over the line between two frames and never land exactly on it.
]

#note(title: "Dictionaries in OOP")[
  `cross_a[id]` and `cross_b[id]` are written as dictionaries here to explain the idea. In your OOP solution, store them as *attributes* inside each vehicle object (for example `self.time_a` and `self.time_b`).
]

== Code Structure (OOP)

#important(title: "Required: use OOP")[
  Write this task using *Object-Oriented Programming*. Do not put everything in one long script. Split the work into *classes*, where each class has *one job*, and use *attributes* and *methods* instead of loose global variables.
]

Suggested classes (you can design your own, but you must use classes):

#table(
  columns: (auto, 1fr),
  align: (center, left),
  [*Class*], [*Job*],
  [`SpeedLine`], [Holds one line (`x1`, `x2`, `y`) and checks if a car crossed it.],
  [`Vehicle`], [Stores one car: its ID, its previous `cy`, its crossing times and its speed.],
  [`SpeedDetector`], [Loads the model, reads the video, runs `track`, updates every `Vehicle`, and draws the result.],
)

A possible skeleton:

```python
class SpeedLine:
    def __init__(self, x1, x2, y):
        ...

    def is_crossed(self, cx, prev_y, cur_y):
        """True if the car crossed this line between the two frames."""
        ...


class Vehicle:
    def __init__(self, track_id):
        ...

    def update(self, cx, cy, now, line_a, line_b):
        """Check both lines and save the crossing times."""
        ...

    def get_speed(self):
        """Return the speed in km/h (or None if not measured yet)."""
        ...


class SpeedDetector:
    def __init__(self, model_path, video_path):
        ...

    def run(self):
        """Read the video frame by frame and measure the speeds."""
        ...
```

#tip(title: "Build it step by step")[
  Start with `SpeedLine` and test it alone with a few numbers. Then build `Vehicle`, and finish with `SpeedDetector`. Testing small pieces first makes bugs much easier to find.
]

== Expected Result (Demo)

#note(title: "Demo video")[
  Watch this demo to see what your final result should look like: every vehicle has a box, an ID, and its speed in km/h.

  #align(center)[
    #link("https://drive.google.com/file/d/1KyLPyJKI_ipoCL9WFAQJiF6i0vfxaR9U/view?usp=sharing")[*▶ Watch the Demo Video*]
  ]
]

= Submission

- In your *GitHub repository* Make a folder for *Phase 3* and inside it a folder for *Task 4* then push your main code and notebook of training *inside it the metrics of the model(mAP, Precision, Recall) * #text(fill: red)[*Do not push the video of the task or any video*]

- For good practise #text(fill: red)[Do not push *Model file* and *dataset*] instead put them in *GitHub Releases* in your Repo #link("https://drive.google.com/file/d/1mQeoSUyEl6FRhqK_ewITG2tKGPZ7BO6R/view?usp=drive_link")[*▶ Watch the Video to know how to make a GitHub Release*]

- Record a short video *explaining the code you wrote* for the task — walk through your approach, key parameters/choices, and a demo of the output.

- Upload the video to *Google Drive* or *YouTube* and get a shareable link.

- Submit via the form: include the *GitHub repo link* and the *video link*.: #link("https://forms.gle/ayvhqKrdRwgN93hD8")[Form for submission]

#note[
  Make sure the repo is public and the video link permissions are set to "anyone with the link can view."
]

#emphasis("Deadline: Saturday, September 26th -- 11:59 pm")
