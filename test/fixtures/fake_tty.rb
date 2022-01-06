# A hacky 'ruleset' file which forces an externally run
# mdl instance to believe it's in a TTY, used for testing.
def $stdout.tty?
  true
end
