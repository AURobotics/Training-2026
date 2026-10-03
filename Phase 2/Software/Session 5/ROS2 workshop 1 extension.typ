#import "/Theme/report.typ": (
  brand-palette, cover-page, emphasis, pause-page-counting, report-template, resume-page-counting, watermark_text,
)

#import "@preview/calloutly:1.1.0": caution, important, note, tip
#import "/Theme/common.typ": setup-codly

#show: setup-codly

#cover-page(title: [Training '26], subtitle: [Software | Phase II], topic: "ROS2 Workshop 1 Extension")

#show: report-template.with(ribbon-text: "ROS2 Workshop 1 Extension")

= Introduction to ROS 2 Topics

Before we dive into the tasks, let's review the fundamental concepts you will be using today. You already know that ROS 2 nodes communicate using *Topics*. Here is a quick refresher on the components we will use:

- *Publishers:* Send data (messages) to a topic.
- *Subscribers:* Listen for data on a topic and trigger a callback function when new data arrives.
- *Messages:* The standard data structures used. Today we will use `Twist` (from `geometry_msgs.msg`) to send velocity commands, and `Pose` (from `turtlesim.msg`) to read the robot's current position and orientation.
- *Timers:* Used to execute a function repeatedly at a specific frequency.

---

= Task 1: Basic Turtle Controller

*Goal:* Write a node that continuously drives the turtle in a circle while logging its live coordinates to the terminal.

== Guidance & Architecture
For this task, you need to create a custom node called `TurtleController`. 
- *Publisher:* Send `Twist` velocity commands to `/turtle1/cmd_vel`.
- *Subscriber:* Listen to `Pose` messages on `/turtle1/pose` and log the `x`, `y`, and `theta` values.
- *Timer:* Call a velocity publishing function at 2 Hz (every 0.5 seconds).

== Pseudocode Guidance


```pascal

CLASS TurtleController INHERITS Node:
  FUNCTION init():
    Initialize node named 'turtle_controller_node'
    Create publisher for Twist messages on '/turtle1/cmd_vel'
    Create subscriber for Pose messages on '/turtle1/pose' calling pose_callback
    Create timer running at 2 Hz calling publish_velocity

  FUNCTION pose_callback(msg):
      Log turtle telemetry: X, Y, Theta from msg
  
  FUNCTION publish_velocity():
      Create Twist message
      Set linear velocity (X = 2.0 m/s)
      Set angular velocity (Z = 1.0 rad/s)
      Publish Twist message


FUNCTION main():
  Initialize rclpy
  Instantiate TurtleController node
  Spin node
  Clean up and shutdown rclpy

```

---

= Task 2: Go-To-Goal Proportional Controller

*Goal:* Write an advanced node that actively navigates the turtle to a specific target coordinate on the screen using proportional control feedback.

== Guidance & Architecture
In this task, you will implement a closed-loop controller inside a node called `GoToGoalNode` to reach target coordinate `(10.0, 10.0)`:
- *Control Frequency:* Run the main control timer loop at 20 Hz (every 0.05 seconds).
- *Distance Error:* Calculate Euclidean distance `sqrt`$(x^2 + y^2)$. Stop if error $< 0.1$.
- *Heading Error:* Calculate desired angle using `atan2`$(y, x)$ and normalize heading error to be ranged from $[-pi, pi]$ instead of being $< -pi$ or $> pi$.
- *Proportional Logic:* If heading error $> 0.05$ rad, turn in place ($v_x = 0$). Otherwise, drive forward with proportional linear speed (capped at 2.0 m/s) while correcting heading.

== Pseudocode Guidance

```pascal

DEFINE TARGET_X = 10.0, TARGET_Y = 10.0

CLASS GoToGoalNode INHERITS Node:
  FUNCTION **init**():
    Initialize node named 'go_to_goal_node'
    Set proportional gains (kp_linear = 1.5, kp_angular = 6.0)
    Set tolerances (distance_tolerance = 0.1, angle_tolerance = 0.05)
    Create publisher for Twist on '/turtle1/cmd_vel'
    Create subscriber for Pose on '/turtle1/pose' calling pose_callback
    Create control loop timer at 20 Hz calling control_loop

  FUNCTION pose_callback(msg):
      Update current_pose with msg data
  
  FUNCTION normalize_angle(angle):
      Keep angle wrapped within [-pi, pi]
      RETURN normalized angle
  
  FUNCTION control_loop():
      IF current_pose is None OR goal_reached THEN RETURN
  
      // 1. Calculate errors
      dx = TARGET_X - current_pose.x
      dy = TARGET_Y - current_pose.y
      distance_error = sqrt(dx^2 + dy^2)
      
      target_angle = atan2(dy, dx)
      heading_error = normalize_angle(target_angle - current_pose.theta)
  
      // 2. Check completion
      IF distance_error < distance_tolerance THEN:
          Publish zero velocity
          Set goal_reached = True
          RETURN
  
      // 3. Control logic
      IF abs(heading_error) > angle_tolerance THEN:
          // Align orientation first
          linear_x = 0.0
          angular_z = kp_angular * heading_error
      ELSE:
          // Move forward and adjust heading concurrently
          linear_x = min(kp_linear * distance_error, 2.0)
          angular_z = kp_angular * heading_error
  
      Publish velocity command with (linear_x, angular_z)
    

FUNCTION main():
  Initialize rclpy
  Instantiate GoToGoalNode
  Spin node
  Clean up and shutdown rclpy

```
