
### VisualVM vs JConsole

 If you prefer the simpler display and time span features of JConsole, make that your primary tool for JVM Performance. If you like snapshots and need to determine exactly which function call is most responsible for excessive memory consumption or CPU time, go with 
 
Available in default installation

Monitoring the java process

## Monitor Tab

## Threads

VisualVM monitors the same metrics as JConsole, however it doesn’t feature a timespan filter. It does provide a better breakdown of activity, in particular the used heap vs. heap size while the application is running. Additionally, a heap dump can be taken at any time to provide a snaphot of the VM and OS information.

The Threads tab provides a running timeline showing all the threads color coded by state and the Thread Dump feature is more detailed than JConsole.

Perhaps the selling feature of VisualVM is the profiler contained in the Sampler tab. By sampling either the CPU or Memory, anyone can view the generated snapshot containing the breakdown of CPU or Memory by class and method to determine the bottleneck of any java application. Particularly useful are the collapsible call trees that show much time is taken sampling the CPU.
