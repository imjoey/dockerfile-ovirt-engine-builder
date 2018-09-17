FROM centos:7.5
LABEL maintainer="majunjiev@gmail.com"

COPY ovirt-snapshots.repo /etc/yum.repos.d/

RUN yum update -y

RUN yum install -y git java-devel maven openssl postgresql-server postgresql-contrib \
        m2crypto python-psycopg2 python-cheetah python-daemon libxml2-python \
        unzip pyflakes python-pep8 python-docker-py mailcap python-jinja2 \
        python-dateutil gdeploy 

RUN ulimit -n 10240

# WildFly 8.2 for oVirt 3.6+ development
RUN yum install -y ovirt-engine-wildfly ovirt-engine-wildfly-overlay

# Install the oVirt Packages
RUN yum install -y ovirt-host-deploy ovirt-setup-lib ovirt-js-dependencies

# Set Up Java and make sure openjdk is the java preferred
RUN alternatives --config java && alternatives --config javac

# Build product and install at $HOME/ovirt-engine, 
# execute the following as unprivileged user while 
# residing within source repository
RUN groupadd -r ovirt && useradd -r -g ovirt ovirt
USER ovirt
WORKDIR /home/ovirt/ovirt-engine/

CMD [ "make", "install-dev", "PREFIX=\"/home/ovirt/ovirt-engine\"" ]
