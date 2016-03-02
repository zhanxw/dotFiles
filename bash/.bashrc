# Xiaowei Zhan personalized profile

alias ls='ls --color'
alias rm='rm -i'
alias nheader='tail -n +2'
alias noheader='tail -n +2'
alias less='less -R'
alias du1='du --max-depth=1 '
alias makedbg='make OPTFLAG="-ggdb -O0"'
alias makerelease='make OPTFLAG="-O4 -DNDEBUG"'
alias ls-ltr='ls -ltr'
alias nf="awk '{print NF;}'"
alias ltail='ls -ltr |tail'
alias lessns='less -nS'
alias ct='column -t'

alias Rv='R --vanilla'
alias Rvv='R -d "valgrind --tool=memcheck --leak-check=full" --vanilla'

alias diff='diff -W $(( $(tput cols) - 2 ))'
alias noheader='grep -v "^#"'

## handle $DISPLAY
alias sds='echo $DISPLAY > ~/.DISPLAY'
alias lds='export DISPLAY=`cat ~/.DISPLAY`'

alias ..="cd .."
alias ..2="cd ../.."
alias ..3="cd ../../.."
alias ..4="cd ../../../.."
alias ..5="cd ../../../../.."

alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

alias cd..="cd .."
alias cd...="cd ../.."
alias cd....="cd ../../.."
alias cd.....="cd ../../../.."
alias cd......="cd ../../../../.."

shopt -s cdspell

export HISTSIZE=450 
export HISTFILESIZE=450
export HISTCONTROL=ignoredups

LD_LIBRARY_PATH=$HOME/usr/lib:$LD_LIBRARY_PATH
export LD_RUN_PATH=$LD_RUN_PATH:$LD_LIBRARY_PATH
export LIBRARY_PATH=$LD_LIBRARY_PATH
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$HOME/usr/lib/pkgconfig

CFLAGS="-I${HOME}/usr/include"
CXXFLAGS="-I${HOME}/usr/include"
LDFLAGS="-L${HOME}/usr/lib -L${HOME}/usr/lib64"
export CFLAGS
export CXXFLAGS
export LDFLAGS


function getCurrentPath()
{
    if [ "$PWD" != "$LPWD" ];then LPWD="$PWD"; tmux rename-window ${PWD//*\//}; fi 
}
##export PROMPT_COMMAND=f;


#export PS1="\[\e[36;1m\]\u@\[\e[32;1m\]\H> \[\e[0m\]"
#export PS1="\[\e[36;1m\]\u@\[\e[31;1m\]\H: \[\e[32;40m\]\w> \[\e[0m\]"
##For more colors, check http://tldp.org/HOWTO/Bash-Prompt-HOWTO/x329.html
LightCyan="\e[36;1m"
LightRed="\e[31;1m"
LightGreen="\e[32;40m"
########       light_cyan      light_red       light_green&no_backgroun
### customize PS1
### http://www.terminally-incoherent.com/blog/2013/01/14/whats-in-your-bash-prompt/
##-ANSI-COLOR-CODES-##
Color_Off="\033[0m"
###-Regular-###
Red="\033[31m"
Green="\033[32m"
Purple="\033[35m"
####-Bold-####
BRed="\033[1;31m"
BPurple="\033[1;35m"
# set up command prompt
function __prompt_command()
{
    # capture the exit status of the last command
    EXIT="$?"
    PS1=""
 
    if [ $EXIT -eq 0 ]; then PS1+="\[$Green\][\!]\[$Color_Off\] "; else PS1+="\[$Red\][\!]\[$Color_Off\] "; fi
 
    # # if logged in via ssh shows the ip of the client
    # if [ -n "$SSH_CLIENT" ]; then PS1+="\[$Yellow\]("${SSH_CLIENT%% *}")\[$Color_Off\]"; fi
 
    # debian chroot stuff (take it or leave it)
    PS1+="${debian_chroot:+($debian_chroot)}"
 
    # basic information (user@host:path)
    PS1+="\[$LightCyan\]\u@\[$Color_Off\]\[$LightRed\]\h\[$Color_Off\]: \[$LightGreen\]\w\[$Color_Off\]"
 
    # check if inside git repo
    local git_status="`git status -unormal 2>&1`"    
    if ! [[ "$git_status" =~ Not\ a\ git\ repo ]]; then
        # parse the porcelain output of git status
        if [[ "$git_status" =~ nothing\ to\ commit ]]; then
            local Color_On=$Green
        elif [[ "$git_status" =~ nothing\ added\ to\ commit\ but\ untracked\ files\ present ]]; then
            local Color_On=$Purple
        else
            local Color_On=$Red
        fi
 
        if [[ "$git_status" =~ On\ branch\ ([^[:space:]]+) ]]; then
            branch=${BASH_REMATCH[1]}
        else
            # Detached HEAD. (branch=HEAD is a faster alternative.)
            branch="(`git describe --all --contains --abbrev=4 HEAD 2> /dev/null || echo HEAD`)"
        fi
 
        # add the result to prompt
        PS1+=" \[${Color_On}\][${branch}]\[${Color_Off}\] "
    fi
 
    # prompt $ or # for root
    PS1+="\[${LightGreen}\]> \[${Color_Off}\]"
    
    # set application title
    if [ "$TERM" != "dumb" ]; then
        echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"
    fi
    # set screen title
    if [ "$TERM" == "screen" ]; then
        # set screen title
        ## P=${PWD/$HOME/'~'}  substitute home directory to to '~'
        if [ "$PWD" != "$HOME" ]; then
            mytitle=${PWD##*/} # get directory name
        else
            mytitle='~'
        fi
        echo -ne '\033k'$mytitle'\033\\'
    fi
}
PROMPT_COMMAND=__prompt_command

function calc () {
    awk "BEGIN { print $* ; }"
}

function bce() {
  echo "scale=3; $@" |bc
}

function calcfx () {
    gawk -v CONVFMT="%12.2f" -v OFMT="%.9g"  "BEGIN { print $* ; }"
}

# enhanced cd, only need to type partial directory names
function cdh()
{  
    if [ $# = 0 ]; then
       cd
    else
        case $1 in
        .)  echo "you are already in " ;;
        ..) thisdir=`pwd`
            prevdir=`dirname $thisdir`
            cd $prevdir ;;
        *)  counter=`ls -l | grep "^d.*$1" |awk '{print $8}' |wc -l`
            counter=`expr $counter + 0`
            echo
            case $counter in
            1)  cd `ls --color=never | grep "$1"`
                pwd ;;
            0)  if test -d $1
                then cd $1
                else echo "no such directory"
                fi ;;
            *)  echo "the options are"
                for i in *$1*
                do test -d $i && echo "$i"
                done ;;
            esac ;;  
        esac
    fi
}



# convert a man page to pdf format, and then call "Preview" to see it
# from a tip from MacWorld: http://www.macworld.com/article/54155/2006/12/manpages.html
pman()
{
    PMANFILE="/tmp/pman-${1}.pdf"
    if [ ! -e $PMANFILE ]; then   # only create if it doesn't already exist
        man -t "${1}" | pstopdf -i -o "$PMANFILE"
    fi
    if [ -e $PMANFILE ]; then     # in case create failed
        open -a /Applications/Preview.app/ "$PMANFILE"
    fi
}


## set up title for GNU screen
case $TERM in
    screen*)
    # This is the escape sequence ESC k \w ESC
    # Use current dir as the title
        SCREENTITLE='\[\ek\W\e\\\]'
        PS1="${SCREENTITLE}${PS1}"
        ;;
    *)
        ;;
esac


function gt2geno(){
    sed -e 's:0/0:0:g' -e 's:0/1:1:g' -e 's:1/0:1:g' -e 's:1/1:2:g' \
        -e 's:0|0:0:g' -e 's:0|1:1:g' -e 's:1|0:1:g' -e 's:1|1:2:g'
}

function pipUpgrade() {
  pip freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs pip install -U
}


# git quick color diff
function gqcdiff() {
  git difftool -y -x "colordiff -y -W $COLUMNS" HEAD^ HEAD| less -R
}

# run per-project npm
function npm-exec {
   $(npm bin)/$@  
}

## clean up variables
# Deduplicate path variables
get_var () {
    eval "echo \$$1"
}
set_var () {
    eval "$1=\"$2\""
}
dedup_pathvar () {
    pathvar_name="$1"
    pathvar_value="$(get_var $pathvar_name)"
    deduped_path="$(echo $pathvar_value | perl -e 'print join(":",grep { not $seen{$_}++ } split(/:/, scalar <>))')"
    set_var $pathvar_name "$deduped_path"
}
dedup_pathvar PATH
dedup_pathvar MANPATH
dedup_pathvar LD_LIBRARY_PATH
dedup_pathvar LIBRARY_PATH
