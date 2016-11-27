# @CLASS=essential

TEST_DESCRIPTION="Test if echoing help gives an error"

echo_debug <<EOF
This is a simple test to see if the listing
of scripts creates an error, it serves also
as a documentation tool.

PWD = $PWD
EOF

./testazo.sh -l

TEST_RESULT=$?

#vim-run: bash %
