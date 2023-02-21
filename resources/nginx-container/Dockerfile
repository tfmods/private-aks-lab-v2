# Use Alpine Linux
FROM alpine:3.17.2
#FIXED ALPINE VERSION

# Declare maintainer
MAINTAINER Rosthan SIlva <rosthanlinux@gmail.com>

# Timezone
ENV TIMEZONE America/Sao_Paulo

# Let's roll
RUN	apk update && \
	apk upgrade && \
	apk add --update openssl nginx cifs-utils && \
	apk add --update tzdata && \
	cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \
	echo "${TIMEZONE}" > /etc/timezone && \
	mkdir /etc/nginx/certificates && \
	openssl req \
		-x509 \
		-newkey rsa:2048 \
		-keyout /etc/nginx/certificates/key.pem \
		-out /etc/nginx/certificates/cert.pem \
		-days 365 \
		-nodes \
		-subj /CN=localhost && \
	mkdir /www && \
	apk del tzdata && \
	rm -rf /var/cache/apk/*

    RUN mkdir /etc/nginx/includes/ && \
    chmod 744 /etc/nginx/includes/


# Expose volumes
VOLUME ["/etc/nginx/conf.d", "/etc/nginx/includes/", "/var/log/nginx", "/www"]



# Expose ports
EXPOSE 80 443

# Entry point
ENTRYPOINT ["/usr/sbin/nginx", "-g", "daemon off;"]
