# Docker-xvfb.chrome.remote

docker build -t chrome.remote.19222 .

docker run -d -p 19223:19222 --name chrome.port:19223 chrome.remote:19222
