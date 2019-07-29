#!/bin/bash

 _kill_procs() {
   kill -TERM $chrome
   wait $chrome
   kill -TERM $xvfb
 }

# Setup a trap to catch SIGTERM and relay it to child processes
trap _kill_procs INT TERM HUP

echo "\n[start script] Making virtual display";
Xvfb :1 -screen 0 1366x768x24+32 -ac -nolisten tcp -nolisten unix &
sleep 1;
xvfb=$!

ls -lahG /home/chrome/remote-user-data-dir

# For more switches : http://peter.sh/experiments/chromium-command-line-switches/
echo "\n[start script] Starting Google Chrome at 9222 $@";
google-chrome --new-window --no-sandbox --disable-gpu --user-data-dir=/home/chrome/remote-user-data-dir --no-first-run --remote-debugging-port=9222 "https://duckduckgo.com" &
sleep 1;
chrome=$!

echo "\n[start script] Redirect incoming 19222 to 9222";
socat TCP-LISTEN:19222,fork TCP:127.0.0.1:9222 &

wait $chrome
wait $xvfb