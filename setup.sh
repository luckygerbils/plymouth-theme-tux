#!/bin/sh

INSTALL_DIRECTORY=/usr/share/plymouth/themes/tux

rm -r $INSTALL_DIRECTORY
install -d $INSTALL_DIRECTORY
install theme/* $INSTALL_DIRECTORY
