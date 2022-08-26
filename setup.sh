#!/usr/bin/env bash

set -e

show_usage() {
  echo "Usage: $(basename $0) takes exactly 1 argument (install | uninstall)"
}

if [ $# -ne 1 ]
then
  show_usage
  exit 1
fi

check_env() {
  if [[ -z "${APM_TMP_DIR}" ]]; then
    echo "APM_TMP_DIR is not set"
    exit 1
  
  elif [[ -z "${APM_PKG_INSTALL_DIR}" ]]; then
    echo "APM_PKG_INSTALL_DIR is not set"
    exit 1
  
  elif [[ -z "${APM_PKG_BIN_DIR}" ]]; then
    echo "APM_PKG_BIN_DIR is not set"
    exit 1
  fi
}

install() {
  wget https://github.com/xpack-dev-tools/openocd-xpack/releases/download/v0.11.0-4/xpack-openocd-0.11.0-4-linux-x64.tar.gz -O $APM_TMP_DIR/xpack-openocd-0.11.0-4-linux-x64.tar.gz
  tar xf $APM_TMP_DIR/xpack-openocd-0.11.0-4-linux-x64.tar.gz -C $APM_PKG_INSTALL_DIR/
  rm $APM_TMP_DIR/xpack-openocd-0.11.0-4-linux-x64.tar.gz
  ln -s $APM_PKG_INSTALL_DIR/xpack-openocd-0.11.0-4/bin/openocd $APM_PKG_BIN_DIR/openocd
}

uninstall() {
  rm -rf $APM_PKG_INSTALL_DIR/*
  rm $APM_PKG_BIN_DIR/openocd
}

run() {
  if [[ "$1" == "install" ]]; then 
    install
  elif [[ "$1" == "uninstall" ]]; then 
    uninstall
  else
    show_usage
  fi
}

check_env
run $1