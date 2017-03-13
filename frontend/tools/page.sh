#/bin/bash

# Add View

lower () {
 	echo $1 | perl -ne 'print lc(join("-", split(/(?=[A-Z])/)))'
}


templates="./templates"

echo "\\r\\n"

if [ "$1" = "" ]
	then
    echo "!!! Enter [PageName]"
    echo "\\r\\n"
    exit 1
fi

name=$1
page_path="./../app/pages/$(lower $name)"

if [ -d $page_path ]
	then
		echo "!!! $page_path allready exist"
		echo "\\r\\n"
		exit 1
	else
    mkdir -p $page_path
fi

template_path="$page_path/$(lower $name).pug"

if [ ! -f $template_path ]
	then
		cat $templates/page/index.pug | sed "s/\[pageName\]/$name/g" | sed "s/\[pagename\]/$(lower $name)/g" > $template_path
			
		echo ">> $template_path created"
		echo "\\r\\n"
fi


controller_path="$page_path/$(lower $name).coffee"

if [ ! -f $controller_path ]
	then
		cat $templates/page/controller.coffee | sed "s/\[pageName\]/$name/g" | sed "s/\[pagename\]/$(lower $name)/g" > $controller_path
		echo ">> $controller_path created"
		echo "\\r\\n"

fi


directive_path="$page_path/$(lower $name).directives.coffee"

if [ ! -f $directive_path ]
	then
		cat $templates/page/directive.coffee | sed "s/\[pageName\]/$name/g" | sed "s/\[pagename\]/$(lower $name)/g" > $directive_path
		echo ">> $directive_path created"
		echo "\\r\\n"
fi


router_path="$page_path/$(lower $name).router.coffee"

if [ ! -f $router_path ]
	then
		cat $templates/page/router.coffee | sed "s/\[pageName\]/$name/g" | sed "s/\[pagename\]/$(lower $name)/g"> $router_path
		echo ">> $router_path created"
		echo "\\r\\n"
fi

styl_path="$page_path/$(lower $name).styl"

if [ ! -f $styl_path ]
	then
		cat $templates/page/index.styl | sed "s/\[pageName\]/$name/g" | sed "s/\[pagename\]/$(lower $name)/g" > $styl_path
		echo ">> $styl_path created"
		echo "\\r\\n"
fi


echo "\\r\\n"
echo ">> Page $name created"
echo "\\r\\n"
exit 1

