#!/usr/bin/env ruby

require 'rb-inotify'
require 'fileutils'
require 'byebug'

@notifier = INotify::Notifier.new

USER = "t100"
GROUP = "tram"
DIR = "/home/tram/work/clt"

# Note: rb-inotify doesn't need to be in a thread, as soon as you setup your watch
# it is watching the directory. Then at the end you can process all the files which
# have gone in there after your actions.
@notifier.watch(DIR, :recursive, :moved_to, :create) do |file|
  puts "Changing permissions of #{file.absolute_name}"

  if File.file?(file.absolute_name)
    FileUtils.chmod "g=rw,o=", file.absolute_name, verbose: true
    FileUtils.chown nil, GROUP, file.absolute_name, verbose: true
  else
    `chown :tram -R #{file.absolute_name}`
    `chmod g+x #{file.absolute_name}`
    `chmod -R g+w #{file.absolute_name}`
  end
end

@notifier.run
