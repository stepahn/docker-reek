FROM ruby:alpine as builder

RUN apk update \
    && apk add --virtual build-dependencies \
        build-base \
    && true

RUN gem install reek -v 5.3.1

RUN rm -rf /usr/local/bundle/cache/*.gem \
 && find /usr/local/bundle/gems/ -name "*.c" -delete \
 && find /usr/local/bundle/gems/ -name "*.o" -delete

FROM ruby:alpine

LABEL io.whalebrew.name 'reek'
LABEL io.whalebrew.config.working_dir '/workdir'
WORKDIR /workdir

COPY --from=builder /usr/local/bundle /usr/local/bundle

ENTRYPOINT ["reek"]
CMD ["--help"]
