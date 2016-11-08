#!/bin/bash
ls -l
bash ./formations/build-ci.sh -o pdf -t osones -u http://osones.com/revealjs
ls -lR
echo "DISPLAY PDF"
ls pdf/

