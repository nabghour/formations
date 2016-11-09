#!/bin/bash
bash ./formations/build-ci.sh -o html -t osones -u https://osones.com/revealjs
cp -r ./formations/output-html/* html/
