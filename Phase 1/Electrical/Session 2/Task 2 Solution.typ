#import "/Theme/report.typ": (
  brand-palette, cover-page, emphasis, pause-page-counting, report-template, resume-page-counting, watermark_text,
)
#import "/Theme/common.typ": setup-codly

#show: setup-codly

#import "@preview/calloutly:1.1.0": important, note, tip

#cover-page(title: [Training '26], subtitle: [Electrical | Phase I], topic: [Task 2: Introduction to C++\ Solution])
#show: report-template.with(ribbon-text: "Task 2 | Solution")

= Introduction

After watching #link("https://youtu.be/YAmagt08ZFw", "Session 2"), you should be able to write programs that solve basic problems using #emphasis[C++] and features like conditions, loops and functions.

For this task, you will solve a few problems using C++ on an external website -- #emphasis[VJudge].

= Problems

+ #link("https://codeforces.com/problemset/problem/4/A", "Watermelon")
+ #link("https://codeforces.com/problemset/problem/69/A", "Vectors")
+ #link("https://codeforces.com/problemset/problem/705/A", "Hulk")
+ #link("https://codeforces.com/problemset/problem/1005/A", "Tanya and Stairways")
+ #link("https://codeforces.com/problemset/problem/58/A", "Hello")
+ #link("https://codeforces.com/problemset/problem/2227/A", "Koshary")
+ #link("https://codeforces.com/problemset/problem/1095/A", "Repeating Cipher")

= Solutions

== Watermelon
The problem's idea is to check whether $w$ can be split into two even parts. All even numbers except 2 can be split into two even weight parts, whereas 2 can only be split into two parts each weighing 1 kg.

Our criteria for outputting `YES` now becomes whether the number is both even and greater than 2. The given constraints grant that $1 <= w <= 100$.
```cpp
#include <iostream>

using namespace std;

int main() {
  int w;
  cin >> w;
  if (w % 2 == 0 && w > 2) {
    cout << "YES";
  } else {
    cout << "NO";
  }
  return 0;
}
```

== Vectors
We are going to check whether all input vectors sum up to the zero-vector: $(0,0,0)$, meaning the body will not move. In the zero-vector, the values $x_"total", y_"total", z_"total"$ are all 0. We can solve this by summing all inputs to their corresponding total variable, and checking if the final sum is zero.
```cpp
#include <iostream>

using namepsace std;

int main() {
  int x, y, z;
  x = 0; y = 0; z = 0;
  int n, xi, yi, zi;
  cin >> n;
  while (n--) { // loop n times
    cin >> xi >> yi >> zi;
    x += xi; // equivalent to x = x + xi
    y += yi;
    z += zi;
  }
  if (x == 0 && y == 0 && z == 0) {
    cout << "YES";
  } else {
    cout << "NO";
  }
  return 0;
}
```

== 