#import "@preview/boxed-sheet:0.1.0": *
#import "@preview/cetz:0.4.2"
#import "@local/interleave:0.1.0" :
#set text(font: "Noto Sans")
#set text(region: "AU")
#set text(lang: "EN")
#let author = "T & M"
#let title = "Concurrency Cheat Sheet"
#let always = $square$
#let eventually = $diamond$
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#show: codly-init.with()
#codly(languages: codly-languages)
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
- glhf

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

= Interleaving
#concept-block(body: [
  #image("Interleaving State Machine.png")
  #image("Scenarios.png")

  #inline("Definitions")
  *Critical References* to shared variables in a process P are those which:
  #set enum(numbering: "a)")
  + are assigned to in P and also occur in another process, or
  + those that appear in an expression (i.e. are read) in P and are assigned to in another process.

  A program satisfies the *Limited Critical Reference (LCR)* property if it has _at most one_ critical reference per statement: \
  #box()[
    $n <- n + 1$\
    $"temp" <- n + 1; n <- "temp"$
  ]
  #h(1fr)
  #box()[
    has two critical references in one statement \
    has one critical reference per statement.
  ]

  Declaring a variable as *volatile* tells the compiler to prevent optimisations that may re-order critical references.

  #inline("Correctness")
  *Safety*: The property must _always_ be true. \
  e.g. _A mouse cursor is always displayed or *n* is always positive._
  
  *Liveness*: The property must _eventually_ become true. \
  e.g. _If you click on a mouse button, eventually the mouse cursor will change shape or *n* is eventually zero._

  Safety and liveness are duals. The negation of a safety property is a liveness property.

  #inline("Fairness")
  *Weak Fairness* is the assumption that if a statement is continually enabled it will eventually be executed.
  $ #always (#eventually "p1" -> "p2") $
])

= Mutual Exclusion
#concept-block(body: [
  #inline("Critical Section Problem")
  The critical section problem is a classic issue in concurrent programming. It arises when multiple processes or threads need to access and manipulate shared resources (such as variables, files, or data structures) at the same time.

  The _pre-protocol_ and _post-protocol_ provide the synchronisation mechanism that allows us to ensure correctness.

  #image("Pre and Post Protocol.png")
  
  #inline("Correctness Criteria")
  *Mutual Exclusion* statements from the critical section of two or more processes must not be interleaved.

  *Freedom from deadlock* If _some _ processes are trying to enter their critical sections, then _one_ must eventually succeed.

  *Freedom from (individual) starvation* If _any_ process tries to enter its critical section then _that_ process must eventually succeed. \
  That means the critical section must progress. The non-critical section need not progress.

  *Live Lock* occurs if the algorithm is running but not making any progress. e.g. cycling between two states.
])

= Logic Review
#concept-block(body: [
  #always = Always, #eventually = Eventually

  #inline("Duality of Temporal Operators")
  
  #image("Duality of Temporal Operators.png")
  #v(-8pt)
  #align(center)[
    #set text(8pt)
    $not always A equiv eventually not A$
  ]

  #image("Duality of Temporal Operators 2.png")
  #v(-8pt)
  #align(center)[
    #set text(8pt)
    $not eventually A equiv always not A$
  ]

  #inline("Compound Temporal Operators")
  
  #image("Compound Temporal Operators 1.png")
  #v(-10pt)
  #align(center)[
    #set text(8pt)
    $eventually always A$
  ]
  
  #image("Compound Temporal Operators 2.png")
  #v(-10pt)
  #align(center)[
    #set text(8pt)
    $always eventually A$
  ]

  #inline("Deduction with Temporal Operators")
  #align(center)[
    #set text(8pt)
    $eventually always "A1" and eventually always "A2" arrow.double.r eventually always ("A1" and "A2")$
  ]
  
  #align(center)[
    #set text(8pt)
    $always eventually "A1" and always eventually "A2" arrow.double.r.not always eventually ("A1" and "A2")$
  ]
  

  #inline("Deckers Algorithm")
  
  Dekker's was the first known correct solution to mutual exclusion.
  
  #image("Dekkers.png")

  #image("Dekkers Invariants.png") 
])

= Semaphores
#concept-block(body: [
  #inline("Process State")
  A process is in one of the following states:
  #image("Process State.png")

  #inline("Basic Semaphore Definition")
  A semaphore S is a compound data type with two fields.
  - S.V which is a *non negative* integer, initially >= 0
  - S.L which is a *set* of processes, initially $emptyset$

  _a semaphore has the following *atomic* statements_:
  #image("Semaphore Def.png")

  #inline("Binary Semaphore")
  A binary semaphore makes some minimal changes to signal:
  #image("Binary Semaphore.png")
  #image("Binary Semaphore Example.png")

  #inline("Semaphore Invariants")
  - _k_ is the initial value of the semaphore;
  - _n#sub[s]_ (or \#signal(S)) is the number of signal statements executed;
  - _n#sub[w]_ (or \#wait(S)) is the number of wait statements successfully executed.

  #image("Semaphore Invariants.png") 
  #image("Semaphore Invariants 2.png")

  #inline("Strong Semaphores")
  *Strong semaphores* replace the set S.L with a *queue*.
  #image("Strong Semaphore.png")

  #inline("Busy-wait Semaphores")
  No S.L component, so we let S = S.V
  #image("Busy-Wait Semaphore.png")

  #inline("Split Semaphores")
  A *split semaphore* is the use of two or more semaphores whose sum is at most equal to a fixed number N.
  - nonEmpty + notFull <= N
])

= Linked Lists

#concept-block(body: [
  #inline("Types of Synchronisation")
  *Coarse-grained synchronisation* - to access a shared data structure, threads must lock and unlock a scalable, spin lock added to the data structure

  *Fine-grained synchronisation* - split the data structure into independently synchronised components

  *Optimistic synchronisation* - search data structure without acquiring locks; when component found, lock that component and check that it has not changed.

  *Lazy synchronisation* - postpone work; e.g. a component can be #emph("logically removed") by setting a tag bit, and later, #emph("physically removed") by unlinking it from the data structure

  *Non-blocking synchronisation* - eliminate locks, relying instead on the use of atomic operations such as `compareAndSet()`

  Implementation of all synchronisation methods is available in @linked-list.

  #inline("Coarse-grained synchronisation")

  Coarse-grained synchronisation is the simplest approach and is suitable when there is little contention.

  It obviously provides mutual exclusion; it is starvation free, if the Lock used is starvation-free.

  #inline("Fine-grained synchronisation")

  Rather than a lock on the #emph("whole list"), have a lock on #emph("each node").

  A thread locks a node when it first visits it, and unlocks it sometime later.

  This allows several threads to traverse the list together.

  To avoid deadline, it is important that all threads traverse the list in the same order.

  Why?
  - deadlock can occur if, for example, `remove()` and `add()` acquire locks in opposite order.
  #align(center)[
    #image("deadlock fine grained.png", width: 70%) 
  ]
  #inline("Optimistic synchronisation")

  Fine-grained locking requires long sequences of lock acquisitions and releases

  Accesses to disjoint parts of the list may still block each other.
  - e.g. a thread removing the second item in the list blocks searches for later nodes

  Optimistic locking overcomes these problems using threads which:
  - search without locking
  - lock the required nodes(s) when found
  - confirmed that the nodes(s) are the required ones once locked
  - if a conflict has occurred, the locked node(s) are released and the thread starts again

  This approach works well when the last step is #emph("rarely required") - hence, the name #emph("optimistic") synchronisation

  #inline("Lazy synchronisation")

  The optimistic list needs to traverse the list twice - once to find an item, and once to validate it.

  The optimistic list's `contain()` method needs to acquire locks (so that it can validate the node is still in the list)
  - undesirable since `containers()` much more common than `add()` and `remove()`

  Lazy synchronisation overcomes these problems by adding a `Boolean` tag to each node indicating whether the node is in the set.
  - no need to traverse the list to validate a node
  - `contains()` does not require a lock
  - `remove()` traverses the list, marks the target node (logically removing it), then redirects its predecessor's next field (#emph("physically") removing it)

  #inline("Non-blocking synchronisation")

  Non-blocking synchronisation eliminates all locks.

  A naive approach would be to use `compareAndSet()` to change `next` field

  The `AtomicMarkableReference<T>` from `java.util.concurrent.atomic` encapsulates a reference to an object of type `T` and a Boolean mark.

  The `compareAndSet()` method compares the current values of both the reference and the mark to expected values and, if they are the same, replaces them with new values and returns true; otherwise, it returns false.)
])
= Distributed Algorithms
#concept-block(body: [
  #inline("Distributed algoirthms definitions")
  
  A node represents a physically identifiable object (i.e. computer) which may be running multiple processes.
  - We abstract from concurrency issues #emph("within") nodes in order to focus on synchronisation #emph("between") nodes.

  Channels allows 2-way communication between nodes.
  - We abstract from error-handling, i.e. assume that message are #emph("always successfully delivered").

  - We assume #emph("finite") but #emph("arbitrary") transit times for messages because we don't want our algorithms to be sensitive to relative speed of channels.

  - As a consequence, messages are #emph("not necessarily received in the order they are sent").

  #inline("Node Technical STufffs")

  Each node has a unique id, we implicitly assume the following declaration exists: \
  #h(8pt) *constant* *integer* myID $arrow.l dots$

  There are two commands for communications: \
  #h(8pt)#smallcaps[Send] (MessageType, Destination[, Parameters]) \
  #h(8pt)#smallcaps[Receive] (MessageType[, Parameters])

  A process that executes a receive statement blocks until a message of the propr type is received.

  #image("node definition.png")

  #inline("Distrubted Mutual Exclusion")

  Distributed mutual exclusion ensures that at most one node is executing its critical section at any point in time.

  #inline("Problems with Distributed Systems")

  The 'chip-and-dale' problem:
  - This is the circumstance where two people have the same ID.

  Ticket number choosing:
  - If we choose a new number after processing each critical section, it may break where the two processes enter critical because the chosen ID is below the ID of another process.

  Non-responsive:
  - Consider a node that is requested and then does not respond.
    - This is because the #emph("non-critical section") may not terminate
  - We could set a variable after choosing a number and reset after the critical section.

  #inline("Token-passing algoirthms")
  Permissions-based algorithms
  - can be inefficient for large numbers of nodes
  - don't show improved performance when there is no contention - all messages must still be sent

  In #emph("token-based algorithms")
  - permission to enter the critical section is associated with possession of a token
  - only one message is needed is needed to transfer a token
  - a node possessing the token can enter its critical section multiple times without sending or receiving messages
])
= Real-Time Systems
#concept-block(body: [


  #inline("Real-time systems definitions")
  *hard* deadlines - critical if they are not met \
  *soft* deadlines - undesirable if they are not met

  Process in real-time systems are called *tasks*

  Each task has:
  - release time $r$ - the time when the task joins the ready queue
  - execution time $e$ - the maximum duration of the task
  - response time - duration from $r$ to when the task is completed
  - (relative) deadline $D$ - maximum response time allowed

  #image("image.png")

  Periodic real-time systems have a fixed interval between release times called the period.
  
  #image("image (1).png")

  Tasks may also be #emph("aperiodic") or #emph("sporatic"):
  - aperiodic tasks are non-periodic tasks with soft deadlines
  - sporadic tasks are non-periodic tasks with hard deadlines.
  
  A hardware clock is used to divide processor time into frames

  The program is broken into tasks which can be completed in #emph("one frame")

  A scheduling table assigns tasks to frames.

  #inline("Asynchronous systems")
  Asynchronous systems have no fixed time frames, processes may be started at any time.

  These are highly efficient, as if a process is ready to run and the processor is free, it starts immediately

  BUT hard to meet deadlines - a process may be ready to run, but need to wait for another process that is already running.

  #inline("Priorities and preemptive scheduling")

  When a task is added to the ready queue a scheduling event choses the #emph("highest priority") task that is ready.

  A scheduling event may also occur a result of a clock interrupt (to ensure fairness among high priority events).

  #inline("Watchdog timers")

  Watchdog timers ensure that other tasks make sufficient progress

  They run periodically with the #emph("highest") priority

  #inline("Interrupt-driven systems")

  An *interrupt* is the invocation of a task by the hardware.

  The software task is called an *interrupt handler*

  Interrupt handlers can be considered as normal tasks with higher priority than normal software tasks

  The hardware can be programmed to *mask* interrupts during the execution of an interrupt handler (for mutual exclusion).

  Alternatively, interrupts may have different priorities (and higher priority interrupts may pre-empty lower-priority ones).

  Non-blocking algorithms are preferred for interrupt handling (rather than high-level constructs such as semaphores which have a lot of overhead)

  #inline("Priority inversion")

  A high-priority task blocks on entry to a critical section when a lower-priority task which has been preempted is already in the critical section (the critical section should be short so this is not really a problem)

  A #emph("much bigger problem") arises when the low-priority tasks is preempted by a medium-priority task (the medium-level tasks may take a long time to complete)

  #image("priority inversion example.png")

  #inline("Priority ceiling locking")

  Priority inversion can be caused by tasks waiting on the queue of a monitor:
  - a low-priority tasks with access to the monitor might be preempted by a task with medium-level priority, while a tasks with high-level priority waits on the queue.

  On a single-CPU system, a #emph("ceiling priority") can be associated with the monitor:
  - the ceiling priority a higher that of all tasks that can access the monitor
  - when a task calls a monitor operation, it inherits this ceiling priority

  This prevents priority inversion, and also implements mutual exclusion for monitors (without need for additional statements!)

  #inline("Scheduling algorithsm")

  The rate monotonic (RM) algorithm:
  - the fixed priorities assigned in inverse order of periods of execution
  - in example, $P_1$'s period is shorter, so $P_1$ receives the highest priority

  The earliest deadline (first) EDF algorithm:
  - dynamic assignment of priorities
  - assigns highest priority of task with closest deadline
  - if it feasible to schedule (preemptable) tasks, EDF is feasible
    - feasible if processor utilisation is less than or equal to 1, that is:
    #align(center)[$sum_i(e_i/p_i) <= 1$]

  - *BUT* some tasks may have fixed priorities, and imposes overhead on the scheduler.


  #inline("Schedule in the Real World")

  Often, schedules may target different goals:
  - Maximum #emph()[throughput];
  - Minimise #emph()[wait time];
  - Minimise #emph()[latency];
  - Maximise #emph()[fairness];
  - ... and possibly many more.
])


= NICE TO HAVE

== Linked List Code<linked-list>
// ADD ALL THE LINKED LIST CODE
#smallcaps[ReentrantLock]:
  
  ```java
  public class CoarseList<T> {
    private Node<T> head;
    private Lock lock = new ReentrantLock();
    public CoarseList() {
      head = new Node<T>(Integer.MIN_VALUE);
      head.next = new Node<T>(Integer.MAX_VALUE);
    }
    ... // add, remove and contains methods
  }
  ```

== Distribute

The algorithms (RA) (RAT)

== Real time
#image("image (2).png")


== Deckers Proofs
#concept-block(body: [
  #image("Dekker1.png")
  #image("Dekker2.png")
  #image("Dekker3.png")
  #image("Dekker4.png")
  #image("Dekker5.png")
])