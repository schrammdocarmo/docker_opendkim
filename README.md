# OPENDKIM on Alpine Linux 3.6

For those looking for a minimal image running OpenDKIM service.


## Build the image

	sudo docker build -t opendkim .


## Run the container

	sudo /usr/bin/docker run -d -v /etc/opendkim:/etc/opendkim:rw -p 127.0.0.1:12301:12301 --name=dkim1 opendkim

	*This binds the docker port 12301 only on the local interface of the docker host for security. You may eventually instead want to give the container a fix IP and reference it from Postfix.*
	

## Use the systemd file

	cp systemd/docker-container@dkim1.service to /etc/systemd/system/
	systemctl enable docker-container@dkim1.service
	systemctl start docker-container@dkim1.service


## Update Postfix

Add these lines to /etc/postfix/main.cf:

	milter_protocol = 2
	milter_default_action = accept
	smtpd_milters = inet:DKIM_CONTAINER_IP:12301
	non_smtpd_milters = inet:DKIM_CONTAINER_IP:12301

## Howto configure OpenDKIM?

Have a look here:
https://www.devops.zone/mailserver/how-to-configure-dkim-for-your-domain-with-postfix/
