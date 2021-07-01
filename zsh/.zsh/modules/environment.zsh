#
# Sets general shell options and defines environment variables
#

### Smart URLs ###
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

### Options ###

# Changing directories
setopt auto_cd              # Auto changes to a directory without typing cd.
setopt auto_pushd           # Push the old directory onto the stack on cd.
setopt cdable_vars          # Change directory to a path stored in a variable.
setopt pushd_ignore_dups    # Do not store duplicates in the stack.
setopt pushd_silent         # Do not print the directory stack after pushd or popd.
setopt pushd_to_home        # Push to home directory when no argument is given.
setopt auto_name_dirs       # Auto add variable-stored paths to ~ list.

# Expansion and globbing
setopt numeric_glob_sort    # Sort the filenames numerically rather than lexicographically.
setopt brace_ccl            # Allow brace character class list expansion.
setopt extended_glob        # Use extended globbing syntax.

# IO
setopt interactive_comments # Turns on interactive comments.
setopt path_dirs            # Perform path search even on command names with slashes.
setopt rc_quotes            # Allow 'Henry''s Garage' instead of 'Henry'\''s Garage'.
unsetopt clobber            # Do not overwrite existing files with > and >>.
                            # Use >! and >>! to bypass.
unsetopt mail_warning       # Don't print a warning message if a mail file has been accessed.

# Job control
setopt auto_resume          # Attempt to resume existing job before creating a new process.
setopt long_list_jobs       # List jobs in the long format by default.
setopt notify               # Report status of background jobs immediately.
unsetopt bg_nice            # Don't run all background jobs at a lower priority.
unsetopt check_jobs         # Don't report on jobs when shell exit.
unsetopt hup                # Don't kill jobs on shell exit.

# Script and functions
setopt multios              # Write to multiple descriptors.

# Zle
setopt combining_chars      # Combine zero-length punctuation characters (accents)
