#!/bin/bash
ls -l
ls html/
bash ./formations/build-ci.sh -o pdf -t osones -u http://osones.com/revealjs
ls pdf/

