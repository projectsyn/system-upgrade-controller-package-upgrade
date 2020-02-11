FROM busybox

ARG VERSION=unspecified

COPY ./entrypoint.sh /entrypoint.sh
COPY ./update-packages.sh /update-packages.sh

RUN sed -i "s/VERSION/${VERSION}/" /entrypoint.sh && \
    sed -i "s/VERSION/${VERSION}/" /update-packages.sh

ENTRYPOINT ["/entrypoint.sh"]
