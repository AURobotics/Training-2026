#import "/Theme/report.typ": (
  brand-palette, cover-page, emphasis, pause-page-counting, report-template, resume-page-counting, watermark_text,
)

#import "@preview/calloutly:1.1.0": important, note, tip

#cover-page(title: [Training '26], subtitle: [Software | Phase II], topic: "Task 1: Git & Github")

#show: report-template.with(ribbon-text: "Task 1")

= Introduction

After watching #link("https://youtu.be/S-Dsl67JMbI", "Session 1"), you should be able to use #emphasis[git & github].

= Task
you are required to create a #emphasis("GitHub repository") for your team and submit the link to it.
Requirements:
- Name the repository as: #emphasis("AUR-Training-26")
- The repository should contain the following files:
  - #emphasis("README.md") created by default - make sure to include a readme when creating the repository
  - #emphasis(".gitignore") file created by default - choose the #emphasis("python") template when creating the repository
- Create a branch called task1 and push a file called #emphasis("task1.txt") to it. The file should contain the following text: "This is task 1 submission for AUR Training 26"
- Create a #emphasis("Pull Request") to merge the task1 branch into the main branch. #emphasis("Do not merge the pull request, keep the pull request hanging")

#important(
  title: "Important: GitHub Repository Link",
)[Make sure the repository is #emphasis("public") so that we can access it. If the repository is private, we will not be able to access it and you will not get credit for the task.]

= Submission

- Submit your work by sharing your repository link via the following Google Form link: https://forms.gle/1TNGpoJUnjWsxjFR8

- #emphasis("Deadline: Saturday, August 22th -- 11:59 pm")
