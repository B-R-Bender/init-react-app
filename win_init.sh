#!/bin/bash
#Init script to create react app default directory structure

version="0.1.0"

home="~"
path="/"
name="react-app"

cra=false
rewrite=false
echo=false

props="./script.properties"
scriptDir="$PWD"

#TODO: Echo version

echo "--- React app initialization starts ---"

echo "--- Init starts---"

#Process properties
if [ -s "$props" ]; then
  echo "Properties file found ($props)"

  while IFS='=' read -r key value
  do
#    key=$(echo $key | tr '.' '_')
    if [ ! -n "$key" ]; then
        continue
    fi
    eval ${key}=\${value}
  done < "$props"
else
  echo "Properties file not found ($props)"
fi

#Process params
while [ -n "$1" ]
do
	case "$1" in
		-H) home=$2 ; shift;;
		-d) path=$2 ; shift;;
		-N) name=$2 ; shift;;
		-R) rewrite=true;;
		-C) cra=true;;
		-E) echo=true;;
		-*) echo "Unknown param $1, ignoring";;
	esac
	shift
done

#Required params checkout
if [ -z "$name" ]; then
	echo "Project name do not set"
	exit 1
fi

#Print params
echo
echo "Specified params is: "
echo "home    = " ${home}
echo "path    = " ${path}
echo "name    = " ${name}
echo "cra     = " ${cra}
echo "rewrite = " ${rewrite}
echo
read -p "Everything is correct (y/n)?" correct

if [ ! ${correct} == "y" ]; then
    echo "Wrong params, aborting"
    exit 1
fi

if ${echo}; then
    exit 0
fi

#Start from check for npm and create-react-app
if ${cra}; then
    #Check for NPM
    if [ -x "$(command -v npm)" ]; then
        echo "NPM found, using $(npm --v) version"
    else
        echo "NPM not found. Aborting (install NPM first)"; exit 1;
    fi

    #Check for create-react-app
    if [ -x "$(command -v create-react-app)" ]; then
        echo "create-react-app found, using $(create-react-app -V) version"
    else
        read -p "create-react-app do not found, install? (y/n)" answer
        if [ ${answer} = "y" ]; then
            $(npm i -save create-react-app)
        else
            ${cra} = false
            echo "Processing without create-react-app"
        fi
    fi
fi

echo "--- Init ends---"

#Init app using create-react-app
if ${cra}; then
    echo "create-react-app choose to init app, processing"
    eval cd ${home}${path}
    if ${rewrite}; then
        rm -rf ${name}
    fi
    eval create-react-app ${name}
    eval cd ${home}${path}${name}
    eval npm install prop-types react-router history
    read -p "Add materialize-ui (y/n)?" mui
    read -p "Add redux (y/n)?" redux
    if [ ${mui} == "y" ]; then
        eval npm install @material-ui/core @material-ui/icons
    fi
    if [ ${redux} == "y" ]; then
        eval npm install redux react-redux redux-thunk redux-devtools-extension
    fi
fi

echo "--- Default directory structure init starts ---"

#cd to project directory
eval cd $home$path$name || { echo "Aborting"; exit 1; }

#Creating structure
if [ ! -d src ]; then
	echo "Source directory not found. Creating source directory under $name"
	mkdir src
fi

cd src

if ${rewrite}; then
	echo "Rewrite set to true, clearing src..."
	rm -fr *
fi

#Creating app structure
mkdir components
mkdir config
mkdir constants
mkdir resources
mkdir routes
mkdir screens
if [ "${redux}" == "y" ]; then
    mkdir store
fi

#Creating app routes
cp ${scriptDir}/redux_template/routes/index.js routes/index.js

#Creating app store
if [ "${redux}" == "y" ]; then
    cp ${scriptDir}/redux_template/store/index.js store/index.js
    cp ${scriptDir}/redux_template/store/main.reducer.js store/main.reducer.js
    cp ${scriptDir}/redux_template/store/middleware.js store/middleware.js
fi

#Creating app entry point
cp ${scriptDir}/redux_template/index.css index.css
if [ "${redux}" == "y" ]; then
    cp ${scriptDir}/redux_template/index.js index.js
else
    cp ${scriptDir}/simple_template/index.js index.js
fi

echo --- Default directory structure init end ---

echo --- React app initialization ends ---