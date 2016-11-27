#! /usr/bin/env bash

function header()   { echo -e "\n\033[1m$@\033[0m"; }
function success()  { echo -e " \033[1;32m==>\033[0m  $@"; }
function error()    { echo -e " \033[1;31mX\033[0m  $@"; }
function arrow()    { echo -e " \033[1;34m==>\033[0m  $@"; }
function warning()  { echo -e " \033[0;93m==>\033[0m  $@"; }

__SCRIPT_VERSION="0.0.1"
__SCRIPT_NAME=$( basename $0 )
__DESCRIPTION="Compile sh script into one single script"
__OPTIONS=":hvb:d:o:"

BUILD=build
DIST=dist
OUTFILE=a.out



usage_head() {
  echo -e "Usage:\n\n $0  main_file_script.sh "
}
usage ()
{
cat <<EOF
$(usage_head)

    $__DESCRIPTION

    Options:
      -h|help       Display this message
      -v|version    Display script version
      -b            Build dir
      -d            Dist dir


    This program is maintained by Alejandro Gallo.
EOF
}    # ----------  end of function usage  ----------

while getopts $__OPTIONS opt; do
  case $opt in

  h|help     )  usage; exit 0   ;;

  v|version  )  echo "$__SCRIPT_NAME -- Version $__SCRIPT_VERSION"; exit 0   ;;

  b  )  BUILD=${OPTARG};;

  d  )  DIST=${OPTARG};;

  o  )  OUTFILE=${OPTARG};;

  * )  echo -e "\n  Option does not exist : $OPTARG\n"
      usage_head; exit 1   ;;

  esac    # --- end of case ---
done
shift $(($OPTIND-1))

import_command='include'

if [[ -z $1 ]]; then
  error "Please provide the main file of your script"
  usage
  exit 1
fi

main_file=$1
main_file_dir=$(dirname ${main_file})


header "Creatind directories"
mkdir -p ${BUILD}
mkdir -p ${DIST}

header "Testing if sourced files exist"

MAIN_IMPORTED_FILES=( $(sed -n "s/${import_command}\s\+\(.*\)/\1/pg" ${main_file}))


for file in ${MAIN_IMPORTED_FILES[@]}; do
  arrow ${file}
  if [[ -f ${main_file_dir}/${file} ]]; then
    success "Found"
  else
    error "Not found!"
    exit 1
  fi
done


header "Building"

let count=0
in_file="${main_file}"

for file in ${MAIN_IMPORTED_FILES[@]}; do

  arrow "Processing ${file}"

  let count+=1
  out_file="${BUILD}/main_${count}"

  file_path="${main_file_dir}/${file}"

  sed  "
/${import_command}\s\+${file}/ {
    r ${file_path}
    d
  }
    " ${in_file} > ${out_file}

  in_file=${out_file}

done

header "Creating ${DIST}/${OUTFILE}"

mv ${out_file} ${DIST}/${OUTFILE}

chmod +x ${DIST}/${OUTFILE}

#vim-run: bash % src/main.sh
