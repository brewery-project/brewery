#!/bin/sh

red="\033[1;31m"
color_end="\033[0m"


if [[ `git diff --cached --check` ]]; then
    echo -e ${red}Commit failed${color_end}
    git diff --cached --check
    exit 1
fi

git stash -q --keep-index

echo "Running tests, be patiient..."
bundle exec rake test
TEST_RESULT=$?

if [ $TEST_RESULT -eq 0 ]; then
	echo "Checking rails compliance..."
	bundle exec rails_best_practices
	BEST_PRACTICES_RESULT=$?
fi

git stash pop -q

if [ $TEST_RESULT -ne 0 ]; then
    echo -e "${red}Unit tests failed, please fix first!${color_end}"
    exit 1
elif [ $BEST_PRACTICES_RESULT -ne 0 ]; then
	echo -e "${red}You did not adhere to the rails best practices!${color_end}"
    exit 1
else
	exit 0
fi
