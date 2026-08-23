#!/bin/bash
THISDIR=$(dirname "$0")
source ${THISDIR}/../utils/common.shlib

link ~/.tmux.conf ${THISDIR}/.tmux.conf
