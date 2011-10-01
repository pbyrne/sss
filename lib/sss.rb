require "sss/version"

class SSS
  attr_accessor :command
  attr_accessor :workspace

  HELP = <<-EOH
    SSS performs SCM commands on all projects in your workspace. Set the
    SSS_WORKSPACE environment variable if your workspace is not ~/workspace.

    usage: sss <command>

    Available commands:
      up, update, pull  Update to the latest changes
      st, status        Check the status for any uncommitted changes
      push              (hg, git) Push all committed changes to central repo
      out, outgoing     (hg) Show outgoing changes, not pushed to central repo
      in, incoming      (hg) Show incoming changes, not updated
      wtf               (git) Compare local to tracked remote branch
  EOH

  # SCMs
  GIT = :git
  MERCURIAL = :hg
  SUBVERSION = :svn

  COMMANDS = {
    "status" => {
      GIT => "git status",
      MERCURIAL => "hg status",
      SUBVERSION => "svn status",
    },
    "push" => {
      GIT => "git push",
      MERCURIAL => "hg push",
    },
    "pull" => {
      GIT => "git pull",
      MERCURIAL => "hg pull -u",
      SUBVERSION => "svn up",
    },
    "incoming" => {
      GIT => "git wtf",
      MERCURIAL => "hg incoming",
    },
    "outgoing" => {
      GIT => "git wtf",
      MERCURIAL => "hg outgoing",
    },
    "wtf" => {
      GIT => "git wtf",
    },
  }

  def initialize(command = nil)
    self.command = command
    self.workspace = ENV['SSS_WORKSPACE'] || "~/workspace/"
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
      Dir["#{File.expand_path(workspace)}/*"].map { |dir| File.expand_path(dir) }
    else
      raise ArgumentError, "#{workspace} is not a directory. Please set the WORKSPACE environment variable to the directory containing your projects."
    end
  end

  def perform_command(directory)
    command_for_directory = scm_command_for directory
    if command_for_directory
      display "Performing #{command} in #{directory}"
      stdout, stderr, status = Open3.capture3 command_for_directory
      display stdout
      display stderr, STDERR
    else
      display "Skipping #{directory}, no available command"
    end
  end

  def scm_command_for(directory)
    if COMMANDS[command]
      COMMANDS[command][scm_for(directory)]
    end
  end

  def scm_for(directory)
    if File.exists?("#{directory}/.git")
      GIT
    elsif File.exists?("#{directory}/.hg")
      MERCURIAL
    elsif File.exists?("#{directory}/.svn")
      SUBVERSION
    end
  end

  def display(string, output = STDOUT)
    output.puts string
  end

  def embolden(string)
    "\033[1m#{string}\033[0m"
  end

  def directory_string(directory)
    last_directory = directory.split("/").last
    embolden last_directory
  end

  def display_command
    "Attempting to perform #{command}"
  end
end
