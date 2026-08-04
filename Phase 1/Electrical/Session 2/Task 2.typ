#import "/Theme/report.typ": (
  brand-palette, cover-page, emphasis, pause-page-counting, report-template, resume-page-counting, watermark_text,
)
#import "/Theme/common.typ": setup-codly

#show: setup-codly

#import "@preview/calloutly:1.1.0": important, note, tip

#cover-page(title: [Training '26], subtitle: [Electrical | Phase I], topic: "Task 2: Introduction to C++")
#show: report-template.with(ribbon-text: "Task 2")

= Introduction

After watching #link("https://youtu.be/YAmagt08ZFw", "Session 2"), you should be able to write programs that solve basic problems using #emphasis[C++] and features like conditions, loops and functions.

For this task, you will solve a few problems using C++ on an external website -- #emphasis[VJudge].

= Task Steps

== Join the Contest
+ Visit https://vjudge.net to create an account or login, then note down your username
+ The problemset will be available at https://vjudge.net/contest/836844#problem
+ Password: `aurobotics2026`

== Solve Problems
+ Follow #link("https://drive.google.com/file/d/1M0bQtLVbzqsTcTzTwrVFkBsJ7sWWGM0a/view?usp=sharing", "this guide") to submit your solution to each problem
+ Make sure your solution was accepted as correct before moving on. Sometimes solutions are not accepted because of a tiny error in the format of the output.

= Final Submission

- You are finally required to submit your phone number and VJudge username for evaluation
- Use the following Google Form link: https://forms.gle/HHrBieVg43KeyAe96
- Deadline: Monday, August 3rd -- 11:59 pm


= Hints

For getting specific characters in a string in order, you should use one of the following techniques -- the code snippets below demonstrate outputting letter-by-letter the same data that is taken as input.

After taking full input:
```cpp
string s;
cin >> s;
while (i < s.length())
  {
      cout << s[i];
  }
```

While taking input:
```cpp
char c;
while ( (c = cin.get()) != ' ') {
  cout << c;
}
```