#import "/Theme/report.typ": (
  brand-palette, cover-page, emphasis, pause-page-counting, report-template, resume-page-counting, watermark_text,
)

#import "@preview/calloutly:1.1.0": caution, important, note, tip
#import "/Theme/common.typ": setup-codly

#show: setup-codly

#cover-page(title: [Training '26], subtitle: [Software | Phase II], topic: "ROS2 workshop 1")

#show: report-template.with(ribbon-text: "ROS2 workshop 1", foreground_watermark: watermark_text(content: "INTERNAL USE ONLY", gaps: 3.5pt, opacity: 50))

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

== Code Implementation

```python
import rclpy
from rclpy.node import Node
from geometry_msgs.msg import Twist
from turtlesim.msg import Pose

class TurtleController(Node):
    def __init__(self):
        super().__init__('turtle_controller_node')
        
        # Publisher: Sends linear and angular velocity to move the turtle
        self.cmd_vel_pub = self.create_publisher(Twist, '/turtle1/cmd_vel', 10)
        
        # Subscriber: Receives continuous pose updates from turtlesim
        self.pose_sub = self.create_subscription(
            Pose, '/turtle1/pose', self.pose_callback, 10)
        
        # Timer: Publishes velocity commands at 2 Hz (every 0.5 sec)
        self.timer = self.create_timer(0.5, self.publish_velocity)

    def pose_callback(self, msg: Pose):
        # Log live telemetry coordinates received from turtlesim
        self.get_logger().info(f'Turtle Pose -> X: {msg.x:.2f}, Y: {msg.y:.2f}, Theta: {msg.theta:.2f}')

    def publish_velocity(self):
        msg = Twist()
        msg.linear.x = 2.0   # Drive forward at 2.0 m/s
        msg.angular.z = 1.0  # Turn counter-clockwise at 1.0 rad/s
        self.cmd_vel_pub.publish(msg)

def main(args=None):
    rclpy.init(args=args)
    node = TurtleController()
    rclpy.spin(node)
    node.destroy_node()
    rclpy.shutdown()

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



== Code Implementation

```python
import math
import rclpy
from rclpy.node import Node
from geometry_msgs.msg import Twist
from turtlesim.msg import Pose

TARGET_X = 10.0  # Target X coordinate for the turtle to reach
TARGET_Y = 10.0  # Target Y coordinate for the turtle to reach

class GoToGoalNode(Node):
    def __init__(self):
        super().__init__('go_to_goal_node')

        # Target Goal Coordinates
        self.goal_x = TARGET_X
        self.goal_y = TARGET_Y

        # Proportional Gains (K_p)
        self.kp_linear = 1.5
        self.kp_angular = 6.0

        # Tolerances
        self.distance_tolerance = 0.1  # Distance error limit to consider goal reached
        self.angle_tolerance = 0.05    # Heading alignment threshold before moving forward

        # State Variables
        self.current_pose = None
        self.goal_reached = False

        # ROS 2 Publisher & Subscriber
        self.cmd_vel_publisher = self.create_publisher(Twist, '/turtle1/cmd_vel', 10)
        self.pose_subscriber = self.create_subscription(
            Pose, '/turtle1/pose', self.pose_callback, 10
        )

        # Control Loop running at 20 Hz
        self.timer = self.create_timer(0.05, self.control_loop)

        self.get_logger().info(f'Navigating turtle to target goal: ({self.goal_x}, {self.goal_y})')

    def pose_callback(self, msg: Pose):
        """Update current position and heading from /turtle1/pose stream."""
        self.current_pose = msg

    def normalize_angle(self, angle: float) -> float:
        """Keep heading angle within [-pi, pi] to avoid unnecessary 360-degree turns."""
        while angle > math.pi:
            angle -= 2.0 * math.pi
        while angle < -math.pi:
            angle += 2.0 * math.pi
        return angle

    def control_loop(self):
        """Proportional Control Loop."""
        if self.current_pose is None or self.goal_reached:
            return

        # 1. Calculate Cartesian Errors
        dx = self.goal_x - self.current_pose.x
        dy = self.goal_y - self.current_pose.y

        # Euclidean Distance Error: sqrt((x_g - x)^2 + (y_g - y)^2)
        distance_error = math.sqrt(dx**2 + dy**2)

        # Desired Heading Angle: atan2(dy, dx)
        target_angle = math.atan2(dy, dx)
        heading_error = self.normalize_angle(target_angle - self.current_pose.theta)

        msg = Twist()

        # 2. Check if Goal is Reached
        if distance_error < self.distance_tolerance:
            msg.linear.x = 0.0
            msg.angular.z = 0.0
            self.cmd_vel_publisher.publish(msg)
            self.goal_reached = True
            self.get_logger().info('Goal Reached Successfully!')
            return

        # 3. Proportional Control Logic
        # If heading error is large, align facing direction first before moving forward
        if abs(heading_error) > self.angle_tolerance:
            msg.linear.x = 0.0
            msg.angular.z = self.kp_angular * heading_error
        else:
            # Scale forward speed and heading alignment concurrently
            msg.linear.x = min(self.kp_linear * distance_error, 2.0)  # Cap speed at 2.0 m/s
            msg.angular.z = self.kp_angular * heading_error

        self.cmd_vel_publisher.publish(msg)

def main(args=None):
    rclpy.init(args=args)
    node = GoToGoalNode()
    rclpy.spin(node)
    node.destroy_node()
    rclpy.shutdown()

```
