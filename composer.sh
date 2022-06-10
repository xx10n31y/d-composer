#!/bin/bash
# get all bash script arguments
args=$@
BASE_PATH=$(pwd)
# process --* options
options=$(echo "$args" | grep -P '\-\-\w+(\-\w+)?' -o)

options_size=${#options}
# if options exists
if [ $options_size -gt '0' ];then
    # get install path
    args3=''
    for i in $options;
    do
        args3+="s/$i//g;"
    done
    args4=$(echo $args | sed -e $args3)
else
    d=$(echo $args | grep -P "\-\-(\w+(\-\w+))?" -o)
    if [ ${#d} -gt 0 ];then
        e=''
        for i in $d;
        do
            e+="s/$i//g;"
        done
        args4=$(echo $args | sed -e $e)
    else
        args4=$args
    fi
fi
IS_CREATE_PROJECT=$(echo $args4 | grep 'create-project' -o)

if [ ${#IS_CREATE_PROJECT} -gt '0' ];then
    # create-project
    INSTALL_PATH=$(echo $args4 | awk '{print $3}')
    if [ ${#INSTALL_PATH} -eq '0' ];then
        INSTALL_PATH='laravel'
    fi
    REAL_PATH=$BASE_PATH/$INSTALL_PATH
    if [[ -d "$REAL_PATH" && ! -z "$(ls -A $REAL_PATH)" ]];then
        echo "not empty path"
        exit 1
    fi

    # docker run --rm -it -v "$REAL_PATH:/app" composer/composer $args4
#else
#    docker run --rm -it -v "$BASE_PATH:/app" composer/composer $args4
fi

docker run --rm -it -v "$BASE_PATH:/app" composer/composer $args4

exit 0

