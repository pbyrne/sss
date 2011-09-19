require "sss/version"

module SSS
  HELP = <<-EOH
    SSS performs SCM commands on all projects in your workspace. Set the
    SHARED_WORKSPACE environment variable if your workspace is not ~/workspace.

    usage: sss <command>

    Available commands:
      up, update, pull  Update to the latest changes
      st, status        Check the status for any uncommitted changes
      push              (hg, git) Push all committed changes to central repo
      out, outgoing     (hg) Show outgoing changes, not pushed to central repo
      in, incoming      (hg) Show incoming changes, not updated
      wtf               (git) Compare local to tracked remote branch
  EOH

  COMMANDS = []

  def self.run(cmd)
    puts display_command(cmd)
    # returning false to trigger displaying help
    true unless display_help?(cmd)
  end

  def self.display_command(cmd)
    "Performing #{cmd}"
  end

  def self.display_help?(cmd)
    %w(help --help).include?(cmd) or cmd.nil? or not COMMANDS.include?(cmd)
  end
end
