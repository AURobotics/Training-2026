#import "/Theme/report.typ": (
  brand-palette, cover-page, emphasis, pause-page-counting, report-template, resume-page-counting, watermark_text,
)

#import "@preview/calloutly:1.1.0": caution, important, note, tip
#import "/Theme/common.typ": setup-codly

#show: setup-codly

#cover-page(title: [Training '26], subtitle: [Software | Phase II], topic: "ROS2 workshop 1")

#show: report-template.with(ribbon-text: "ROS2 workshop 1")

= Introduction to ROS 2 Topics

Before we dive into the tasks, let's review the fundamental concepts you will be using today. You already know that ROS 2 nodes communicate using *Topics*. Here is a quick refresher on the components we will use:

- *Publishers:* Send data (messages) to a topic.
- *Subscribers:* Listen for data on a topic and trigger a callback function when new data arrives.
- *Messages:* The standard data structures used. Today we will use `Twist` (from `geometry_msgs.msg`) to send velocity commands, and `Pose` (from `turtlesim.msg`) to read the robot's current position and orientation.
- *Timers:* Used to execute a function repeatedly at a specific frequency.

= What are we going to do

we are going to run a built in robot called *turtlesim* then control its movement

#caution()[
  for each of the following tasks you will need to run turtlesim in another terminal beside your code\
  command: `ros2 run turtlesim turtlesim_node`
]

= Task 1: Basic Turtle Controller

*Goal:* Write a node that continuously drives the turtle in a circle while logging its live coordinates to the terminal.

== How it works
For this task, you will create a custom node called `TurtleController`[cite: 1]. This node requires three main mechanisms:
- A publisher that sends linear and angular velocity instructions to the `/turtle1/cmd_vel` topic[cite: 1]. 
- A subscriber that receives continuous pose updates from the `/turtle1/pose` topic[cite: 1].
- A timer that publishes velocity commands at 2 Hz, which equates to every 0.5 seconds[cite: 1].

When running this task, the node will log live telemetry coordinates representing the turtle's X, Y, and Theta values[cite: 1]. Simultaneously, it drives the turtle forward at a linear speed of 2.0 m/s and turns it counter-clockwise at an angular speed of 1.0 rad/s[cite: 1].

== Code Imports

```python
import rclpy
from rclpy.node import Node
from geometry_msgs.msg import Twist
from turtlesim.msg import Pose
```

---

= Task 2: Go-To-Goal Proportional Controller

*Goal:* Write an advanced node that actively navigates the turtle to a specific target coordinate on the screen using proportional control feedback.

== How it works
This task uses a closed-loop control system inside a node called `GoToGoalNode`. The node targets a specific coordinate on the grid (Constant), e.g. X: 10.0 and Y: 10.0. It calculates the errors between its current position and the target, and scales its velocity based on proportional gains.

Here is the breakdown of the logic:

- *Control Loop Frequency:* The control loop timer runs at 20 Hz, updating every 0.05 seconds.


- *Distance Error:* It calculates the Euclidean distance error to the target. Once this distance error is less than the tolerance of 0.1, the node considers the goal successfully reached and stops moving.


- *Heading Error:* It calculates a desired heading angle using Cartesian errors, and normalizes the angle between $-\pi$ and $\pi$ to avoid unnecessary 360-degree turns.


- *Proportional Control:* If the heading error exceeds the angle tolerance of 0.05, the turtle will rotate to align itself first. Otherwise, it will scale both its forward speed and heading alignment concurrently, capping the forward speed at a maximum of 2.0 m/s.



== Code Imports

```python
import math
import rclpy
from rclpy.node import Node
from geometry_msgs.msg import Twist
from turtlesim.msg import Pose
```
