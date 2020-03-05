# Folding@home
#
# VERSION               0.1
# Run with: docker run -d -t -i jordan0day/folding-at-home
# Inspired by magglass1/docker-folding-at-home

# Set environment variables USERNAME, TEAM, and POWER to customize your Folding client.

FROM alpine:3.6
RUN apk --update add rpm curl
# If you set USERNAME to Anonymous, the folding@home client pauses for 5 minutes, but will then begin processing data.
ENV USERNAME reilly126
ENV TEAM 57391
ENV POWER high

# Install Folding@home
RUN curl -SL https://fah.stanford.edu/file-releases/public/release/fahclient/centos-5.3-64bit/v7.4/fahclient-7.4.4-1.x86_64.rpm -o /tmp/fahclient.rpm
RUN rpm -i /tmp/fahclient.rpm
RUN rm /tmp/fahclient.rpm
ADD config.xml /etc/fahclient/
RUN chown fahclient:root /etc/fahclient/config.xml
RUN sed -i -e "s/{{USERNAME}}/$USERNAME/;s/{{TEAM}}/$TEAM/;s/{{POWER}}/$POWER/" /etc/fahclient/config.xml

CMD /etc/init.d/FAHClient start && tail -F /var/lib/fahclient/log.txt
