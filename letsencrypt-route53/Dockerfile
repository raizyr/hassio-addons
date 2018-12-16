ARG BUILD_FROM
FROM $BUILD_FROM

# Add env
ENV LANG C.UTF-8

# Setup base
RUN apk add --no-cache jq certbot py2-future py2-pip libressl-dev libffi-dev
RUN pip install -U setuptools pip && \
    pip install certbot-dns-route53

# Copy data
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
