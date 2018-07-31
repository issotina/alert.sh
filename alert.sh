#!/usr/bin/env bash

# Alert.sh by Shadai ALI <nafiouali@gmail.com>
# Usage : _alert.sh -p <project_name> -s <build_status: Int> -t <alert_sh_token> -l <your_app_link>

# this program need curl to run
NEED_CURL=false

# Backend server adrress
# this server is responsible to handle http get requests and tranform
# its to desktop notification for displaying to end users
SERVER_ADDR="http://localhost:3000/"
_CMD_CURL_START="curl -s -o /dev/null -I -w \"%{http_code}\"  --request GET --url "$SERVER_ADDR

if ! [ -x "$(command -v curl)" ]; then
	echo 'Error: curl is not installed.' >&2
	NEED_CURL=true
fi

#if [ $NEED_CURL == true ]; then
# detect host and install usign apriopriate package manager
# TODO
#	NEED_CURL=false
#fi

# exit program if can't install curl

# build status is provided by external environnement
# and is used to choose notification badge
# possible value 0 = failed [default], 1 = succes , 2 = unknow.
while getopts ":s:t:p:l:" option; do
	case "${option}" in
	s)
		BUILD_STATUS=${OPTARG}
		;;
	t)
		BROWSER_TOKEN=${OPTARG}
		;;
	p)
		PROJECT_NAME=${OPTARG}
		;;
	l)
		APP_LINK=${OPTARG}
		;;
	esac
done

# browser token is unique and provided by alert.sh homepage
# so this script need this token to know whom alert otherwise
# it should crash

shift $((OPTIND - 1))
if [ -z "${BROWSER_TOKEN}" ]; then
	echo "Error : browser token should be specify"
	exit 1
fi

if [ -z "${BUILD_STATUS}" ]; then
	echo "Error : build status should be specify"
	exit 1
fi

# Define nice icons and text for make notification pretty
# Before overwrite this text or icons url, make sure you
# respects the following rules :
#   1 - text and url must be in url format
#   2 - Icon is hosted and be aivalable via internet (no specific resolution)
#   3 - New icons should be more pretty than pass (LOL)
badge=("https%3A%2F%2Ffirebasestorage.googleapis.com%2Fv0%2Fb%2Fproject-1977852810792332962.appspot.com%2Fo%2Ficons8-cancel-480.png%3Falt%3Dmedia%26token%3D0b8b1f2a-1a8c-4c81-8329-227f19c6d706"
	"https%3A%2F%2Ffirebasestorage.googleapis.com%2Fv0%2Fb%2Fproject-1977852810792332962.appspot.com%2Fo%2Ficons8-ok-480.png%3Falt%3Dmedia%26token%3Dded9b093-c1ed-44ba-84ac-e129493ee943"
	"https%3A%2F%2Ffirebasestorage.googleapis.com%2Fv0%2Fb%2Fproject-1977852810792332962.appspot.com%2Fo%2Ficons8-help-480.png%3Falt%3Dmedia%26token%3D72b5a598-ff36-4bb7-b3bc-1e762dcae31b")
status=("Sorry%20It%20Failed" "Awesome%20It%20Pass" "Euhh%20Come%20to%20see")

# based on status get right icon for notification alert
case "$BUILD_STATUS" in
0) # job failed
	_BADGE=${badge[0]}
	_STATUS=${status[0]}
	;;
1) # job is ok
	_BADGE=${badge[1]}
	_STATUS=${status[1]}
	;;
*) # -----
	_BADGE=${badge[2]}
	_STATUS=${status[2]}
	;;
esac

# Generate curl command to request backend server
_CMD="$_CMD_CURL_START?id=$BROWSER_TOKEN&title=$PROJECT_NAME&body=$_STATUS&iconUrl=$_BADGE&link=$APP_LINK"
_STATUS=$($_CMD)

# control request status
if [[ $_STATUS == "\"200\"" ]]; then
	echo "!!!alerted!!!"
	exit 0
else
	# TODO () send email to user and tell him that his token is NOK
	echo "###Can't send alert###"
	echo "###Action : verify your token or generate new one###"
	exit 1
fi
