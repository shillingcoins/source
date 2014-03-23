#!/bin/bash
# create multiresolution windows icon
ICON_SRC=../../src/qt/res/icons/shilling.png
ICON_DST=../../src/qt/res/icons/shilling.ico
convert ${ICON_SRC} -resize 16x16 shilling-16.png
convert ${ICON_SRC} -resize 32x32 shilling-32.png
convert ${ICON_SRC} -resize 48x48 shilling-48.png
convert shilling-16.png shilling-32.png shilling-48.png ${ICON_DST}

