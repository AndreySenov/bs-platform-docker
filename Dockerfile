FROM node:lts-alpine
ARG VERSION
RUN apk add g++ make python && \
    yarn global add bs-platform@${VERSION}

FROM node:lts-alpine
ARG BUILD_DATE
ARG CI_JOB_ID
ARG CI_PIPELINE_ID
ARG VERSION
ARG VCS_REF
LABEL org.label-schema.schema-version="1.0" \
      org.label-schema.name="bs-platform" \
      org.label-schema.version=${VERSION} \
      org.label-schema.build-date=${BUILD_DATE} \
      org.label-schema.description="BuckleScript and Reason on the NodeJS LTS image" \
      org.label-schema.url="https://github.com/bucklescript/bucklescript/" \
      org.label-schema.vcs-url="https://github.com/AndreySenov/dockerfiles/" \
      org.label-schema.vcs-ref=${VCS_REF} \
      ci_job_id=${CI_JOB_ID} \
      ci_pipeline_id=${CI_PIPELINE_ID}
COPY --from=0 /usr/local/share/.config/yarn/global /usr/local/share/.config/yarn/global
ENV BS_PLATFORM_VERSION=${VERSION}
ENV HOME=/home/node
RUN cd /usr/local && \
    ln -s ../share/.config/yarn/global/node_modules/.bin/bsb bin/bsb && \
    ln -s ../share/.config/yarn/global/node_modules/.bin/bsc bin/bsc && \
    ln -s ../share/.config/yarn/global/node_modules/.bin/bsrefmt bin/bsrefmt && \
    bsb -v && \
    bsc -v && \
    mkdir $HOME/.cache && \
    chown -R node:node $HOME
USER node
VOLUME $HOME/.cache
WORKDIR $HOME
CMD ["sh"]
