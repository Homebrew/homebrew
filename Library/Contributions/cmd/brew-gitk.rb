require "cmd/log"

args = Homebrew::LogCommand.find_args

# Calling 'gitk' directly doesn't open Wish in the foreground, so we use
# 'open' instead. This requires us to set the following env variables, because
# Wish.app doesn't inherit our current working directory.
toplevel = `git rev-parse --show-toplevel`.chomp
ENV["GIT_DIR"] = "#{toplevel}/.git"
ENV["GIT_WORK_TREE"] = toplevel
system "open",
       "/System/Library/Frameworks/Tk.framework/Resources/Wish.app",
       "--args",
       `which gitk`.chomp,
       *args
