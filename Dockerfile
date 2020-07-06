FROM openresty/openresty:1.15.8.3-alpine

ENV \
 SESSION_VERSION=3.6 \
 HTTP_VERSION=0.14 \
 OPENIDC_VERSION=seitenwerke-stable \
 JWT_VERSION=0.2.0 \
 HMAC_VERSION=989f601acbe74dee71c1a48f3e140a427f2d03ae

RUN \
 apk update && apk upgrade && apk add curl && \
 cd /tmp && \
 curl -sSL https://github.com/bungle/lua-resty-session/archive/v${SESSION_VERSION}.tar.gz | tar xz && \
 curl -sSL https://github.com/pintsized/lua-resty-http/archive/v${HTTP_VERSION}.tar.gz | tar xz  && \
 curl -sSL https://github.com/ChristianHohlfeld/lua-resty-openidc/archive/${OPENIDC_VERSION}.tar.gz | tar xz && \
 curl -sSL https://github.com/cdbattags/lua-resty-jwt/archive/v${JWT_VERSION}.tar.gz | tar xz && \
 curl -sSL https://github.com/jkeys089/lua-resty-hmac/archive/${HMAC_VERSION}.tar.gz | tar xz && \
 cp -r /tmp/lua-resty-session-${SESSION_VERSION}/lib/resty/* /usr/local/openresty/lualib/resty/ && \
 cp -r /tmp/lua-resty-http-${HTTP_VERSION}/lib/resty/* /usr/local/openresty/lualib/resty/ && \
 cp -r /tmp/lua-resty-openidc-${OPENIDC_VERSION}/lib/resty/* /usr/local/openresty/lualib/resty/ && \
 cp -r /tmp/lua-resty-jwt-${JWT_VERSION}/lib/resty/* /usr/local/openresty/lualib/resty/ && \
 cp -r /tmp/lua-resty-hmac-${HMAC_VERSION}/lib/resty/* /usr/local/openresty/lualib/resty/ && \
 rm -rf /tmp/* && \
 mkdir -p /usr/local/openresty/nginx/conf/hostsites/ && \
 true

EXPOSE 80

COPY bootstrap.sh /usr/local/openresty/bootstrap.sh
COPY nginx /usr/local/openresty/nginx/

ENTRYPOINT ["/usr/local/openresty/bootstrap.sh"]
