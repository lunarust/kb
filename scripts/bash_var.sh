# Source - https://stackoverflow.com/a/3588939
# Posted by Bill Hernandez, modified by community. See post 'Timeline' for change history
# Retrieved 2026-02-23, License - CC BY-SA 2.5


#!/bin/bash

echo
echo "# arguments called with ---->  ${@}     "
echo "# \$1 ---------------------->  $1       "
echo "# \$2 ---------------------->  $2       "
echo "# path to me --------------->  ${0}     "
echo "# parent path -------------->  ${0%/*}  "
echo "# my name ------------------>  ${0##*/} "
echo
exit
