#!/bin/bash
## deploy.sh for Deploy
##
## Made by mg
## Login   <mg@gonnet.tv>
##
##

# ----------------------------------------- #
# Mandatory vars (can be overrided by args)

#TODO : add option in cmdline
MOUNTPOINT=/mnt/deploy
STEPS_DIR=$PWD/steps
SUDO=sudo
# ----------------------------------------- #

SCRIPT_NAME=$(basename -- "$0")
function usage(){
        cat <<EOF
Usage: $SCRIPT_NAME [options] <TARGET>
        -h|--help)
EOF
    exit 1;
}

TEMP=`getopt -o h --long help      -n 'example.bash' -- "$@"`

if [ $? != 0 ] ; then echo "Terminating..." >&2 ; exit 1 ; fi

eval set -- "$TEMP"

while true ; do
    case "$1" in
        -h|--help) usage; shift ;;
        --) shift ; break ;;
        *) echo "Internal error!" ; exit 1 ;;
    esac
done
echo "-- $SCRIPT_NAME Begin $(date +"%F %T") ------"

TARGET=$1
if [ $2 ] ; then
    CONFIG=$2
else
    CONFIG=$(echo $TARGET | sed 's/raw/cfg/g')
fi

echo "TARGET="$TARGET >> $CONFIG
echo "MOUNTPOINT="$MOUNTPOINT >> $CONFIG

STEPS=$(ls $STEPS_DIR)

for script in $STEPS;
do
    $SUDO $script $CONFIG
done