#import "/Theme/report.typ": (
  brand-palette, cover-page, emphasis, pause-page-counting, report-template, resume-page-counting, watermark_text,
)

#import "@preview/calloutly:1.1.0": important, note, tip

#cover-page(title: [Training '26], subtitle: [Software | Phase II], topic: "Task 2: Intro to Python")

#show: report-template.with(ribbon-text: "Task 2")

= Introduction

After watching #link("https://youtu.be/3fQ_eQNfeFw", "Session 2"), you should be able to use python for the following paths.

#important(
  title:"Work in github"
)[your task must be uploaded in github as well in a certain format: read the submission guidelines. Make sure that ALL your subtasks are created under a folder called task_2, each subtask's files inside a folder called subtask_i where i is the subtask's number]

= Subtask 1
you are required to create a program for a warehouse to manage its stock

== Files
- create #emphasis("stock.txt") and fill it with the following format:\ 
  #note(title: "stock.txt")[
  banana,5\ 
  apple,3\ 
  mango,7\
]
- create #emphasis("stock_manager.py"): your python program

== Program Functionality
1. read the file #emphasis("stock.txt") 
  #tip()[Read the stock.txt and represent it as a dictionary in your code]
  #note(title:"file validation")[
    you need to handle if the file is not present or if an error occurred due to corrupted file format\
    hint: use try,except
  ]
2. print 4 menu options (add/remove/show/exit): \ 
  #note(title: "example menu")[
  enter 1 to add stock \ 
  enter 2 to remove stock \
  enter 3 to show stock's contents \ 
  enter 4 to exit the program
]
3. take input make sure to #emphasis("Validate the input either 1/2/3/4")
4. after finishing each one re-print the menu except after option 4

=== Adding to the Stock
1. print the contents of the stock and their stock in a readable format, before each name write an id
  #note(title:"example")[
  1. banana: 5\ 
  2. apple: 3\ 
  3. mango: 7
]
2. then print a statement prompting the user to enter the stock name or id; e.g. enter "banana" or "1" to change banana stock or enter "Dates" for a new stock \ 
3. take input (string/int)
  - validate the input
  - if input is string: change it so the string is all lower case (so banana is the same as Banana in the stock.txt)
4. print a statement prompting the user to enter how much to add to the sock
5. take a value
  - validate the input
  - if the stock was already in stock.txt then take old value + new value
  - if a new stock, then create a new key with the input value
  
=== Removing from the Stock
1. print the contents of the stock and their stock in a readable format, before each name write an id
  #note(title:"example")[
  1. banana: 5\ 
  2. apple: 3\ 
  3. mango: 7
]
2. then print a statement prompting the user to enter the stock name or id; e.g. enter "banana" or "1" to change banana stock \ 
3. take input (string/int)
  - validate the input - new stocks are invalid, must be already in the stock
  - if input is string: change it so the string is all lower case (so banana is the same as Banana in the stock.txt)
4. print a statement prompting the user to enter how much to remove from the sock
5. take a value
  - validate the input
  - old value - new value: must not be < 0

=== Showing the Stock

print the contents of the stock and their stock in a readable format, before each name write an id
  #note(title:"example")[
  1. banana: 5\ 
  2. apple: 3\ 
  3. mango: 7
]

  #tip(title:"hint")[write 1 function to show the stock and use it thrice: here, before adding and before removing stock]

=== Exiting the Program
make sure that you save the the stock changes to #emphasis("stock.txt") then exit the program
  #tip(title: "hint")[use an infinite loop for the initial loop and exit by saving the using the #(`break;`) command to escape the loop and terminate the program] 

#line(length: 100%) 

#important(title: "Important",)[
  - Divide your code into functions, avoid repetition and make sure the code is readable
  - Make sure to use the Python Conventions explained in the video
]

= Subtask 2
You are given this python code:
#[
```
from PIL import Image
def main():
   image = Image.open("img.png")
   bw_image = image.convert("L")
   bw_image.show()
If you try to run it, you will get the an error saying that there is no module called PIL.
```
]

You need to use uv to install the pillow package, which contains the PIL module. 
1. Create a uv project
2. Add the pillow package
3. Place any colourful image in the root of the project (the folder that contains src, pyproject.toml, ect)
4. Rename the image file to img.png
5. Make sure the VScode terminal is at the root of the project
6. Run the given example code, and it should display a greyscale version of the image you have

= Submission

#emphasis("Github Steps")
1. Merge the previous Pull Request from task 1
2. Pull main
3. Create a branch called task-2
4. Create a folder called task_2
5. Create a branch called task-2/subtask-1
6. Create a folder called subtask_1
7. Upload subtask_1
8. Merge task-2/subtask-1 into task-2 either via pull request or merge command
9. delete task-2/subtask-1 branch
10. repeat steps for subtask 2
11. create a pull request for merging task-2 into main, do not merge the pull request

#emphasis("Besides Github you must upload the task_2 folder as a zip file in the follwing link:")
#link("https://forms.gle/XVVSfdns8dFk6Tvd6")

#emphasis("Deadline: Tuesday, August 25th -- 11:59 pm")
