#import "/Theme/report.typ": (
  brand-palette, cover-page, emphasis, pause-page-counting, report-template, resume-page-counting, watermark_text,
)

#import "@preview/calloutly:1.1.0": caution, important, note, tip
#import "/Theme/common.typ": setup-codly

#show: setup-codly

#cover-page(title: [Training '26], subtitle: [Software | Phase II], topic: "ROS2 workshop 1")

#show: report-template.with(ribbon-text: "ROS2 workshop 1", background_watermark: watermark_text(content: "INTERNAL USE ONLY", gaps: 3.3pt, opacity: 50))

= Revision

Before we dive into the tasks, let's review the fundamental concepts you will be using today. You already know that ROS 2 nodes communicate using *Topics*, *Services*, and *Actions*, and you are familiar with *Parameter Files* and *Launch Files*. Here is a quick refresher on the components we will use:

- *Service Communication*:
  - *Service Client*: Sends a *Request* to a service server and waits for a *Response*.
  - *Service Server*: Receives the request, performs quick synchronous processing, and returns a response.
- *Action Communication*:
  - *Action Client*: Sends a *Goal* to an action server; optionally subscribes to periodic *Feedback*, receives a final *Result*, and can cancel the goal at any time.
  - *Action Server*: Receives the goal, executes long-running or non-blocking tasks while publishing feedback, and returns a final result upon completion.
- *Parameter Files*: Used to configure node inputs externally (typically via YAML). They eliminate hardcoded values, simplifying testing across different operational scenarios.
- *Launch Files*: Execute and manage multiple nodes, parameter files, and system dependencies simultaneously through a single execution command.

#pagebreak()

= Task 1: Parameterize Last Workshop's Task

*Goal:* Convert your proportional control node from Workshop 1 (Task 2) to use a YAML parameter file instead of hardcoded values. The parameters to externalize are:
- *Target Coordinates:* `target_x`, `target_y`
- *Control Gains:* `linear_gain`, `angular_gain`
- *Tolerance:* `distance_tolerance`, `angle_tolerance`
- *Loop Rate:* `loop_rate_hz`

= Task 2: Services Toggle

*Goal:*
- Change the behavior of the last workshops code by making it a Service Server using `std_srvs/srv/SetBool`.\
-> When a client sends `data: True`, the node starts publishing data to make turtlsime move to the target coordinates.\
-> reponse with `success: True` if the request was accepted.\
- Create a Service Client that calls the service to start the turtle's movement after a time delay passes\

#tip()[
  A `SetBool` callback is expected to return quickly. Don't read serial data inside it — the executor will block and your node will appear frozen for the duration. Instead, have the callback only flip a boolean flag (e.g. `self.reading_active`), and do the actual serial reads in a separate mechanism: a fast `create_timer()` callback that checks the flag and reads one chunk each tick. Either is fine as long as the `SetBool` callback itself just toggles state and returns.
]

#caution(title: [Bonus], icon: [#sym.star])[
  Instead of having the service use the `SetBool` change the service type using a *custom service* type that has a request with the target coordinates - _x: float, y: float_. The server will then use the request to set the target coordinates and start moving the turtle to that location. The service response can be a boolean indicating if the request was accepted or not (e.g. if the coordinates are out of bounds).\
  #emphasis([Notice 1]): The servoce itself must not block for the duration of the turtle's movement to the target coordinates. It should return immediately after setting the target coordinates and starting the movement; it returns the if goal is accepted or not; not if the turle reached the distination or not.\
  This should have been implemented as an action, but it will be harder; details for action is given at the cancelled task at the end of this workshop.\
  #emphasis([Notice 2]): the x and y parameters in the parameter file will be ignored if you implement this bonus task.
]

```python

```

= Task 3: Launch File Integration

*Goal:* Write a Python launch file that executes `turtlesim_node`, service client that calls the service and your go to goal node (including loading its YAML parameter file) using a single command.

#pagebreak()

= Task 4: Serial Communication
*Goal:* Write a ROS 2 node that reads sensor data from a microcontroller (e.g. Arduino) over a serial port and logs the data.\

No Arduino on hand? Simulate one: write a tiny node that writes fake sensor lines to a virtual serial pair (`socat -d -d pty,raw,echo=0 pty,raw,echo=0` creates two linked `/dev/pts/N` devices), and point your node at one end. This keeps the task's logic identical without requiring hardware.\
#emphasis([Node Code:])
```python
"""
Writes fake sensor readings to a serial port once per second.

Use this with `socat` to simulate a microcontroller when no Arduino is
available:

    socat -d -d pty,raw,echo=0 pty,raw,echo=0

That prints two linked devices, e.g. /dev/pts/3 and /dev/pts/4. Run this
script pointed at one of them, and set serial_service_server's 'serial_port'
parameter to the other.

Usage:
    ros2 run workshop2 mock_sensor_source /dev/pts/3 9600
"""
import random
import sys
import time
import serial

def main():
    port = sys.argv[1] if len(sys.argv) > 1 else '/dev/pts/1'
    baud = int(sys.argv[2]) if len(sys.argv) > 2 else 9600

    conn = serial.Serial(port, baud, timeout=1.0)
    print(f'Writing fake sensor data to {port} at {baud} baud. Ctrl+C to stop.')
    try:
        while True:
            reading = round(random.uniform(20.0, 30.0), 2)
            line = f'TEMP:{reading}\n'
            conn.write(line.encode('utf-8'))
            time.sleep(1.0)
    except KeyboardInterrupt:
        pass
    finally:
        conn.close()
```

#pagebreak()

#let watermark-block(watermark-text: "CANCELLED", body) = {
  block(
    fill: rgb("fff5f5"),
    stroke: 1pt + rgb("feb2b2"),
    inset: 12pt,
    radius: 4pt,
    clip: true, // Prevents rotated text from spilling out of the block
    [
      // Background Watermark Layer
      #place(
        center + horizon,
        rotate(
          -25deg,
          text(
            size: 4em,
            weight: "bold",
            fill: rgb("e53e3e").lighten(75%),
            watermark-text,
          ),
        ),
      )
      // Content Layer
      #body
    ],
  )
}

#watermark-block(watermark-text: "For Reference", [
  = Cancelled Task: Waypoint Navigation (Action Interface)

  *Goal:* Write a ROS 2 Action Server and Client to navigate the turtle to a specific target coordinate $(x, y)$ on the screen.

  #tip()[
    You can reuse and adapt the proportional control logic written in Workshop 1 (Task 2) by encapsulating it inside an Action Server execution callback: publish `Feedback` where you used to just track state, and return a `Result` where the loop used to silently stop.
  ]

  #tip()[
    A custom `.action` file needs its own interface package, separate from the package containing your node code (e.g. `turtle_interfaces`). Build and source that package *before* the node package that imports it, or the import will fail.
  ]

  == How It Works
  - *Action Structure:* Define or use an action interface containing:
    - *Goal:* `float32 x`, `float32 y`
    - *Feedback:* `turtlesim/Pose current_pose`
    - *Result:* `bool success`
  - *Action Client:* Sends goal coordinates $(x, y)$ to the server and waits for execution feedback and final result.
  - *Action Server:* Accepts or rejects incoming goals, executes the proportional loop while periodically publishing the current turtle pose as feedback, and returns `success = True` once within distance tolerance.

  == Goal Validation
  Don't accept every goal blindly — reject and log a warning for any $(x, y)$ outside turtlesim's drawable window (approximately `0.0` to `11.0` on both axes). Use the goal request callback (`goal_callback`) to do this rejection *before* execution begins, not inside the execute callback.
])

#watermark-block(watermark-text: "For Reference", [
  #caution[
    You will have a concurrency problem; we did not cover concurrency yet; hence, this task is cancelled but left for reference.\
    #emphasis("Explanation of the Concurrency Problem:")\

    You will need two callbacks: one for the execution of the goal and one that subscribes to the turtle's pose topic.\
    If no handeled concurrency is implemented, the execution callback will block the subscription callback from being called; hence, you will never be able to receive the pose updates and the turtle will never move.\

    #emphasis("How to handle the concurency:")\

    You have two options:\
    + Use a multi-threaded executor to allow the subscription callback to be called while the execution callback is running.\
    + use `async` and `await` to handle the asynchronous nature of the execution callback.\

    you are not required to implement this task, but you can try it if you want to challenge yourself. The solution will be provided in the repo. Knowledge learnt from learning this task will be rewarding if you want to give it a try.
  ]
])


#pagebreak()
= Task 1,2,3 solution
#tip(title:[hint])[
Notice that go_to_goal.py does not include the service addition after task 1, services was added after task 2]

```python
# go_to_goal.py
import math
import rclpy
from rclpy.node import Node
from geometry_msgs.msg import Twist
from turtlesim.msg import Pose
from std_srvs.srv import SetBool


class GoToGoal(Node):
    def __init__(self):
        super().__init__('go_to_goal')

        # Declare ROS 2 parameters with default values
        # (used if no YAML file or override is supplied at launch)
        self.declare_parameter('target_x', 10.0)
        self.declare_parameter('target_y', 10.0)
        self.declare_parameter('linear_gain', 1.5)
        self.declare_parameter('angular_gain', 6.0)
        self.declare_parameter('distance_tolerance', 0.1)
        self.declare_parameter('angle_tolerance', 0.05)
        self.declare_parameter('loop_rate_hz', 20.0)

        # Target Goal Coordinates
        self.goal_x = self.get_parameter('target_x').value
        self.goal_y = self.get_parameter('target_y').value

        # Proportional Gains (K_p)
        self.kp_linear = self.get_parameter('linear_gain').value
        self.kp_angular = self.get_parameter('angular_gain').value

        # Tolerances
        self.distance_tolerance = self.get_parameter('distance_tolerance').value
        self.angle_tolerance = self.get_parameter('angle_tolerance').value

        # Loop Rate
        self.loop_rate_hz = self.get_parameter('loop_rate_hz').value

        # State Variables
        self.current_pose = None
        self.goal_reached = False

        # Movement is now gated behind a service call instead of starting
        # automatically. The control loop only publishes cmd_vel once this
        # flag is set to True.
        self.movement_active = False

        # ROS 2 Publisher & Subscriber
        self.cmd_vel_publisher = self.create_publisher(Twist, '/turtle1/cmd_vel', 10)
        self.pose_subscriber = self.create_subscription(
            Pose, '/turtle1/pose', self.pose_callback, 10
        )

        # SetBool Service Server: a client calling this with data=True
        # arms the node to start driving the turtle toward the goal.
        # The callback ONLY flips a flag and returns immediately - the
        # actual work happens in the timer-driven control_loop below.
        self.start_service = self.create_service(
            SetBool, 'start_movement', self.start_movement_callback
        )

        # Control Loop running at the configured rate
        self.timer = self.create_timer(1.0 / self.loop_rate_hz, self.control_loop)

        self.get_logger().info(
            f'go_to_goal ready. Target: ({self.goal_x}, {self.goal_y}). '
            f"Waiting for a 'start_movement' service call with data=True."
        )

    def start_movement_callback(self, request: SetBool.Request, response: SetBool.Response):
        """SetBool service callback - must return quickly.

        Only toggles the movement_active flag; all actual driving logic
        happens later in control_loop(), which runs on its own timer.
        """
        self.movement_active = request.data

        if request.data:
            self.goal_reached = False  # allow re-arming after a previous run
            response.success = True
            response.message = 'Movement started: turtle will drive to the goal.'
            self.get_logger().info('Service call received: starting movement toward goal.')
        else:
            response.success = True
            response.message = 'Movement stopped.'
            self.get_logger().info('Service call received: stopping movement.')

        return response

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
        """Proportional Control Loop. Only drives the turtle once movement_active is True."""
        if not self.movement_active:
            return

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
            self.movement_active = False
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
    node = GoToGoal()
    rclpy.spin(node)
    node.destroy_node()
    rclpy.shutdown()
```
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
```python
#go_to_goal_client.py
import rclpy
from rclpy.node import Node
from std_srvs.srv import SetBool

from build.workshop2.build.lib.workshop2.go_to_goal_client import StartMovementClient

# How long to wait (in seconds) after this node starts before it calls
# the go_to_goal node's 'start_movement' service.
STARTUP_DELAY_SEC = 5.0



class GoToGoalClient(Node):
    def __init__(self):
        super().__init__('go_to_goal_client')

        self.declare_parameter('delay_sec', STARTUP_DELAY_SEC)
        self.delay_sec = self.get_parameter('delay_sec').value

        self.client = self.create_client(SetBool, 'start_movement')

        # One-shot timer: fires once after delay_sec, then cancels itself.
        # This keeps the delay logic out of the service callback pattern
        # entirely - it lives in the client, not the server.
        self.delay_timer = self.create_timer(self.delay_sec, self.on_delay_elapsed)

        self.get_logger().info(
            f'go_to_goal_client ready. Will call the service in {self.delay_sec:.1f}s.'
        )

    def on_delay_elapsed(self):
        # Only fire once.
        self.delay_timer.cancel()

        if not self.client.service_is_ready():
            self.get_logger().warn(
                "'start_movement' service not available yet, waiting..."
            )
            self.client.wait_for_service(timeout_sec=10.0)

        request = SetBool.Request()
        request.data = True

        self.get_logger().info("Calling 'start_movement' service with data=True.")
        future = self.client.call_async(request)
        future.add_done_callback(self.on_response)

    def on_response(self, future):
        try:
            response = future.result()
        except Exception as exc:
            self.get_logger().error(f'Service call failed: {exc}')
            return

        if response.success:
            self.get_logger().info(f'Service call succeeded: {response.message}')
        else:
            self.get_logger().warn(f'Service call was not accepted: {response.message}')


def main(args=None):
    rclpy.init(args=args)
    node = GoToGoalClient()
    rclpy.spin(node)
    node.destroy_node()
    rclpy.shutdown()
```
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
```python
# go_to_goal_params.yaml
go_to_goal:
  ros__parameters:
    target_x: 10.0
    target_y: 10.0
    linear_gain: 1.5
    angular_gain: 6.0
    distance_tolerance: 0.1
    angle_tolerance: 0.05
    loop_rate_hz: 20.0
```
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#pagebreak()
```python
# go_to_goal.launch.py
import os

from ament_index_python.packages import get_package_share_directory
from launch import LaunchDescription
from launch_ros.actions import Node

PACKAGE_NAME = 'workshop2'


def generate_launch_description():
    # Path to the YAML parameter file installed alongside this package.
    # Assumes go_to_goal_params.yaml is installed under:
    #   <install>/share/<PACKAGE_NAME>/config/go_to_goal_params.yaml
    # (i.e. it's listed in setup.py's data_files under a 'config' folder).
    params_file = os.path.join(
        get_package_share_directory(PACKAGE_NAME),
        'config',
        'go_to_goal_params.yaml',
    )

    turtlesim_node = Node(
        package='turtlesim',
        executable='turtlesim_node',
        name='turtlesim_node',
        output='screen',
    )

    go_to_goal_node = Node(
        package=PACKAGE_NAME,
        executable='go_to_goal',
        name='go_to_goal',
        output='screen',
        parameters=[params_file],
    )

    go_to_goal_client_node = Node(
        package=PACKAGE_NAME,
        executable='go_to_goal_client',
        name='go_to_goal_client',
        output='screen',
        parameters=[{'delay_sec': 5.0}] # optional
    )


    
    return LaunchDescription([
        turtlesim_node,
        go_to_goal_node,
        go_to_goal_client_node,
    ])
```
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

= Task 4 solution

```python
# serial_read.py
#!/usr/bin/env python3
"""
ROS 2 node that reads sensor data from a microcontroller (e.g. Arduino)
over a serial port and logs it.

Expects newline-terminated ASCII lines of the form:

    TEMP:23.45

This matches what mock_sensor_source.py writes, so the two can be tested
together via a socat pty pair:

    socat -d -d pty,raw,echo=0 pty,raw,echo=0
    # ex output: -> /dev/pts/3 and /dev/pts/4

    python3 mock_sensor_source.py /dev/pts/3 9600
    ros2 run workshop2 serial_read --ros-args -p serial_port:=/dev/pts/4 -p baud_rate:=9600

Usage (standalone):
    python3 serial_read.py
    ros2 run <package> serial_read
"""
import rclpy
from rclpy.node import Node

import serial


class SerialSensorReader(Node):
    def __init__(self):
        super().__init__('serial_reader')

        self.declare_parameter('serial_port', '/dev/pts/1')
        self.declare_parameter('baud_rate', 9600)
        self.declare_parameter('poll_period_sec', 0.1)

        port = self.get_parameter('serial_port').get_parameter_value().string_value
        baud = self.get_parameter('baud_rate').get_parameter_value().integer_value
        poll_period = self.get_parameter('poll_period_sec').get_parameter_value().double_value

        try:
            self.conn = serial.Serial(port, baud, timeout=1.0)
        except serial.SerialException as exc:
            self.get_logger().error(f'Could not open serial port {port}: {exc}')
            raise

        self.get_logger().info(f'Listening for sensor data on {port} at {baud} baud.')

        self.timer = self.create_timer(poll_period, self.poll_serial)

    def poll_serial(self):
        try:
            if self.conn.in_waiting == 0:
                return
            raw_line = self.conn.readline()
        except serial.SerialException as exc:
            self.get_logger().error(f'Serial read error: {exc}')
            return

        if not raw_line:
            return

        try:
            line = raw_line.decode('utf-8').strip()
        except UnicodeDecodeError:
            self.get_logger().warn(f'Received undecodable bytes: {raw_line!r}')
            return

        if not line:
            return

        reading = self.parse_line(line)
        if reading is None:
            self.get_logger().warn(f'Unrecognized line: {line!r}')
            return

        key, value = reading
        self.get_logger().info(f'{key}: {value}')

    @staticmethod
    def parse_line(line: str):
        """Parse a 'KEY:value' line into (key, float value), or None if malformed."""
        if ':' not in line:
            return None
        key, _, value_str = line.partition(':')
        try:
            value = float(value_str)
        except ValueError:
            return None
        return key.strip(), value

    def destroy_node(self):
        if hasattr(self, 'conn') and self.conn.is_open:
            self.conn.close()
        super().destroy_node()


def main(args=None):
    rclpy.init(args=args)
    node = None
    try:
        node = SerialSensorReader()
        rclpy.spin(node)
    except (KeyboardInterrupt, serial.SerialException):
        pass
    finally:
        if node is not None:
            node.destroy_node()
        rclpy.shutdown()
```
 #pagebreak()

 = task 1,2,3 with bonus

 ```python
# go_to_goal_bonus.py
 import math
import rclpy
from rclpy.node import Node
from geometry_msgs.msg import Twist
from turtlesim.msg import Pose
from turtle_interfaces.srv import SetTarget

# turtlesim's default field is roughly an 11x11 square (0.0 to 11.0 on
# each axis). Requests outside this range are rejected as out of bounds.
FIELD_MIN = 0.0
FIELD_MAX = 11.0


class GoToGoal(Node):
    def __init__(self):
        super().__init__('go_to_goal_bonus')

        # Note: target_x / target_y are intentionally NOT declared as
        # parameters anymore. With the SetTarget service, the goal
        # coordinates come from the request, not from the YAML file.
        self.declare_parameter('linear_gain', 1.5)
        self.declare_parameter('angular_gain', 6.0)
        self.declare_parameter('distance_tolerance', 0.1)
        self.declare_parameter('angle_tolerance', 0.05)
        self.declare_parameter('loop_rate_hz', 20.0)

        # Proportional Gains (K_p)
        self.kp_linear = self.get_parameter('linear_gain').value
        self.kp_angular = self.get_parameter('angular_gain').value

        # Tolerances
        self.distance_tolerance = self.get_parameter('distance_tolerance').value
        self.angle_tolerance = self.get_parameter('angle_tolerance').value

        # Loop Rate
        self.loop_rate_hz = self.get_parameter('loop_rate_hz').value

        # State Variables
        self.current_pose = None
        self.goal_reached = True   # nothing to do until a target is set
        self.movement_active = False
        self.goal_x = None
        self.goal_y = None

        # ROS 2 Publisher & Subscriber
        self.cmd_vel_publisher = self.create_publisher(Twist, '/turtle1/cmd_vel', 10)
        self.pose_subscriber = self.create_subscription(
            Pose, '/turtle1/pose', self.pose_callback, 10
        )

        # SetTarget Service Server. The callback ONLY validates the
        # request, stores the new goal, and flips movement_active - it
        # does NOT wait for the turtle to arrive. Actual driving happens
        # in the timer-driven control_loop below, so the service returns
        # immediately regardless of how long the turtle takes to arrive.
        self.set_target_service = self.create_service(
            SetTarget, 'set_target', self.set_target_callback
        )

        # Control Loop running at the configured rate
        self.timer = self.create_timer(1.0 / self.loop_rate_hz, self.control_loop)

        self.get_logger().info(
            "go_to_goal ready. Waiting for a 'set_target' service call with x, y."
        )

    def set_target_callback(self, request: SetTarget.Request, response: SetTarget.Response):
        """SetTarget service callback - must return quickly.

        Validates the requested coordinates, stores them, and arms
        movement. It does not block waiting for the turtle to reach the
        goal; the timer-driven control_loop() does the actual driving.
        """
        x, y = request.x, request.y

        in_bounds = (FIELD_MIN <= x <= FIELD_MAX) and (FIELD_MIN <= y <= FIELD_MAX)

        if not in_bounds:
            response.success = False
            response.message = (
                f'Rejected: ({x}, {y}) is out of bounds '
                f'[{FIELD_MIN}, {FIELD_MAX}] on both axes.'
            )
            self.get_logger().warn(response.message)
            return response

        self.goal_x = x
        self.goal_y = y
        self.goal_reached = False
        self.movement_active = True

        response.success = True
        response.message = f'Accepted: driving to ({x}, {y}).'
        self.get_logger().info(response.message)
        return response

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
        """Proportional Control Loop. Only drives the turtle once movement_active is True."""
        if not self.movement_active:
            return

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
            self.movement_active = False
            self.get_logger().info(
                f'Goal Reached Successfully at ({self.goal_x}, {self.goal_y})!'
            )
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
    node = GoToGoal()
    rclpy.spin(node)
    node.destroy_node()
    rclpy.shutdown()
 ```
 ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  ```python
 # go_to_goal_client_bonus.py
 import rclpy
from rclpy.node import Node
from turtle_interfaces.srv import SetTarget

# Defaults; all overridable via ROS 2 parameters at launch time.
STARTUP_DELAY_SEC = 5.0
DEFAULT_TARGET_X = 10.0
DEFAULT_TARGET_Y = 10.0


class GoToGoalClient(Node):
    def __init__(self):
        super().__init__('go_to_goal_client_bonus')

        self.declare_parameter('delay_sec', STARTUP_DELAY_SEC)
        self.declare_parameter('target_x', DEFAULT_TARGET_X)
        self.declare_parameter('target_y', DEFAULT_TARGET_Y)

        self.delay_sec = self.get_parameter('delay_sec').value
        self.target_x = self.get_parameter('target_x').value
        self.target_y = self.get_parameter('target_y').value

        self.client = self.create_client(SetTarget, 'set_target')

        # One-shot timer: fires once after delay_sec, then cancels itself.
        self.delay_timer = self.create_timer(self.delay_sec, self.on_delay_elapsed)

        self.get_logger().info(
            f'go_to_goal_client_bonus ready. Will call the service in {self.delay_sec:.1f}s '
            f'with target ({self.target_x}, {self.target_y}).'
        )

    def on_delay_elapsed(self):
        # Only fire once.
        self.delay_timer.cancel()

        if not self.client.service_is_ready():
            self.get_logger().warn("'set_target' service not available yet, waiting...")
            self.client.wait_for_service(timeout_sec=10.0)

        request = SetTarget.Request()
        request.x = self.target_x
        request.y = self.target_y

        self.get_logger().info(
            f'Calling go_to_goal with x={request.x}, y={request.y}.'
        )
        future = self.client.call_async(request)
        future.add_done_callback(self.on_response)

    def on_response(self, future):
        try:
            response = future.result()
        except Exception as exc:
            self.get_logger().error(f'Service call failed: {exc}')
            return

        if response.success:
            self.get_logger().info(f'Request accepted: {response.message}')
        else:
            self.get_logger().warn(f'Request rejected: {response.message}')


def main(args=None):
    rclpy.init(args=args)
    node = GoToGoalClient()
    rclpy.spin(node)
    node.destroy_node()
    rclpy.shutdown()
 ```
 ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  ```python
 # go_to_goal_bonus_params.yaml
 go_to_goal_bonus:
  ros__parameters:
    linear_gain: 1.5
    angular_gain: 6.0
    distance_tolerance: 0.1
    angle_tolerance: 0.05
    loop_rate_hz: 20.0
 ```
 ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  ```python
 # go_to_goal_bonus.launch.py
 import os

from ament_index_python.packages import get_package_share_directory
from launch import LaunchDescription
from launch_ros.actions import Node

PACKAGE_NAME = 'workshop2'


def generate_launch_description():
    # Path to the YAML parameter file installed alongside this package.
    # Assumes go_to_goal_params.yaml is installed under:
    #   <install>/share/<PACKAGE_NAME>/config/go_to_goal_params.yaml
    # (i.e. it's listed in setup.py's data_files under a 'config' folder).
    params_file = os.path.join(
        get_package_share_directory(PACKAGE_NAME),
        'config',
        'go_to_goal_bonus_params.yaml',
    )

    turtlesim_node = Node(
        package='turtlesim',
        executable='turtlesim_node',
        name='turtlesim_node',
        output='screen',
    )

    go_to_goal_node = Node(
        package=PACKAGE_NAME,
        executable='go_to_goal_bonus',
        name='go_to_goal_bonus',
        output='screen',
        parameters=[params_file],
    )

    # Calls the custom SetTarget service (x, y) after a delay, instead
    # of the old SetBool start_movement_client.
    set_target_client_node = Node(
        package=PACKAGE_NAME,
        executable='go_to_goal_client_bonus',
        name='go_to_goal_client_bonus',
        output='screen',
        parameters=[{
            'delay_sec': 5.0,
            'target_x': 10.0,
            'target_y': 10.0,
        }],
    )

    return LaunchDescription([
        turtlesim_node,
        go_to_goal_node,
        set_target_client_node,
    ])
 ```
 