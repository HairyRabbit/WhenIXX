#!/bin/bash

###
# Config
###
# nodejs lastest version pages
LIBS_PATH=https://nodejs.org/dist/latest/

# download path
DOWNLOAD=~/Downloads/

# usr path
TARGET=/usr/local/

# platform
OS=linux

# return x64 or x86
CPU=64
case $CPU in
    64)
	CPU=x64
	;;
    32)
	CPU=x86
	;;
    *)
	CPU=x64
esac

# log msg
function info() {
    echo
    echo
    echo "------------------------------------------------------------"
    echo
    printf " %*s" `expr 30 - ${#1} / 2`
    echo -e "\033[44m $1 \033[0m"
    echo
    echo "------------------------------------------------------------"
    echo
    
    if [ $2 ]; then
       sleep $2
    fi
}

# main
function -main() {
    info "Check lastest version."
    FILE=`curl $LIBS_PATH | grep $OS | grep $CPU | grep "gz"`
    FILE=${FILE/<a href=/}
    FILE=${FILE/%>*}
    FILE=${FILE/%\"}
    FILE=${FILE/#\"}
    SOURCE=$LIBS_PATH$FILE
    info "Begin download 3s later." 3
    curl $SOURCE -o $DOWNLOAD$FILE
    cd $DOWNLOAD
    info "Download done! Begin decompression 3s later." 3
    tar -xf ${DOWNLOAD}${FILE} -v
    cd ${FILE%%.*}*
    info "Decompression done! Begin copy files 3s later." 3
    sudo cp -r bin/* ${TARGET}bin
    sudo cp -r lib/* ${TARGET}lib
    sudo cp -r include/* ${TARGET}include
    sudo cp -r share/* ${TARGET}share
    info "Copy done!" 3
    echo "node: `node -v`"
    echo "npm: `npm -v`"
    info "Install packages 3s later" 3
    sudo npm install -g bower express-generator grunt-cli gulp --verbose
    info "All Done!"
}

# go
-main
