#import "/Theme/report.typ": (
  brand-palette, cover-page, emphasis, pause-page-counting, report-template, resume-page-counting, watermark_text,
)

#cover-page(title: [Training '26], subtitle: [Firmware | Phase 3], topic: "Task 4")
#show: report-template.with(ribbon-text: "Phase III - Firmware")

== Format and Deliverables
+ Choose Arduino nano ATmega328 as the board in you platformio.ini file.
+ All Tasks must be Tested in simulide.
+ simulation file(.sim) must be uploaded.
+ Use the serial terminal peripheral connected via uart in simulide to verify the correctness of your work 




== Task 2: Create an RTOS queue and 3 tasks:

=== Objective:
Implement a multi-task FreeRTOS application utilizing a message queue for inter-task communication, featuring centralized serial resource protection and isolated producer-consumer workflows.


=== Requirments
+ Create an RTOS queue capable of holding string pointers or messages.

+ Task 1 (Consumer): Responsible for continuously checking the queue and printing messages to the Serial Monitor. Make sure it only attempts to dequeue when the queue is not empty.

+ Task 2 (Producer A): Periodically pushes the string " Task one is working" into the queue using a proper non-blocking RTOS delay (e.g., vTaskDelay) to control frequency.

+ Task 3 (Producer B): Periodically pushes the string "Task two is working" into the queue using a separate RTOS delay interval.

+ Resource Guarding: Ensure that only Task 1 interacts with the Serial Monitor to prevent data corruption or race conditions.