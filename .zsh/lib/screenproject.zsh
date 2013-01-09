## Screen Project

function screenproject() {
    local edit
    typeset -a projects

    if [ $#SCREENPROJECT_HOME -eq 0 ]; then
        SCREENPROJECT_HOME=$HOME/.screen/project
        if [ -f $SCREENPROJECT_HOME ]; then
        else
            mkdir -p $SCREENPROJECT_HOME
        fi
    fi

    help() {
        echo 'Usage: screenproject <project> ...          # open projects'
        echo '       screenproject --edit (-e) <project>  # edit or create project file'
        echo '       screenproject --list (-l)            # show projects list'
        echo '       screenproject --help (-h)            # show help'
    }

    project-list() {
        if [ -d $SCREENPROJECT_HOME ]; then
            ls -1 $SCREENPROJECT_HOME | \
                grep \.conf$ | \
                sed -e 's/\.conf$//g'
        fi
    }

    edit-project() {
        if (( $#1 > 0 )); then
            local conf="$SCREENPROJECT_HOME/$1.conf"
            $EDITOR $conf
        else
            echo "Please specify project"
        fi
    }

    open-project() {
        local conf="$SCREENPROJECT_HOME/$1.conf"
        if [ -f $conf ]; then
            screen -X source $conf
        else
            echo "Invalid project \"$1\""
        fi
    }

    while [ $1 ]; do
        case $1 in
            -h|--help)
                help
                return
                ;;
            -l|--list)
                project-list
                return
                ;;
            -e|--edit)
                edit=true
                ;;
            *)
                projects=($projects[*] $1)
                ;;
        esac
        shift
    done

    if [ $edit ]; then
        edit-project ${projects[1]}
        return
    fi

    if (( $#projects == 0 )); then
        help
        return
    fi

    for project in $projects; do
        open-project $project
    done
}

alias p=screenproject

function __screenproject_projects() {
    typeset -a projects
    projects=($(screenproject --list))
    compadd $@ $projects
}

function _screenproject() {
    _arguments \
        '*:projects:__screenproject_projects' \
        {-e,--edit}'[edit or create project]' \
        '(: -)'{-l,--list}'[show projects list]' \
        '(: -)'{-h,--help}'[show help]'
}

compdef _screenproject screenproject p
