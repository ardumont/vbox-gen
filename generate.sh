#!/bin/bash

usage(){
 echo "usage : "
  echo
  echo "$0 [list-templates | install-run|define boxname isotmpl |build boxname|export boxname|add boxname]  boxname isotemplate" 
  echo
  echo "$#  $@"
  exit 1
}

define_box(){
    echo "Defining basebox $1 from $2"
    echo 
    vagrant basebox define "$1" "$2"
}

build_box(){
   echo
   echo "Building basebox $1"
   echo
   vagrant basebox  build "$1"
}

export_to_vagrant(){
   echo
   echo "Building basebox $1"
   echo
   vagrant basebox  export "$1"
}

add_vagrant_box(){
   echo
   echo "Adding $1 box to Vagrant"
   echo
   vagrant box add "$1" "${1}.box"
}

init_box(){
   echo
   echo "Initializing $1 box"
   vagrant init "$1"
}

vagrant_up(){
   echo
   echo "Lunching $1 with vagrant"
   vagrant up
}

vagrant_ssh(){
   echo
   echo "Connecting to $BOX_NAME using ssh"
   vagrant ssh
}

create_box_and_connect(){
   define_box "$1" "$2"
   echo
   build_box "$1"
   echo
   export_to_vagrant "$1"
   echo
   add_vagrant_box "$1" "${1}.box"
   echo
   init_box "$1"
   echo
   vagrant_up
   echo
   vagrant_ssh
}

available_templates(){
  vagrant basebox templates
}
check_args(){
     if [ $# -ne 1 -o $# -ne 2 ]; then
       usage
     fi
}

case $1 in
   list-templates )
     available_templates ;;

   install-run )
       shift 1
       check_args $@
       BOX_NAME=$1
       TEMPLATE_NAME=$2
       create_box_and_connect "$BOX_NAME" "$TEMPLATE_NAME"
   ;;
   define )
       shift 1
#       check_args $@ 
       BOX_NAME=$1
       TEMPLATE_NAME=$2
       define_box "$BOX_NAME" "$TEMPLATE_NAME"
    ;;
   build )
       shift 1
     #  check_args $@
       BOX_NAME=$1
       build_box "$BOX_NAME"
    ;;
   export )
       shift 1
       BOX_NAME=$1
       export_to_vagrant "$BOX_NAME"
    ;;
   add )
       shift 1
       #check_args $@
       BOX_NAME=$1
       add_vagrant_box "$BOX_NAME"
    ;;
   ssh )
    ;;
   *)
     usage
esac

