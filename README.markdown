SSS performs SCM commands on all projects in your workspace. Set the
SSS_WORKSPACE environment variable if your workspace is not ~/workspace.

Uusage:
  sss COMMAND

Commands:
  pull, up, update  Update to the latest changes
  status, st        Check the status for any uncommitted changes
  push              (git, hg) Push all committed changes to central repo
  out, outgoing     (git, hg) Show outgoing changes, not pushed to central repo
  in, incoming      (git, hg) Show incoming changes, not updated
  wtf               (git) Compare local to tracked remote branch
