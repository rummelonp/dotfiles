### Directory

setopt auto_cd           # Auto changes to a directory without typing cd.
setopt auto_pushd        # Push the old directory onto the stack on cd.
setopt pushd_ignore_dups # Do not store duplicates in the stack.
setopt pushd_silent      # Do not print the directory stack after pushd or popd.
setopt pushd_to_home     # Push to home directory when no argument is given.
setopt cdable_vars       # Change directory to a path stored in a variable.
setopt auto_name_dirs    # Auto add variable-stored paths to ~ list.
setopt multios           # Write to multiple descriptors.
setopt extended_glob     # Use extended globbing syntax.
unsetopt clobber         # Do not overwrite existing files with > and >>.
                         # Use >! and >>! to bypass.
