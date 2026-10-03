#import "/Theme/report.typ": (
  brand-palette, cover-page, emphasis, pause-page-counting, report-template, resume-page-counting, watermark_text,
)

#import "@preview/calloutly:1.1.0": important, tip, warning
#import "/Theme/common.typ": setup-codly
#import "@preview/tablex:0.0.8": tablex

// Global font size adjustment
#set text(size: 11.5pt)

#show: setup-codly

#cover-page(
  title: [Final Project Rulebook 2026],
  subtitle: [Alexandria University Robotics],
  topic: [Final Project],
)

#show: report-template.with(
  ribbon-text: "Rulebook 2026",
)

// Dedicated Table of Contents / Index Page
#outline(
  title: [Table of Contents],
  indent: auto,
)

#pagebreak()

= Overview

The objective of the final project for team members is:
- Design and create a full robot from scratch.
- Practice and implement what they’ve learned throughout the training.
- Work with other team members from different subteams.
- Experience a simulation for competition-like work in stressed manners.

All members will be divided into 3 teams, with each team consisting of members from all subteams. Mentors will be assigned to each team, with the purpose of guiding the team. One of the mentors will be the leading mentor.

The final project #emphasis("starts from the 1st of October. Competition day will be October 16th"), where each team’s robot will perform the mission required.


= Technical Task

== Mission
Each team should create a robot #emphasis("no longer than 30 cm or wider than 30 cm or taller than 40 cm"). The robot’s task is to pick up a box from behind a 3 cm wall, deliver it to its specified destination, drop it, and so on until all boxes are delivered. All positions are cartesian coordinates (x-axis and y-axis).

There will be 2 types of boxes:
- *Colored Boxes:* Each colored box should be picked up and dropped off at the 15 cm by 15 cm area that has the same color. The position of the areas will be changed after the end of each round. There will be two types of colored boxes that differ in the scoring system:
  - *Easy Boxes:* The area where these boxes will be dropped off will always be present during the whole run. These boxes will be colored blue.
  - *Hard Boxes:* The area where these boxes will be dropped off will be removed after #emphasis("4 minutes") from the start of the run. These boxes will be colored red.
- *QR boxes:* Each QR box’s specified destination is encoded on a QR code on the box. The robot should scan the QR code to know the box’s destination. The QR code will contain the destination in x and y coordinates, for example, the QR code below when decoded gives the following string “X=1.56&Y=0.49”, which means its destination is 1.56 meters from the starting point on the x-axis, and 0.49 meters on the y-axis. QR boxes will be colored in green (It is guaranteed that the QR boxes will have different colors than the normal colored boxes).

#warning[
  All colors that are written in the rulebook can be changed depending on what’s available in the market, teams should take into consideration that a surprise color may be presented on the day of the competition.
]

#figure(
  image("Assets/qr code.PNG", width: 30%), 
  caption: [QR Code Example]
)


== Playground
The robot will perform its rounds on a #emphasis("3 meters x 3 meters") square area. The robot will start at x = 0 meters and y = 0 meters, and all the boxes will be originally placed at the edge of the playground (y = 3 meters).

#figure(
  image("Assets/Playground.PNG", width: 60%),
  caption: [Playground Map]
)

The playground area will not be physically fenced, and will only be marked with a visible black line. The boxes will be made of cardboard, and will be 6 cm x 6 cm x 6 cm, with the QR Code on a 4 cm x 4 cm sticker located at top-middle of the box’s front side.

#figure(
  image("Assets/box.PNG", width: 40%),
  caption: [Box Dimensions]
)


== Rounds & Scoring
Each team will play #emphasis("3 rounds"), with each round lasting for a maximum of #emphasis("10 minutes"). During a round, team members cannot physically touch their robot, except when powering it on in the beginning of the round. The team will attain a score per round, and only the highest score between the 3 rounds will be counted. 

The round’s score is calculated as follows:
- *For the QR Boxes:* Score per delivered box = $(75 - "absolute error in cm")^2$ (if the absolute error exceeds 75 cm the box’s score is zeroed).
- *For the colored boxes:* Score = number of delivered boxes $times$ 50.
- Hard colored boxes that will be delivered correctly after the first 4 minutes will have a #emphasis("x5 multiplier").
- Total round score = $sum ("sum of all boxes' scores")$.

== Bonus
Having the robot perform the mission autonomously will attain its team bonus points. The bonus task is split into the following:
- *Semi-autonomous:* The robot can move from the box’s original position to the destination autonomously, while the pilot helps with picking up the boxes. Achieving the semi-autonomous task will give a #emphasis("20% bonus") on the round’s points.
- *Fully-autonomous:* The robot can run the whole round autonomously without any human input, including picking up the boxes by itself and delivering it to its intended position. Achieving the fully-autonomous task will give a #emphasis("50% bonus") on the round’s points.


= Robot Sections

== Mechanical Design
Each robot must be equipped with an arm capable of securely holding cardboard boxes until it reaches the designated destination.
Bonus points will be awarded for mechanical simulation. The bonus will be a maximum of #emphasis("200 points") depending on the accuracy, importance and relevance of the simulation.

== Hardware
- Every team is required to design and build their hardware circuits on a #emphasis("printed circuit board (PCB)").
- All modules used in the robot must be designed and developed by the hardware team members, avoiding pre-built or purchased modules (except if necessary and the motor driver).
- The PCBs #emphasis("must be designed and fabricated by the team").
- You are required to use an ESP32 (dev board, not ICs).
- You are required to design your own buck converter.
- Each team must design its own motor driver but this driver will not be used on the robot nor included in the team's budget.
- The motor driver design will be reviewed and tested on the competition day.It's allocated a budget of an extra 300 EGP and not included in total budget.  
- The motor driver should be able to drive the motor used in the robot.
- Select all components, including the batteries, with precision. Every choice should be well-calculated and serve a specific purpose.
- Calculate voltage required for each device and current draw, #emphasis("or you risk frying your whole system.")

== Console
Each team must develop a desktop application, to be run on a laptop, which will serve as the robot’s console. The console must:
- Display the incoming camera feed, insuring to consume as little main thread overhead as possible.
- Graphically display real-time odometry data (using dynamic visual indicators), including:
  - Robot's current coordinates on the playfield.
  - Robot's current speed.
  - Robot's current heading/rotation.
- Display the drop-off location of the QR code encoded boxes.
- Receive control inputs from the human pilot and transmit them to the robot.
Optionally, if semi-autonomous or autonomous modes are implemented on the firmware side, add controls to switch between these modes at the start or in the middle of the run.

== Camera
Every robot must include a camera that streams its feed to the console. Computer vision scripts should process the video feed. When the camera detects a QR code, the scripts must identify and display the corresponding coordinates to the pilot or relay them to the autonomous system.
Mobile phones can be mounted & feedback from them can be integrated into the CV and motion systems.

== Microcontroller & Embedded Systems
All teams are required to use the #emphasis("ESP-32") as the microcontroller for their robot.
Bonus points will be awarded to teams that apply the knowledge gained from previous sessions to #emphasis("write custom drivers") for the sensors. For example, if using an IMU like the MPU6050, do not rely on pre-built libraries; instead, write your own driver to operate the sensor.
Given that the team has studied RTOS in prior sessions, your code should manage multiple tasks using #emphasis("FreeRTOS").

== Use of ROS
Teams are allowed and encouraged to use the Robot Operating System (ROS or ROS 2) to structure their software. ROS may be used to organize communication between modules, manage sensor data, visualize information, and test control algorithms.

The system should be divided into two main parts:
- *Robot-side:* includes the ESP32, onboard sensors, actuators, and the camera.
- *Console-side:* runs ROS on a laptop and may handle visualization, control input, and higher-level logic such as localization and navigation.

Teams are free to choose their preferred method of communication between the robot and the console. The chosen method must be clearly justified in the documentation and should ensure reliable and low-latency communication.

Teams using ROS must ensure that:
- All nodes, topics, and message types are clearly documented.
- The system is designed and coded by the team.
- ROS usage enhances reliability, visualization, or modularity rather than replacing the core implementation work.

#tip[
  Some suitable ROS packages that would be of great help and use include: `tf2`, `cv_bridge`, `image_transport`, `robot_localization`.
]

== Motion, Localization & Navigation
- *Motion:* If implementing Autonomous Motion, control the robot using a #emphasis("PID controller") and incorporate path planning algorithms to aid in navigation.
- *Localization:* One of the key tasks is to accurately localize the robot on the playground. Utilize as many sensors as necessary, experiment with different sensor fusion techniques, and apply filters to ensure that the sensor data is smooth and reliable.
- *Navigation:* If the main tasks are complete and you decide to implement autonomous navigation, you must guide the robot from point to point. As discussed in prior sessions, this process has been simulated, and if issues arise, you can continue to test and refine your code within the simulation environment.


= Budget
Each team is subject to a budget cap. The total cost of materials and components used in the robot should not exceed the budget cap. Only the materials and components used are counted, for example, components bought for testing but not included in the final product, any obsolete mechanical structures and any burnt electronic components are not counted in the team’s budget. 

#emphasis("The final budget cap for the final project robot, including all used components and materials, will be 3500 EGP.")


= Non-Technical Task
== Documentation
All teams are required to write a report documenting all their work, including mechanical designs, hardware, and software. Teams should also include their decided approach for each aspect of the robot, and compare it to alternative approaches. The reports will be handed in before the day of the competition, with the exact date to be decided.

#emphasis("Bonus:")\
A bonus will be given to teams who use Latex or Typst.


== Presentation
On the day of the competition, teams will be required to present a #emphasis("10-minute pitch") of their work. Usage of PowerPoint slides are allowed and encouraged. After the pitch, each team member will be discussed thoroughly about his/her work.

#important[
  *Penalties & Restrictions:*
  - Exceeding the dimension restrictions for the robot will get you penalised.
  - Exceeding the budget cap for the robot will get you heavily penalised.
  - Delay of submitting the required documents will get you penalised.
  - Each team must fabricate their own motor driver, and failure to do so will get you penalised.
]


= Score Weights
Total maximum score: #emphasis("2500 points").

== Technical Tasks (1500 points)
- *Main Task (1000 points):* Main task points will be calculated as described in the rule book, then scaled according to the highest scoring team, meaning the highest scoring team will have 1000 points and the rest of the teams will have their points multiplied with the same ratio. In other words: #emphasis("main task points = 1000 x (score / highest score)").
- *Semi Autonomous Task (200 points):* Semi autonomous task points will be 20% of the main task points.
- *Fully Autonomous Task (300 points):* Fully autonomous task points will be 30% of the main task points. Achieving both the semi and full autonomous tasks will get you a total of 50% bonus.

== Non-technical Tasks (450 points)
- Presentation and Discussion (250 points)
- Report and Documentation (150 points + 50 points if the team used #emphasis("Typst"))

== Implementation & Design (550 points)
These points will be given according to how well the following points were implemented:
- *Mechanical Design (100 points):* Reliability and versatility of the robot chassis and the arm.
- *Hardware Design (100 points):* Efficiency and failure-prudence of the circuit and PCB.
- *Computer Vision (100 points):* Accuracy and efficiency of the implementation of the QR reading.
- *Motion and Control (50 points):* Smoothness of the robot's traversal on the playground, and maneuverability of the robot.
- *Navigation and Localization (50 points):* Accuracy of the robot's localization and mapping.
- *Desktop and Communication (100 points):* Reliability and efficiency of the communication between the console and the robot, controllability of the user interface. Code architecture and design is Considered in the grading; a specially good design will be granted bonuses. Design includes SOLID principles, clean code and code that can be easily scaled. 
- *Microcontroller (50 points):* Utilization of the ESP-32's features.


= Required Documents
All teams should hand in to their assigned mentor the following before deadline:
- A #emphasis("budget Excel sheet") containing detailed description about all components and materials used amounting to the robot's budget. The sheet should list all items, their price and quantity, and type.
- A #emphasis("Github repository") containing all code, hardware and mechanical designs used.
- A #emphasis("comprehensive report") containing how the robot works, explanations of codes, hardware and mechanical designs used, why each code/design approach was chosen over their alternatives and all budget details.