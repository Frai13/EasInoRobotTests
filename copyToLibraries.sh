#!/bin/bash

rm -rf /root/Arduino/libraries/EasIno/
mkdir /root/Arduino/libraries/EasIno/
mkdir /root/Arduino/libraries/EasIno/src/
mkdir /root/Arduino/libraries/EasIno/examples/

cp ../EasIno/src/* /root/Arduino/libraries/EasIno/src/
cp -r ../EasIno/examples/* /root/Arduino/libraries/EasIno/examples/
cp ../EasIno/keywords.txt /root/Arduino/libraries/EasIno/
cp ../EasIno/library.properties /root/Arduino/libraries/EasIno/
