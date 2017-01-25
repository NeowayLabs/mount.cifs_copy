FROM fedora:25
MAINTAINER Yann Hodique <yann.hodique@gmail.com>
ENV CIFS_UTILS_DOWNLOAD_URL https://ftp.samba.org/pub/linux-cifs/cifs-utils/
ENV CIFS_UTILS_VERSION cifs-utils-6.6.tar.bz2
ENV UPDATED_AT 25-01-2017

#install required libraries & clean up to keep thin layer
RUN dnf groupinstall -y "Development Tools" "Development Libraries" \
    && dnf install -y bzip2 tar \
    && dnf autoremove -y && dnf clean all -y

#download & make mount.cifs from source
RUN (cd /tmp; curl -O ${CIFS_UTILS_DOWNLOAD_URL}/${CIFS_UTILS_VERSION}.tar.bz2) \
    && (cd /tmp; tar -xf ${CIFS_UTILS_VERSION}.tar.bz2; rm ${CIFS_UTILS_VERSION}.tar.bz2) \
    && (cd /tmp/${CIFS_UTILS_VERSION}/; ./configure && make) \
    && mkdir -p /tmp/bin/ \
    && cp /tmp/${CIFS_UTILS_VERSION}/mount.cifs /tmp/bin/

#prepare WORKDIR
COPY run.Dockerfile /tmp/bin/Dockerfile
COPY run.sh /tmp/bin/run.sh
WORKDIR /tmp/bin/

# Export the WORKDIR as a tar stream
CMD tar -cf - .
