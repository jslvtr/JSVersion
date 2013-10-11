# .jsv - JSVersion
## Jose Salvatierra Version Control System

### Introduction
Jose Salvatierra Version Control System (from now .jsv or JSVersion) is a Version Control System (from now VCS) programmed in BASH by Jose Salvatierra. It also has an extremely original name.

### Programming
The VCS is made up of various shell scripts, each of which can be executed individually or via a main script that displays a menu.

The folder hierarchy is as follows: there is a folder called `.jsv` inside the folder in which the repository is created. Every time a command is called, this command will look for a `.jsv` folder in all parent folders. If it finds this `.jsv` folder, then we know we are part of a repository initialised in this parent folder. We cannot initialise a new repository inside a folder where one of its parent folders is already a repository.

There are several scripts:
- `init` -- Initialises a repository by creating the hidden `.jsv` folder in the current folder. In any sub-folders to this parent folder it will not be possible to initialise a repository.
- `add` -- Adds a file to be committed. Essentially the file is copied into a sub-folder of the `.jsv` folder inside the parent folder.
- `commit` -- Commits the changes and stores them in a temporary folder inside the hidden `.jsv` folder. It creates a new `diff` file after each commit for each changed file. What this means is that, for example, we can have `somecode.cpp.0` as the first revision, and going all the way up to `somecode.cpp.5`.
- `revert [revision-number]` -- Reverts the current system to a revision number. Revision numbering starts at 0 (the earliest revision). This works by doing `patch` on the latest `diff` file and keeps doing so until the revision number desired is reached.
- `remove` -- Removes a file from the `.jsv` folder inside the parent folder, so as to not commit it next time a commit is called.
