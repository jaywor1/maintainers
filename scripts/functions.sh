ok(){
  echo -e "[  \033[1;32mO.K\033[0m  ]: $1"
}

err(){
  echo -e "[ \033[1;31mERROR\033[0m ]: $1"
  return -1
}

log(){
  echo -e "[  \033[1;33mLOG\033[0m  ]: $1"
}

