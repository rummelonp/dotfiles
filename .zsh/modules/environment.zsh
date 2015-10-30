### Environment

## Smart URLs
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

## General
setopt brace_ccl        # Allow brace character class list expansion.
setopt combining_chars  # Combine zero-length punctuation characters (accents)
setopt rc_quotes        # Allow 'Henry''s Garage' instead of 'Henry'\''s Garage'.
unsetopt mail_warning   # Don't print a warning message if a mail file has been accessed.

## Jobs
setopt long_list_jobs   # List jobs in the long format by default.
setopt auto_resume      # Attempt to resume existing job before creating a new process.
setopt notify           # Report status of background jobs immediately.
unsetopt bg_nice        # Don't run all background jobs at a lower priority.
unsetopt hup            # Don't kill jobs on shell exit.
unsetopt check_jobs     # Don't report on jobs when shell exit.
