FROM ubuntu

WORKDIR /tmp
EXPOSE 19222

RUN useradd -m chrome

RUN apt-get update
RUN apt-get install -y wget socat xvfb

RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

RUN apt-get install -y 	gconf-service \
	 					libasound2 \
						libatk1.0-0 \
						libcairo2 \
						libcups2 \
						libfontconfig1 \
						libgdk-pixbuf2.0-0 \
						libgtk2.0-0 \
						libnspr4 \
						libnss3 \
						libpango1.0-0 libxss1 libxtst6 libappindicator1 libcurl4 xdg-utils \
						fonts-liberation \
						libgtk-3-0 lsb-release \
						libappindicator3-1

RUN dpkg -i /tmp/google-chrome-stable_current_amd64.deb
RUN rm -rf /tmp/*
RUN apt-get purge && apt-get clean && apt-get autoremove -y
ENV DISPLAY :1.0

COPY remote-user-data-dir /home/chrome/remote-user-data-dir
RUN chown -R chrome /home/chrome/remote-user-data-dir
RUN chmod --recursive +rw /home/chrome/remote-user-data-dir/Default/Cache
RUN chmod 770 /home/chrome/remote-user-data-dir/Default/Cache
RUN chmod -R 0700 /home/chrome/remote-user-data-dir/PepperFlash
RUN rm -rf /home/chrome/remote-user-data-dir/PepperFlash

COPY start.sh /home/chrome/

USER chrome
WORKDIR /home/chrome

ENTRYPOINT ["sh", "/home/chrome/start.sh"]