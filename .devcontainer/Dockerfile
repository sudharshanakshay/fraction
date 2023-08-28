From debain:bookworm

RUN apt-get udpate && apt-get -y install git curl unzip

RUN apt-get autoremore -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

RUN mkdir /home/codespace

WORKDIR /home/codespace

ENV PUB_CACHE=/home/codespace/.pub_cache

ENV PATH="/home/codespace/flutter/bin:$PATH"

RUN git clone https://github.com/flutter/flutter && /home/codespace/flutter/bin/flutter config --enable-web
