



# DGCALC

Modular development system (MDS) with support for C, C++, and Fortran, via Kitware's [CMake](https://cmake.org/) build tool, 
along with a small set of computational libraries that demo MDS development. 

> We call it a **modular development system** (MDS) because it lacks all features of a full-blown **package management system** (PMS). 
> However, an MDS has features similar to a PMS, and can be thought of as a lightweight or "featherweight" PMS.

## Getting Started

Clone the repository along with submodules
```bash
git clone --recurse-submodules https://github.com/DGCALC/DGCALC.git
```
The MDS needs to know the location of these files in your environment. 
You have a few options to get past this.
- You can place the root directory for the package in your `$HOME`, as in `$HOME/DGCALC`.
- You can set an environment variable `DGCALC_HOME` equal to the location you wish to place DGCALC.
For example, add to your shell environment `rc` file (e.g., `.bashrc`)
```bash
export DGCALC_HOME="/some/path/DGCALC"
```
You may need to close and reopen a terminal window for this change to take effect, or execute a `src` command.
- You can set `LOCAL_HOME` in your user-facing CMake file `CMakelists.txt`. We recommend one of the previous two options.

Then you are done.

If you wish to use the `dgcalcclt` command line tool (to aid with common tasks) then add the `bin` directory to your path:
```bash
$PATH="$PATH:$DGCALC_HOME/bin"
export $PATH
# optional, for ease of typing commands
alias dg=dgcalcclt
```
We prefer `dg` over `dgcalcclt` but the command can be modified if necessary 
for the user's system environment. 

### TL;DR

If you want a basic setup quickly, make these modifications to your environment:
```bash
# DGCALC STUFF:
export DGCALC_HOME="/some/path/DGCALC"
$PATH="$PATH:$DGCALC_HOME/bin"
alias dg=dgcalcclt
```
Then re-source your terminal with something like:
```bash
src /.bashrc
```
Then, remember to keep all your groups in the same directory with the DGCALC home directory, to avoid any further fuss:
```text
.                          
├── DGCALC/                     
├── MYGROUP/       
├── ANOTHERGROUP/                             
 ...etc.
```
After that, you can pass on to more interesting things. 

## Foundations: Groups and Projects

Like all software, the MDS works by following rules and using abstractions. 
At this time,`DGCALC` is an MDS, but it is also a group of software projects. 
That is, from its own perspective, `DGCALC` is itself an example of a set or cluster of "projects". 
We can call such a cluster a **group** and refer to their elements as **projects**. 
These two concepts are the foundation of this particular MDS.

But what *is* a group? One idea is that projects in a group are more likely depend upon one another, 
or to combine together to form a whole. Or, alternatively, they 
could be designed around a theme, such as a problem domain, a development team, 
a long term goal, etc. A group can exist for any of these reasons. The only constant is that it is always something larger than an individual project.
Preferably, a project is something that can't be decomposed any further (heralding the UNIX concept of composability).
The MDS allows projects to evolve independently, and for changes to projects 
to be immediately visible to daughter projects. A group is useful as an organizational concept on top of projects, 
but it is much less rigidly defined, other than simply saying that it is a collection of projects. 

Putting it all somewhat differently, for the MDS, a project is ideally something that can be 
very accurately described using only one or (at most) two sentences.
Whereas a group is something that exists, and with time can be understood to exist,
but cannot be described using only one or two sentences, 
except in vague generality. 
This is obviously different from how the terms "project" and "group" are commonly used.
In particular, what we call a group in the MDS context is often called a "project" in ordinary conversation, 
and these "projects" typically end up involving many "subprojects" or "tasks" or "tasklets", 
since humans tend to be overly optimistic when they initially carve up work. 

With that discussion out of the way, we stick to the terms "project" and "group" from now on. 

You, the user, are able to call into different software that you have 
under development, by telling DGCALC that you want to use *this* project 
from *this* group, and (optionally) *this* version or branch of that project. In a nutshell, that is what the MDS is there to allow you to do. 
You are able to do this without any internet connection - it is all done via purely local operations.

## Minimal project structure

A project X has a structure that minimally: 
- exposes the working code to any project which depends on X.
- Allows X to be tested without introducing test code or test support code into any project which depends on X.
- Allows X to be documented. 
- Allows X to be compiled as a library.

Minimally, the project tree must look like this:
```text
X/                                  # project root
├── ...                             # User code and artifacts
├── share/                          # Core application source code
│   ├── static/                     # location for a static library compilation target
│   └── lib/                        # location for a shared library compilation target
└── wrk/                            # worktree root
      ├── latest/                   # The default work tree, "latest" 
      │   ├── CMakelists.txt        # User-facing CMake file
      │   ├── main.c                # main file (for testing, not part of 'package' or library code, aka the "test bench") 
      │   └── pkg/                  # package root
      │       ├── inc/              # header code root
      │       │   └── ...           # User code (header code)
      │       └── src/              # source code root
      │           └── ...           # User code (source code)
      │
      └── ...                       # User code (other work trees)
```
DGCALC tries to be a working, functional MDS, while being agnostic about the payload. 
However, there are rules that facilitate project interoperability and modularity. 

Group and project identifiers should be compatible with directory naming conventions used for decades in UNIX. 
Informally, they should be "standard" names, using nothing nonstandard. 
The project root must have the form `X`, where `X` is the identifier (the name) chosen for the project.
The name `main` must be used for the main top level file for the test bench. The ending is `.c` in the case of the C language.
For C++, file endings `.cpp`, `.cc` are both supported, as well as `.cu` for CUDA files. 
Typically, the project `X` is included into daughter projects via `X/some_file.h`, 
but this is not strictly enforced; all that really happens is the header code root `inc` is included in daughter projects.
Finally, the directory names `wrk`, `src`, `inc`, `pkg`, `share`, `static`, `lib`, `latest` must be used as shown above.
These establish the consistent skeletal outline of a project structure. 
Other than these rules, there are no conditions set by DGCALC for the project format. 
The rest is all completely up to the user. 

Unless, that is, we forgot something.

## Typical Project Structure

In practice, there are common artifacts and needs for all projects, 
and users will generally fall into some habitually generated structure that they feel comfortable with. 
Here is one example, used in DGCALC submodules, for illustration. 
```text
X/                                  # project root
├── doc/                            # Documentation
├── share/                          # Core application source code
│   ├── static/                     # location for a static library compilation target
│   └── lib/                        # location for a shared library compilation target
└── wrk/                            # worktree root
      ├── latest/                   # The default work tree, "latest"
      │   ├── .git/                 # The git repository
      │   ├── .gitignore            # .gitignore file
      │   ├── _F/                   # Files (legal and community documents)      
      │   ├── _I/                   # Integration testing root
      │   │   ├── I.h               # integration test header
      │   │   ├── Ibasis.h          # globally exposed header for integration tests
      │   │   └── ...               # User code (integration tests)
      │   ├── _T/                   # Unit testing root
      │   │   ├── T.h               # unit test header
      │   │   ├── Tbasis.h          # globally exposed header for unit tests
      │   │   └── ...               # User code (unit tests)
      │   ├── CMakelists.txt        # User-facing CMake file
      │   ├── main.c                # main file (for testing, not part of project) 
      │   ├── README.md             # readable markdown project description file  
      │   └── pkg/                  # package root
      │       ├── inc/              # header code root
      │       │   └── ...           # User code (header code)
      │       └── src/              # source code root
      │           └── ...           # User code (source code)
      └── stable                    # A stable version of the project maintained by `git worktree`
```

Commonly, `git` is used for version management, and the usual `git` project rules are then applied.
This can be thought of as just another layer on top of DGCALC and CMake. 

Another convention used in DGCALC is that a group is capitalized, as in  `MYGROUP`, 
whereas a project is either lower case `myproject`, upper camel-case `MyProject`, camel-case `myProject`, or snake case `my_project` (preferably, one of the first two). 
Again, this is only a convention. 

## The user-facing CMake file

The format of the user-facing CMake file `CMakeLists.txt` is a set of definitions that the user has available. 
Then work is passed off to DGCALC's `cmake` scripts. Once this is well established, the system has many advantages. The main advantage is that code can remain *in situ* in its testing workspace, while simultaneously being reused across any number of daughter projects. 
All changes made to the package code (during testing, or during usage) will instantaneously exist in the project code, 
whose version management is typically managed by `git`, but can be managed by another VCS. 

### Minimal User-facing CMake file

You can create a blank project with 
```bash
dg new myproject
```
This generates the "minimal project structure" in the directory where you run the file - this should be a "group" directory, say, `MYGROUP`, 
if you want `myproject` to belong to `MYGROUP`. 
You can use the `DGCALC` group if you wish, or do this in any directory on your system if you're just going to delete the files when you finish:
```bash
# delete the project
-rm -rf myproject_project
```
The only reason you would work in a chosen group is if you actually want other projects to link to your project. Otherwise, it does not matter where you put it. 
The choice is never set in stone.
If you ever want to move the project to a different group, just `mv` the project over to that group (drag and drop the folder to the other group folder).

Then in the directory `wrk/latest` you will see a generic `CMakeLists.txt` file that looks like this:
```cmake
cmake_minimum_required(VERSION 3.24)
set(PROJECT_LANGUAGES "CXX")
set(CMAKE_C_STANDARD 99)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_FORTRAN_STANDARD 90)
set(PROJECT_FAMILY_NAME "DGCALC")
set(PROJECT_VERSION "1.0.0")
set(PROJECT_VERSION_NAME "DataBoundary")
set(PROJECT_VERSION_MONTH "September")
set(PROJECT_VERSION_YEAR "2026")
set(PROJECT_WORKING_RDIRS "_T" "_I")
# Release, Debug
set(PROJECT_BUILD_TYPE Debug)
set(ACCEL "") # "Cuda", "Metal", "" (none)
set(ACCEL_DEPENDENCIES "") # cuBLAS, cuRAND, ...
set(ACCEL_INSTALL_DIR "/usr/local") # /usr/local, $ENV{CUDA_HOME}, $ENV{METAL_HOME}, ...
set(DEPENDENCY_LIB_TYPE "s") # shared (s) or static (a)
set(DGCALC_DEPENDENCY_TEST "")
set(DGCALC_DEPENDENCY_SRC ${DGCALC_DEPENDENCY_TEST} "")
set(DGCALC_DEPENDENCY_LIB "")

include($ENV{DGCALC_HOME}/src/dgcalc.1.cmake)
set(PROJECT_NAME "${PROJECT_FAMILY_NAME}${PROJECT_VERSION}${PROJECT_VERSION_NAME}_${PROJECT_VERSION_MONTH}${PROJECT_VERSION_YEAR}")
project(${PROJECT_NAME} VERSION ${PROJECT_VERSION} LANGUAGES ${PROJECT_LANGUAGES})
include($ENV{DGCALC_HOME}/src/dgcalc.2.cmake)
```

This is not intended to look like something perfect, but instead like something you can edit. 
You can, by all means, edit this file to suit your needs. 

> We used the command line tool `dg new X` to create this file and demo the process, 
> but `dg new X` does not provide a lot of the most useful structure that arises in practice, 
> as you'll find out for yourself. 
> In fact, all that `dg new X` does it execute `mkdir` and `cp` a handful of times; you can 
> see precisely what it does if you open the file `$DGCALC_HOME/bin/dgcalcclt`. 
> Its value is only in laying bare the minimal strucure DGCALC requires, to provide a constructive picture of a DGCALC project. 
> Once you have projects you are already working on, the easiest way to start a new project is probably to copy one of your recent projects 
> and modify it, which can be done manually in a few seconds.

To make this blank file into the CMake file for `myproject`, the first step is to change the `PROJECT_FAMILY_NAME` to `myproject`.
Next, choose a version number to begin from as your project develops.
You can write the version as either a standard three-integer representation `"<major>.<minor>.<patch>"` or in a three-digit code `"mnp"`,
where the three integers `m` major, `n` minor, and `p` patch number are concatenated.
The latter format is for legacy support. The former format is recommended.

Also choose a version name, `PROJECT_VERSION_NAME`,
this helps facilitate changes to the project over time, particularly when the number of projects grows large. 
Change the `PROJECT_VERSION_MONTH` to the current month,
and the `PROJECT_CURRENT_YEAR` to the current year.

You should also change the language to the target language or languages, and set the version you wish to use. 

After this, you can start building your project, writing tests, and running them from 
your test bench (the file `main.c`). 

TODO: link to more demoing.

### Typical User-facing CMake file

A typical user-facing CMake file may look like the following example, used in the recent `CSRiemann` project, 
part of the `GEOMESH` group that the author has recently created.
```cmake
cmake_minimum_required(VERSION 3.24)
set(PROJECT_LANGUAGES "CXX" "Fortran")
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_FORTRAN_STANDARD 90)
#set(CMAKE_FORTRAN_STANDARD_REQUIRED ON)
# fixed form, C preprocessed, all REAL as double
set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -ffixed-form -cpp -fdefault-real-8")
set(PROJECT_FAMILY_NAME "CSRiemann")
set(PROJECT_VERSION "040")
set(PROJECT_VERSION_NAME "NashvilleDolly")
set(PROJECT_VERSION_MONTH "September")
set(PROJECT_VERSION_YEAR "2026")
set(PROJECT_WORKING_RDIRS "_T" "_I")
set(ACCEL "") # "Cuda", "Metal", "" (none)
set(ACCEL_DEPENDENCIES "") # cuBLAS, cuRAND, ...
set(ACCEL_INSTALL_DIR "/usr/local") # /usr/local, $ENV{CUDA_HOME}, $ENV{METAL_HOME}, ...
set(DEPENDENCY_LIB_TYPE "s") # shared (s) or static (a)
set(DGCALC_DEPENDENCY_TEST "")
set(DGCALC_DEPENDENCY_SRC ${DGCALC_DEPENDENCY_TEST} "Base" "Types" "Kyte" "Kabbage" "Scalar" "Tennsix" "Fields")
set(DGCALC_DEPENDENCY_LIB "")
set(GROUPS "GEOMESH")
set(GEOMESH_DEPENDENCY_TEST "")
set(GEOMESH_DEPENDENCY_SRC ${GEOMESH_DEPENDENCY_TEST} "Kiwi")
set(GEOMESH_DEPENDENCY_LIB "CubeSphere")

set(NUM_PROCESSES 6)

#set(PROGRAM_ARGS "")
#set(OUTPUT_STDOUT_FILE)
#set(OUTPUT_STDOUT_TERMINAL)

include($ENV{DGCALC_HOME}/src/dgcalc.1.cmake)
set(PROJECT_NAME "${PROJECT_FAMILY_NAME}${PROJECT_VERSION}${PROJECT_VERSION_NAME}_${PROJECT_VERSION_MONTH}${PROJECT_VERSION_YEAR}")
project(${PROJECT_NAME} VERSION ${PROJECT_VERSION} LANGUAGES ${PROJECT_LANGUAGES})
include($ENV{DGCALC_HOME}/src/dgcalc.2.cmake)
```
This user-facing CMake file does the following (we go through it line by line):
- Defines the minimum version of CMake (3.24)
- sets the project languages (C++ and Fortran)
- sets the language standards used (20 and 90)
- defines the project name, `CSRiemann`, the project version, `040`, and some other naming artifacts,
- Defines a couple of *working rdirs*, called `_T` and `_I`, which will be visible in `main`, but only when working in the project, not in daughter projects. Typically, this functionality is for your testing code and testing support.
In our experience, *you will always need tests*, there is no other reality.
- Sets some parameters for accelerators (hardware features)
- Defines dependencies exposed locally by the MDS: the group `DGCALC` (this group), and the group `GEOMESH` (case sensitive).
- Sets a variable `NUM_PROCESSES`. When this variable is set, the project will be compiled as MPI parallel, otherwise, it will be compiled as a serial program. The value of `NUM_PROCESSES` is the number of MPI tasks (the number of parallel processes to run). 
- Commented out are several options for run behavior: program arguments (can be passed in the string), 
and where to route output (to standard out, to a file). The default behavior sends output to standard out and standard error pipes. If you set both `OUTPUT_STDOUT_FILE` and `OUTPUT_STDOUT_TERMINAL`, then both routes are used.

The remainder of the lines in the file is boilerplate that defines the project and links the project to the MDS scripting. 


## Build Targets 

Using the DGCALC MDS, you have several targets that you can run via CMake.
- The project itself can be built and run as a serial program, in either `Debug` or `Release` modes. 
- The project X can be compiled as a static library by choosing the target `X`. Once this is done, downstream projects can easily establish a dependency on the project via the static library.
- The project can be compiled as a shared library by choosing the target `X<version>` (to find this target, run `dg what`). Once this is done, downstream projects can easily establish a dependency on the project via the shared library.
- Parallelization via MPI is possible. Individual systems and users may require configuration, but once this is finished the MPI support is very easy to use. 
The MPI library can be selected, and the program can be run via `dg run` (the `runbin` target), which bins output to the `OUTPUT_STEM` subfolder. 
This is what is typically done, because parallel programs usually need to produce output in the file system and can rarely rely on standard output and error pipes. `runbin` will "bin" the output in a directory that the user can select (default: `output`). 
This is recommended because it allows the run output directory to be cleaned between runs. (Which it is.)

## Usage at the command line

The MDS provides streamlined use of CMake to build projects. 
This is needed because some changes to projects (moved, removed, or renamed files) require 
any daughter project to be reconfigured (to reset the cache CMake uses to speed up the build). 
Running compiled code can also be streamlined via CMake. 
These three operations (configure, build, run) can all be executed at the command line using the `dgcalcclt` tool, which we alias as `dg`.
```bash
cd /some/path/GROUP/X_project/wrk/latest
# configure the project
dg conf
# build the project
dg make 
# run the project and bin the file system output in `output` directory. 
dg run
```
The command `run` is short for the target `runbin` which runs and bins output in a folder. 
You can also do `dg runhere` to produce output in the working directory. 
To instead run the job with the current directory as working directory, you can invoke `dg runhere`.
NOTE: The directory `output` is cleaned automatically between runs.
You can change the directory name by setting the variable `OUTPUT_STEM` to `data`, `out`, `data_run507`, or anything you choose, 
by editing the user-facing CMake file.

Projects that have specific targets defined can be run selecting different targets. 
You can do experiment on the command line using the `what` command:
```bash
dg what
# prints a list of available targets, including some_target
dg make some_target
# see what some_target does
```
None of these operations perform anything extremely complicated; most of the work is performed by Kitware's CMake build tool, and really uses only a small fraction of CMake's capabilities. 
Individual contributions by users who wish to improve these tools are most welcome. 

> The DGCALC system is not as sensitive to the full build tree (including all daughter projects) as other build systems you may have used. 
> If files are re-named, moved, or deleted in a project X while you work on a daughter project of X, 
> then you will need to reconfigure the daughter project to see the changes. This operation is performed by `dg conf` or by executing 
> ```bash
> cmake -B <builddir> -S . --fresh
> ```
> in the project's working directory (usually `wrk/latest`).

## Usage in IDEs

### CLion

The DGCALC MDS is compatible with the CLion IDE. 
You can execute the `dg` CLT in a terminal window, or you can run your program via the friendly 'build' and 'run' buttons.
You can select targets other than the main one by opening the run configuration drop-down menu and making a selection. 
The GUI operation to perform the `dg conf` operation (a fresh cmake configure), 
you can go to the CMake pane, and inside the context menu of the Gear/Cogwheel icon, select Reset Cache and Reload Project. 
Or, it is found in the menu bar under Tools > CMake > Reset Cache and Reload Project.

### VSCode

If you use DGCALC in VSCode, and would like to help us out, please update this file with some documentation and submit a pull request.  

## Work Tree

The work tree of the project is in the directory `/wrk`. 
In this folder, it is possible to have different instances of the project. 
This service is provided by `git` via `git worktree`. 
The DGCALC user can select one of the branches of a project, say, `branch1` of a project called `X`,  
by pointing the daughter project to `X:branch1`. 

## DGCALC submodule dependency chart

At this time, DGCALC ships with several projects that can be thought of as a basic set of 
examples, although they do useful things. The dependencies among DGCALC projects, where each line represents a project 
that depends on at least one project in the previous line, 
but no projects in the same line or any projects in lower lines is:
```
{Base}
{Kyte}
{Types}
{Scalar, Kabbage}
{Tennsix}
```
Here are informal descriptions of these projects: 
- Base is a small basket of all-encompassing (mainly) compile-time resources. 
- Kyte is for industrial strength bit-fiddling. 
- Types is like Base, but for more development of the type system (again, compile-time resources). 
- Types allows dependency on Kyte, and can be thought of as a continuation of Base. 
- Scalar is the master project for scalar classes. 
- Kabbage is a basket of basic algorithms that (1) don't use scalars (2) are needed later, as well as problems that don't require special data structures to describe, e.g., sorting. 
- Tennsix is a project for linear algebra based on Scalar types. 

These projects were created in 2021-2022 and have been almost completely dormant since 2023. 
They are some fundamental parts of larger software projects that are not being released at this time.
Their presence is included here in part to demo/display the MDS, i.e., provide some concrete idea of what's going on with the MDS. 

## Contributing

Contributions from users are greatly appreciated.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/MyFeature`)
3. Commit your Changes (`git commit -m 'Add MyFeature'`)
4. Push to the Branch (`git push origin feature/MyFeature`)
5. Open a Pull Request

There is no plan for active development cycles in DGCALC. Instead, 
the forecast is for DGCALC to exist as a stable MDS utility, "doing what it does forever". 
Therefore we prefer pull requests implement incremental changes and bug fixes. 
Updates or improvements outside of this purview should be made in consultation with maintainers.

We hope that DGCALC permits you, the user, to focus on the most difficult steps of software development,
to understand your software stack, and to make meaningful revisions and analyses of your projects quickly and efficiently.

## License

Distributed under the MIT License. See `_F/LICENSE` for more information.

## Contact

Lucius Schoenbaum - lts0016@uah.edu

## Name (DGCALC)

DGCALC was started in 2020-2021, and became dormant in 2023. 
It is being released in 2026, after some revisions and improvements. 
The name originally stood for: device-gate-circuit-architecture-language-computation. 

