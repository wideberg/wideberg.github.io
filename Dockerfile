FROM alpine:3.8
RUN apk update
RUN apk add bash
RUN apk add alpine-sdk
RUN apk add ruby
RUN apk add ruby-etc
RUN apk add ruby-dev
RUN apk add ruby-bigdecimal
RUN apk add ruby-webrick
RUN apk add ruby-rdoc
RUN apk add zlib
RUN apk add zlib-dev
RUN gem update
RUN gem install bigdecimal jekyll bundler github-pages zlib
#	RUN rm -f /var/cache/apk/*

ADD start.sh /blog/start.sh

EXPOSE 4000
WORKDIR /blog

#CMD ./start.sh

