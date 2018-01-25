#!/bin/bash

printf "Getting FLEX files\n"
FD=tmpFLEXgit
git clone https://github.com/Flipboard/FLEX.git "$FD"
printf "Done. Copying files\n"
mkdir Sources
find "$FD"/Classes -type f \( -name "*.h" -o -name "*.m" \) -exec mv {} Sources/ \;
rm -rf "$FD"
