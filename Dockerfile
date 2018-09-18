FROM centos:7.5.1804
LABEL maintainer="majunjiev@gmail.com"

COPY ovirt-snapshots.repo /etc/yum.repos.d/

RUN yum update -y

# Install base packages
RUN yum install -y git openssl postgresql-server postgresql-contrib \
        m2crypto python-psycopg2 python-cheetah python-daemon libxml2-python \
        unzip pyflakes python-pep8 python-docker-py mailcap python-jinja2 \
    python-dateutil gdeploy 

RUN ulimit -n 10240

# WildFly 8.2 for oVirt 3.6+ development
RUN yum install -y ovirt-engine-wildfly ovirt-engine-wildfly-overlay

# Install the oVirt Packages
RUN yum install -y ovirt-host-deploy ovirt-setup-lib ovirt-js-dependencies

# Install base 
RUN yum install -y kernel-devel kernel-header bind-utils g++ gcc make perl

# Set Up Java
RUN yum install -y java-1.8.0-openjdk.x86_64 java-1.8.0-openjdk-devel.x86_64 maven

# Build product and install at $HOME/ovirt-engine, 
# execute the following as unprivileged user while 
# residing within source repository
ENV HOME /home/ovirt
RUN groupadd -r ovirt && useradd -r -g ovirt -d $HOME ovirt
RUN chown -R ovirt:ovirt $HOME
USER ovirt
RUN mkdir -p $HOME/.m2/repository
WORKDIR $HOME/ovirt-engine/

CMD [ "make", "install-dev", "PREFIX=\"$HOME/ovirt-engine\"" ]
