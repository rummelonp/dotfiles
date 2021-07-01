#
# Sets general shell options and defines environment variables
#

### Smart URLs ###
autoload -Uz bracketed-paste-url-magic
zle -N bracketed-paste bracketed-paste-url-magic
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

### Options ###

# Changing directories
setopt AUTO_CD              # Auto changes to a directory without typing cd.
setopt AUTO_PUSHD           # Push the old directory onto the stack on cd.
setopt CDABLE_VARS          # Change directory to a path stored in a variable.
setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack.
setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd.
setopt PUSHD_TO_HOME        # Push to home directory when no argument is given.
setopt AUTO_NAME_DIRS       # Auto add variable-stored paths to ~ list.

# Expansion and globbing
setopt NUMERIC_GLOB_SORT    # Sort the filenames numerically rather than lexicographically.
setopt BRACE_CCL            # Allow brace character class list expansion.
setopt EXTENDED_GLOB        # Use extended globbing syntax.

# IO
setopt INTERACTIVE_COMMENTS # Turns on interactive comments.
setopt PATH_DIRS            # Perform path search even on command names with slashes.
setopt RC_QUOTES            # Allow 'Henry''s Garage' instead of 'Henry'\''s Garage'.
unsetopt CLOBBER            # Do not overwrite existing files with > and >>.
                            # Use >! and >>! to bypass.
unsetopt MAIL_WARNING       # Don't print a warning message if a mail file has been accessed.

# Job control
setopt AUTO_RESUME          # Attempt to resume existing job before creating a new process.
setopt LONG_LIST_JOBS       # List jobs in the long format by default.
setopt NOTIFY               # Report status of background jobs immediately.
unsetopt BG_NICE            # Don't run all background jobs at a lower priority.
unsetopt CHECK_JOBS         # Don't report on jobs when shell exit.
unsetopt HUP                # Don't kill jobs on shell exit.

# Script and functions
setopt MULTIOS              # Write to multiple descriptors.

# Zle
setopt COMBINING_CHARS      # Combine zero-length punctuation characters (accents)
