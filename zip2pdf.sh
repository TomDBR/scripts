#!/bin/bash
# manga2pdf.sh: shell script to convert zipped manga chapters to pdf files
# usage: ./manga2pdf.sh <path to manga folder>
manga=`echo $@"/" | sed 's/\/\/$/\//g'`
echo "Mangafolder is $manga"
shopt -s extglob
	for f in "$manga"*.zip
	do
	    echo "### f is $f"
	    mkdir -p "$manga".temp/
	    echo "### unzipping $f"
	    unzip -q "$f" -d "$manga.temp/"
	    echo "### Checking if the images are in a subfolder"
	    num=`ls "$manga.temp/" | wc -l`
	    if [ $num -eq 1 ] 
	    then
		    echo "### Images are in a subfolder"
	            folderName=`ls "$manga.temp/" | head -n 1`
		    echo "folderName is $folderName"
 	    	    img2pdf --output "$f.pdf" -sA4 --viewer-magnification fith "$manga.temp/$folderName/"**@(.png|.jpg)
	    else
		    echo "### converting images in $manga.temp/"
		    img2pdf --output "$f.pdf" -sA4 --viewer-magnification fith "$manga.temp/"**@(.png|.jpg)
	    fi
	    rm -rv "$manga.temp/"
	    temp="`echo $f | sed 's/.\{4\}$//'`"
	    mv "$f.pdf" "$temp.pdf" 
	    rm "$f"
	done
#fi
