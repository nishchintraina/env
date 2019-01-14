#!/bin/bash
THISDIR=$(dirname "$0")
source ${THISDIR}/../utils/common.shlib

SSHD_KEYGEN=$(which ssh-keygen)

if [ -z "${SSHD_KEYGEN}" ]; then
  echo "ssh-keygen not found. Check installation"
  exit 1
fi

generate_key() {
  local f=$1

  echo "Checking Public/Private key pair: ${f}"
  if [ ! -e ${f} ]; then
    echo "Public/Private key pair doesn't exist. Generating."
    ${SSHD_KEYGEN} -t rsa -b 4096 -C "nishchint@protonmail.ch" -f "${f}" -N ""
  else
    echo "Public key already exists. Skipping."
  fi
}

generate_key ~/.ssh/id_rsa
generate_key ~/.ssh/id_rsa_github
link ~/.ssh/config ${THISDIR}/config
