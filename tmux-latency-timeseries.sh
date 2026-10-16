#!/bin/bash
# This script tests latency and spits out a number (in milliseconds) every x number of seconds as passed in to us

# use the passed in site or default to google and use the passed in frequency or default to 1s
# https://stackoverflow.com/questions/16319720/bash-command-line-arguments-replacing-defaults-for-variables/16836338
COUNT=${1:-"5"}
FREQ=${2:-"1"}
SITE=${3:-"http://www.google.com"}

echo "latency_ms"

# https://ryanstutorials.net/bash-scripting-tutorial/bash-loops.php
while (sleep $FREQ && [ $COUNT -ne 0 ])
do
    # get latency
    # https://www.interserver.net/tips/kb/how-to-test-website-response-time-in-linux-terminal/
    TIME=$(curl -s -w "%{time_total}" -o /dev/null $SITE)

    # format latency into milliseconds
    # https://www.tecmint.com/bc-command-examples/
    # https://askubuntu.com/questions/179898/how-to-round-decimals-using-bc-in-bash
    TIME=$(echo "scale=0; $TIME * 1000" | bc -l | xargs printf %.0f )

    # output the raw number
    echo "${TIME}"

    # reduce count by one
    ((COUNT--))
done