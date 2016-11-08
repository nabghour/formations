#!/bin/bash
ls -l
bash ./formations/build-ci.sh -o pdf -t osones -u http://osones.com/revealjs
find . -name "docker.pdf"
echo "DISPLEY PDF"
ls pdf/

