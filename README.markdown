# SSS

The `simple-scm` gem provides the `sss` (Simple SCM Service) command to
iterate over your Git, Mercurial, and Subversion projects to pull the
latest changes, show you their status, and more.

## Installation

SSS is simple to install using RubyGems.

    gem install simple-scm

SSS iterates over the directories in ~/workspace/ for your checked-out
projects. You can change this with the SSS_WORKSPACE environment
variable, like so for Bash:

    export SSS_WORKSPACE=~/projects/

## Usage

    sss COMMAND

### Commands

* **pull, up, update**  Update to the latest changes
* **status, st**        Check the status for any uncommitted changes
* **push**              (git, hg) Push all committed changes to central repo
* **out, outgoing**     (git, hg) Show outgoing changes, not pushed to central repo
* **in, incoming**      (git, hg) Show incoming changes, not updated
* **wtf**               (git) Compare local to tracked remote branch

For git, the `out`, `in`, and `wtf` commands require the [git-wtf plugin]

[git-wtf plugin]: http://git-wt-commit.rubyforge.org/#git-wtf
