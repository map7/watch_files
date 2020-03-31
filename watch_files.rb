#!/usr/bin/env ruby

require 'rb-inotify'

@notifier = INotify::Notifier.new

# Note: rb-inotify doesn't need to be in a thread, as soon as you setup your watch
# it is watching the directory. Then at the end you can process all the files which
# have gone in there after your actions.
@notifier.watch("/home/tram/work/clt", :moved_to, :create) do |file|
  puts file.name
end

@notifier.run

