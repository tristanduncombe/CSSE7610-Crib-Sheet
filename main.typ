#import "@preview/boxed-sheet:0.1.0": *
#import "@preview/cetz:0.4.2"
#import "@local/interleave:0.1.0"

#set text(font: "Noto Sans")

#let author = "Tristan Duncombe & Maybe M"
#let title = "Concurrency Cheat Sheet"

#show: cheatsheet.with(
  title: title,
  authors: author,
  write-title: true,
  title-align: left,
  title-number: true,
  title-delta: 2pt,
  scaling-size: false,
  font-size: 5.5pt,
  line-skip: 5.5pt,
  x-margin: 10pt,
  y-margin: 30pt,
  num-columns: 4,
  column-gutter: 2pt,
  numbered-units: false
)
= Reminders
// TODO
// #[
//   #h(1fr)
//   #box(
//     // Background layer: image of Brae
//     width: 1fr,
//     height: 100pt,
//     place(center, [
//       #place(image("images/brae.jpeg", width: 70pt))
//       #place(image("images/speech.svg", width: 40pt),
//       dx: 40pt,  // horizontal offset from image center
//       dy: 0pt, // vertical offset (negative = upward)
//       )
//       #place([#text(size: 5pt) You can do this])
      
//     ])
//     // Foreground layer: speech bubble
    
//   )
//   #h(1fr)
// ]

= Mutual Exclusion
#concept-block(body: [
  #inline("Core Problem")
  The critical section problem is a classic issue in concurrent programming. It arises when multiple processes or threads need to access and manipulate shared resources (such as variables, files, or data structures) at the same time.
  #inline("Correctness Criteria")
  *Mutual Exclusion* statements from the critical section of two or more processes must not be interleaved

  *Freedom from deadlock* If _some _ processes are trying to enter their critical sections, then _one_ must eventually succeed.

  *Freedom from starvation* If _any_ process tries to enter its critical section then _that_ process must eventually succeed.

  #inline("Assumptions")

  #inline("While Loop")
  ```python
  var i = 1;           // initialize
  while (i < 100) {    // enters the cycle if statement is true
    i *= 2;            // increment to avoid infinite loop
    document.write(i + ", ");   // output
  }
  ```
])
