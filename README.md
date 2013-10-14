# JSVersion .jsv
## Running instructions

Initialize a repository in the current folder by running `init.sh`.
Create the repository group and add users to it by running (as sudo) `postinit.sh [groupname] [user1 user2 ...]`
Add files to the repository by doing `add.sh [file1 file2 ...]`
Remove files from the repository by doing `remove.sh [file1 file2 ...]`
Commit the current revision by running `commit.sh`
Revert to a previous commit by running `revert.sh`. You will be prompted what revision to revert to. Only modified files will change, leaving the rest unchanged.
