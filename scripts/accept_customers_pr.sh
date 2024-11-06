#!/usr/bin/env bash

# run the below command to allow this script to be run
# chmod +x customer_prs.sh

# this script will clone a remote branch of a customers pr and then push a branch with the same name to the repo
# takes 1 parameter of gituhub username and branch separated by a :
# ex run :
# ./customer_prs.sh ashishdhingra:user/ashdhin/IssueTemplateRegressionCheckbox

sdk_list=(
	"awslabs/aws-c-http"
	#"awslabs/aws-crt-java"
	#"awslabs/aws-crt-builder"
)

# output success/failures in a csv
filename=customer_prs.csv
# headers for csv
echo repo, status > $filename

# split parameter into github username and branch name
IFS=':' read -r username branchname <<< "$1"

for i in ${!sdk_list[@]}; do
	echo "Repo:" ${sdk_list[$i]}
	# get sdk name
	full_sdk=${sdk_list[$i]}
	IFS='/' read -ra temp <<< "$full_sdk"
	sdk=${temp[1]}
	outputstring=$full_sdk,

	if [ ! -d ${sdk} ]; then
		echo "Cloning https://github.com/${full_sdk}.git"
		git clone --depth 1 --no-checkout "git@github.com:${full_sdk}.git"
		cd "${sdk}"

		git remote add $username "git@github.com:${username}/${sdk}.git"
		output=$(git fetch $username $branchname 2>&1 | grep "fatal")sub

		if ! grep "fatal" <<< "${output}" ; then
			git checkout $branchname
			git push origin $branchname

			echo "success pushing branch"
			outputstring+="success pushing commit"
		else
			echo "failed finding customer remote branch:" $output
			outputstring+=$output
		fi

		cd ..
		rm -rf $sdk
	else
		echo "${sdk[$i]} already exists"
		outputstring+="${sdk[$i]} already exists"
	fi
	echo $outputstring >> $filename

done
