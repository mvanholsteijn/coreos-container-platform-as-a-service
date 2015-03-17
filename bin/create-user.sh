#!/bin/bash

if [ $# -lt 1 -o $# -gt 2 ] ; then
	echo 'Usage: create-user user-name [ group-name ]' >&2
	exit 1
fi

username="$(echo "$1" | sed -e 's/^\(.\).*/\1/' | tr '[:lower:]' '[:upper:]')$(echo "$1" | sed -e 's/^.\(.*\)/\1/' | tr '[:upper:]' '[:lower:]')"
aws iam create-user --user-name "$username"
aws iam  create-login-profile --user-name "$username" --password "${username}2015!" --password-reset-required
if [ $# -eq 2 ] ; then
	aws iam add-user-to-group --user-name "$username" --group-name "$2"
fi
