FROM centos:7.5.1804
LABEL maintainer="majunjiev@gmail.com"

COPY ovirt-snapshots.repo /etc/yum.repos.d/

# Set Up Java
RUN yum install -y java-1.8.0-openjdk.x86_64 java-1.8.0-openjdk-devel.x86_64 maven

# Install other base packages
RUN yum install -y git openssl postgresql-server postgresql-contrib \
        kernel-devel kernel-header bind-utils g++ gcc make perl \
        m2crypto python-psycopg2 python-cheetah python-daemon libxml2-python \
        unzip pyflakes python-pep8 python-docker-py mailcap python-jinja2 \
        python-dateutil gdeploy otopi python-flake8 python-flake8 \
        python-docker-py python2-isort python-pip

# WildFly 8.2 for oVirt 3.6+ development
RUN yum install -y ovirt-engine-wildfly ovirt-engine-wildfly-overlay

# Add pip
RUN curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py" && python get-pip.py

# Install the oVirt Packages
RUN pip install ansible && yum install -y ovirt-host-deploy ovirt-setup-lib \
        ovirt-js-dependencies ovirt-ansible-roles ovirt-engine-metrics

# Build product and install at $HOME/ovirt-engine, 
# execute the following as unprivileged user while 
# residing within source repository
ENV HOME /home/ovirt
RUN groupadd -r ovirt && useradd -r -g ovirt -m ovirt
RUN chown -R ovirt:ovirt $HOME
USER ovirt
RUN mkdir -p $HOME/.m2/repository
WORKDIR $HOME/ovirt-engine/

CMD [ "make", "install-dev", "PREFIX=\"$HOME/ovirt-engine\"" ]
