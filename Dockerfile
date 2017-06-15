FROM alpine:3.6
RUN apk --no-cache add opendkim
RUN apk --no-cache add opendkim-utils

# Install Bash
RUN apk --no-cache add bash

# Setting timezone
RUN apk --no-cache add tzdata
RUN ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
RUN echo "Europe/Berlin" > /etc/timezone

# Add Healthcheck
COPY ./usr/local/bin/docker_healthcheck.sh /usr/local/bin/docker_healthcheck.sh
RUN chmod 755 /usr/local/bin/docker_healthcheck.sh
HEALTHCHECK --interval=1m --timeout=5s \
  CMD /bin/sh /usr/local/bin/docker_healthcheck.sh

# Add configs
ADD ./etc/ /etc/

# Define mountable directories.
VOLUME ["/etc/opendkim"]

# Define default command.
CMD ["/usr/sbin/opendkim", "-f",  "-l",  "-x",  "/etc/opendkim/opendkim.conf"]

# Expose ports.
EXPOSE 12311
