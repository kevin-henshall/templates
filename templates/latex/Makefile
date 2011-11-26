TEX_FILE=document
TEX_OUTPUT=build

all : ${TEX_FILE}.pdf

${TEX_FILE}.pdf : ${TEX_FILE}.tex
	mkdir -p ${TEX_OUTPUT}
	pdflatex -output-directory=${TEX_OUTPUT} ${TEX_FILE}

clean :
	rm -r ${TEX_OUTPUT}
