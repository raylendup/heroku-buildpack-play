FROM heroku/cedar:14

# env vars for play
ENV PLAY_GIT_ORGUSER=lendup
ENV PLAY_GIT_REPO=play1
ENV PLAY_GIT_TAG=lendup-1.2.6.5

# install openjdk 1.6 and aws-cli
RUN apt-get update
RUN apt-get remove -y default-jre openjdk-7-jdk openjdk-7-jre-headless
RUN apt-get install -y openjdk-6-jdk python-pip ant
RUN pip install aws

# get and build play
RUN git clone https://github.com/${PLAY_GIT_ORGUSER}/${PLAY_GIT_REPO}.git /play/${PLAY_GIT_REPO}
WORKDIR /play/${PLAY_GIT_REPO}
RUN git checkout ${PLAY_GIT_TAG}
RUN ant -buildfile ./framework/build.xml
WORKDIR /play
RUN zip -r /play/${PLAY_GIT_TAG}-repo.zip ${PLAY_GIT_REPO}

# add code
ADD . /heroku-buildpack-play
WORKDIR /heroku-buildpack-play

# build the build pack
RUN ./opt/build-play-heroku /play/${PLAY_GIT_TAG}-repo.zip
WORKDIR /heroku-buildpack-play/build
