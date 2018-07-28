
ARG IMAGE_ARG_IMAGE_TAG

FROM mariadb:${IMAGE_ARG_IMAGE_TAG:-10.1.34} as base

# see https://github.com/docker-library/mariadb/blob/master/10.1/Dockerfile
# see https://github.com/docker-library/mariadb/blob/master/10.2/Dockerfile

FROM scratch

COPY --from=base / /

RUN set -ex \
  && usermod -u 1000  mysql \
  && groupmod -g 1000 mysql \
  && find -user 999 -path "/proc" -prune -exec chown mysql:mysql {} ";" \
  && chown -hR mysql:mysql /etc/mysql /var/log/mysql \
  && if [ -f /var/log/mysql.log ]; then chown -hR mysql:mysql /var/log/mysql.log; fi \
  && if [ -f /var/log/mysql.err ]; then chown -hR mysql:mysql /var/log/mysql.err; fi

VOLUME ["/var/lib/mysql", "/var/log"]
ENTRYPOINT ["docker-entrypoint.sh"]
EXPOSE 3306
CMD ["mysqld"]
