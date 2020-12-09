FROM alpine:3.10
LABEL maintainer="Kong Core Team <team-core@konghq.com>"
ENV KONG_VERSION 1.1.0
ENV KONG_SHA256 51a8aea79d5e074c84fabd73ecaf45ee9060ad8269c2aa0bcb267b73ec6f9231
RUN adduser -Su 1337 kong \
	&& mkdir -p "/usr/local/kong" \
	&& apk add --no-cache --virtual .build-deps wget tar ca-certificates \
	&& apk add --no-cache libgcc openssl pcre perl tzdata curl libcap su-exec zip \
	&& wget -O kong.tar.gz "https://bintray.com/kong/kong-alpine-tar/download_file?file_path=kong-$KONG_VERSION.apk.tar.gz" \
	&& echo "$KONG_SHA256 *kong.tar.gz" | sha256sum -c - \
	&& tar -xzf kong.tar.gz -C /tmp \
	&& rm -f kong.tar.gz \
	&& cp -R /tmp/usr / \
	&& rm -rf /tmp/usr \
	&& cp -R /tmp/etc / \
	&& rm -rf /tmp/etc \
	&& apk del .build-deps \
	&& chown -R kong:0 /usr/local/kong \
	&& chmod -R g=u /usr/local/kong
COPY docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
EXPOSE 8000 8443 8001 8444
STOPSIGNAL SIGQUIT
CMD ["kong", "docker-start"]

