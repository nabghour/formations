#!/bin/bash
formations/build.sh -o pdf -t osones -u http://formations.osones.com/revealjs
cp -r formations/output-pdf/* pdf/
