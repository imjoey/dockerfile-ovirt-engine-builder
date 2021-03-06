FROM centos:7.5.1804
LABEL maintainer="majunjiev@gmail.com"

COPY ovirt-snapshots.repo /etc/yum.repos.d/

# Set up EPEL
RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

# Install base packages
RUN yum update -y && yum install -y git openssl postgresql-server postgresql-contrib \
    kernel-devel kernel-header bind-utils g++ gcc make perl m2crypto python-psycopg2 \
    python-cheetah python-daemon libxml2-python unzip zip pyflakes python-pep8 \
    python-docker-py mailcap python-jinja2 python-dateutil gdeploy otopi \
    python-flake8 python-docker-py python2-isort

# Set Up Java
RUN yum install -y java-1.8.0-openjdk.x86_64 java-1.8.0-openjdk-devel.x86_64 maven ant

# WildFly 8.2 for oVirt 3.6+ development
RUN yum install -y ovirt-engine-wildfly ovirt-engine-wildfly-overlay

# Install the oVirt Packages
RUN yum install -y ansible ovirt-host-deploy ovirt-setup-lib \
    ovirt-js-dependencies ovirt-ansible-roles ovirt-engine-metrics

# Install PostgreSQL 9.6
RUN yum install -y https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-centos96-9.6-3.noarch.rpm \
    postgresql96 postgresql96-server postgresql96-contrib python-psycopg2

# Build product and install at $HOME/ovirt-engine, 
# execute the following as unprivileged user while 
# residing within source repository
ENV HOME /home/ovirt
RUN groupadd -r ovirt && useradd -r -g ovirt -m ovirt
RUN chown -R ovirt:ovirt $HOME
USER ovirt
RUN mkdir -p $HOME/.m2/
WORKDIR $HOME/git/

CMD [ "make", "install-dev", "PREFIX=\"$HOME/ovirt-engine\"" ]
