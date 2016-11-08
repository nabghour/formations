#!/bin/bash

COURS_DIR=formations/cours
IMG_DIR=formations/images
STYLE_DIR=formations/styles
LIST=formations/cours.list
OUTPUT_HTML_DIR=formations/output-html

TITLE=""
DATE=""

build-html() {
  mkdir -p $OUTPUT_HTML_DIR/revealjs/css/theme
  mkdir -p $OUTPUT_HTML_DIR/images

  cp "$STYLE_DIR"/"$THEME".css "$OUTPUT_HTML_DIR"/revealjs/css/theme/"$THEME".css
  cp -r "$IMG_DIR"/* "$OUTPUT_HTML_DIR"/images/

  while IFS=$ read cours titre modules; do
    for module in $modules; do
      cat $COURS_DIR/$module >> $COURS_DIR/slide-$cours
    done
    TITLE=$titre

    # Header2 are only usefull for beamer, they need to be replaced with Header3 for revealjs interpretation
    sed 's/^## /### /' $COURS_DIR/slide-$cours > tmp_slide-$cours
    mv tmp_slide-$cours $COURS_DIR/slide-$cours
    echo "Build $TITLE"
    pandoc --standalone --template=formations/templates/template.revealjs --slide-level 3 -V theme=$THEME -V navigation=frame -V revealjs-url=$REVEALJSURL -V slideNumber=true -V title="$TITLE" -V institute=Osones -o $OUTPUT_HTML_DIR/"$cours".html $COURS_DIR/slide-$cours
    rm -f $COURS_DIR/slide-$cours
  done < $LIST
}

build-pdf() {
  for cours in $(cut -d$ -f1 $LIST); do
    wkhtmltopdf -O landscape -s A5 -T 0 file://bucket-formations/html/"$cours".html\?print-pdf ../pdf/"$cours".pdf
  done
}

display_help() {
  cat <<EOF

  USAGE : $0 options

    -o output           Output format (html or pdf). If none, all outputs
                        are built

    -t theme            Theme to use, default to osones

    -u revealjsURL      RevealJS URL that need to be use. If you build formation
                        supports on local environment you should use "." and git
                        clone http://github.com/hakimel/reveal.js and put your
                        index.html into the repository clone.
                        This option is also necessary even if you only want PDF
                        output (default : https://osones.com/revealjs)

    -c course           Courses to build, if not specified all courses are built

EOF

exit 0
}

while getopts ":o:t:u:c:h" OPT; do
    case $OPT in
        h) display_help ;;
        c) COURSE="$OPTARG";;
        o) OUTPUT="$OPTARG";;
        t) THEME="$OPTARG";;
        u) REVEALJSURL="$OPTARG";;
        ?)
            echo "Invalid option: -$OPTARG" >&2
            display_help
            exit 1
            ;;
    esac
done

[[ $REVEALJSURL == "" ]] &&  REVEALJSURL="https://osones.com/revealjs"
if [[ $THEME == "" ]]; then
  THEME="osones"
else
  ls "$STYLE_DIR"/"$THEME".css
  ls "$STYLE_DIR"/"$THEME".css &> /dev/null
  [ $? -eq 2 ] && echo "Theme $THEME doesn't exist" && exit 1
fi

if [[ $COURSE != "" ]]; then
  grep $COURSE $LIST > cours.list.tmp
  [ $? -eq 1 ] && echo "Course $COURSE doesn't exist, please refer to cours.list" && exit 1
  LIST=cours.list.tmp
fi

if [[ ! $OUTPUT =~ html|pdf ]]; then
    echo "Invalid option: either html, pdf" >&2
    display_help
    exit 1
elif [[ $OUTPUT == "html" ]]; then
    build-html
elif [[ $OUTPUT == "pdf"  ]]; then
    build-pdf
fi
rm -f cours.list.tmp
