#!/bin/bash
ls -l
ls -lR bucket-formations/
bash ./formations/build-ci.sh -o pdf -t osones -u http://osones.com/revealjs
ls pdf/

