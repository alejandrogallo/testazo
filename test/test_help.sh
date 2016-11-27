# @CLASS=essential

TEST_DESCRIPTION="Test if echoing help gives an error"

./testazo.sh -h

TEST_RESULT=$?
