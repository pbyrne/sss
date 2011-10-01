require "sss/version"

class SSS
  attr_accessor :command
  attr_accessor :workspace

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

  COMMANDS = %w(
    up
  )

  def initialize(command = nil)
    self.command = command
    self.workspace = ENV['WORKSPACE'] || "~/workspace/"
  end

  def self.run(command)
    new(command).run
  end

  def run
    if COMMANDS.include? command
      directories.each { |directory| perform_command(directory) }
    end
  end

  def directories
    if File.directory? File.expand_path workspace
      Dir["#{workspace}/*"].map { |dir| File.expand_path(dir) }
    else
      raise ArgumentError, "#{workspace} is not a directory. Please set the WORKSPACE environment variable to the directory containing your projects."
    end
  end

  def display_command
    "Attempting to perform #{command}"
  end
end
