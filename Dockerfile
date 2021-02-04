FROM alpine:latest

ARG BACKUP_USER=root
ENV HOSTNAME=mysql
ENV MYSQL_USERNAME=mysql
ENV MYSQL_PASSWORD=secret
ENV SQL_DATABASE=mysql
ENV BACKUP_DIR=/data
ENV ENABLE_CUSTOM_BACKUPS=yes
ENV ENABLE_PLAIN_BACKUPS=no
ENV DAY_OF_WEEK_TO_KEEP=5
ENV DAYS_TO_KEEP=7
ENV WEEKS_TO_KEEP=5
ENV CRON_EXPRESSION="0 4 * * *"

RUN apk add --update --no-cache mysql-client

VOLUME /data

ADD mysql_backup.sh /usr/local/bin/mysql_backup

RUN echo "$CRON_EXPRESSION mysql_backup" > /var/spool/cron/crontabs/$BACKUP_USER

USER $BACKUP_USER

CMD ["crond", "-l2", "-f"]
