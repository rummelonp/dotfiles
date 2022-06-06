#
# Android
#

function adb_mult() {
    for device in $(adb devices | sed '1,1d' | awk '{ print $1 }'); do
        typeset cmd="adb -s $device $*"
        echo "$cmd"
        eval "$cmd"
    done
}
compdef _adb adb_mult
