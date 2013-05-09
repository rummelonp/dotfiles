## Function

function stats() {
    history -n 1 | \
        awk '{CMD[$1]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' | \
        grep -v "./" | \
        column -c3 -s " " -t | \
        sort -nr | \
        nl | \
        head -n20
}

function take() {
    mkdir -p $1
    cd $1
}

function encode64 {
    echo -n $1 | base64
}

function decode64 {
    echo -n $1 | base64 -D
}
