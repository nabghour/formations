#!/bin/bash
ls -l
bash ./formations/build-ci.sh -o pdf -t osones -u http://osones.com/revealjs
tree
echo "DISPLAY PDF"
ls pdf/

