# Copyright 2017-2019 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Amazon Software License (the "License"). You may not use this file except in compliance with the License.
# A copy of the License is located at
#
#    http://aws.amazon.com/asl/
#
# or in the "license" file accompanying this file.
# This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, express or implied.
# See the License for the specific language governing permissions and limitations under the License.

FROM public.ecr.aws/ubuntu/ubuntu:20.04

#****************        Utilities     ********************************************* 
ENV DOCKER_VERSION="19.03.13" \
    DOCKER_COMPOSE_VERSION="1.27.4" \
    DOCKER_BUCKET="download.docker.com" \    
    DOCKER_CHANNEL="stable" \
    DOCKER_SHA256="ddb13aff1fcdcceb710bf71a210169b9c1abfd7420eeaf42cf7975f8fae2fcc8" \
    DIND_COMMIT="3b5fac462d21ca164b3778647420016315289034" \    
    JQ_VERSION="1.6" \
    JQ_SHA256="af986793a515d500ab2d35f8d2aecd656e764504b789b66d7e1a0b727a124c44" \
    DEBIAN_FRONTEND="noninteractive" \
    SRC_DIR="/usr/src"

# Install git, SSH, and other utilities
RUN set -ex \
    && echo 'Acquire::CompressionTypes::Order:: "gz";' > /etc/apt/apt.conf.d/99use-gzip-compression \
    && apt-get update \
    && apt install -y apt-transport-https gnupg ca-certificates \
    && apt-get install software-properties-common -y --no-install-recommends \
    && apt-add-repository -y ppa:git-core/ppa \
    && apt-get update \
    && apt-get install git=1:2.* -y --no-install-recommends \
    && git version \
    && apt-get install -y --no-install-recommends openssh-client \
    && mkdir ~/.ssh \
    && touch ~/.ssh/known_hosts \
    && ssh-keyscan -t rsa,dsa -H github.com >> ~/.ssh/known_hosts \
    && ssh-keyscan -t rsa,dsa -H bitbucket.org >> ~/.ssh/known_hosts \
    && chmod 600 ~/.ssh/known_hosts \
    && apt-get install -y --no-install-recommends \
        apt-utils asciidoc autoconf automake build-essential bzip2 \
        bzr curl cvs cvsps dirmngr docbook-xml docbook-xsl dpkg-dev \
        e2fsprogs expect fakeroot file g++ gcc gettext gettext-base \
        groff gzip iptables less libapr1 libaprutil1 \
        libargon2-0-dev libbz2-dev libc6-dev libcurl4-openssl-dev \
        libdb-dev libdbd-sqlite3-perl libdbi-perl libdpkg-perl \
        libedit-dev liberror-perl libevent-dev libffi-dev libgeoip-dev \
        libglib2.0-dev libhttp-date-perl libio-pty-perl libjpeg-dev \
        libkrb5-dev liblzma-dev libmagickcore-dev libmagickwand-dev \
        libmysqlclient-dev libncurses5-dev libncursesw5-dev libonig-dev \
        libpq-dev libreadline-dev libserf-1-1 libsqlite3-dev libssl-dev \
        libsvn1 libsvn-perl libtcl8.6 libtidy-dev libtimedate-perl \
        libtool libwebp-dev libxml2-dev libxml2-utils libxslt1-dev \
        libyaml-dev libyaml-perl llvm locales make mercurial mlocate \
        netbase openssl patch pkg-config procps python3-configobj \
        python-openssl rsync sgml-base sgml-data \
        tar tcl tcl8.6 tk tk-dev unzip wget xfsprogs xml-core xmlto xsltproc \
        libzip5 libzip-dev vim xvfb xz-utils zip zlib1g-dev \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean \
    && wget https://github.com/jqlang/jq/releases/download/jq-${JQ_VERSION}/jq-linux64 -O /usr/local/bin/jq \
    && echo "$JQ_SHA256 /usr/local/bin/jq" | sha256sum -c - \
    && chmod +x /usr/local/bin/jq

# Install Docker
RUN set -ex \
    && curl -fSL "https://${DOCKER_BUCKET}/linux/static/${DOCKER_CHANNEL}/x86_64/docker-${DOCKER_VERSION}.tgz" -o docker.tgz \
    && echo "${DOCKER_SHA256} *docker.tgz" | sha256sum -c - \
    && tar --extract --file docker.tgz --strip-components 1  --directory /usr/local/bin/ \
    && rm docker.tgz \
    && docker -v \
# set up subuid/subgid so that "--userns-remap=default" works out-of-the-box
    && addgroup dockremap \
    && useradd -g dockremap dockremap \
    && echo 'dockremap:165536:65536' >> /etc/subuid \
    && echo 'dockremap:165536:65536' >> /etc/subgid \
    && wget "https://raw.githubusercontent.com/docker/docker/${DIND_COMMIT}/hack/dind" -O /usr/local/bin/dind \
    && curl -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-Linux-x86_64 > /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/dind /usr/local/bin/docker-compose \
# Ensure docker-compose works
    && docker-compose version

# https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ECS_CLI_installation.html
RUN curl -sS -o /usr/local/bin/aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.16.8/2020-04-16/bin/linux/amd64/aws-iam-authenticator \
    && curl -sS -o /usr/local/bin/kubectl https://amazon-eks.s3-us-west-2.amazonaws.com/1.16.8/2020-04-16/bin/linux/amd64/kubectl \
    && curl -sS -o /usr/local/bin/ecs-cli https://amazon-ecs-cli.s3.amazonaws.com/ecs-cli-linux-amd64-latest \
    && chmod +x /usr/local/bin/kubectl /usr/local/bin/aws-iam-authenticator /usr/local/bin/ecs-cli

# Configure SSH
COPY ssh_config /root/.ssh/config
COPY dockerd-entrypoint.sh /usr/local/bin/

# Install AWS CLI v2
# https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html
RUN curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o /tmp/awscliv2.zip \
    && unzip /tmp/awscliv2.zip -d /opt \
    && /opt/aws/install -i /usr/local/aws-cli -b /usr/local/bin \
    && rm /tmp/awscliv2.zip \
    && rm -rf /opt/aws \
    && aws --version

#**************** PYTHON *****************************************************
ENV PYTHON_39_VERSION="3.9.5" \
    PYTHON_PIP_VERSION="21.1.2" \
    PYYAML_VERSION="5.4.1"
RUN curl https://pyenv.run | bash
ENV PATH="/root/.pyenv/shims:/root/.pyenv/bin:$PATH"
COPY tools/runtime_configs/python/$PYTHON_39_VERSION /root/.pyenv/plugins/python-build/share/python-build/$PYTHON_39_VERSION
RUN set -ex \
    && env PYTHON_CONFIGURE_OPTS="--enable-shared" pyenv install $PYTHON_39_VERSION \
    && rm -rf /tmp/* \
    && pyenv global $PYTHON_39_VERSION \
    && pip3 install --no-cache-dir --upgrade --force-reinstall "pip==$PYTHON_PIP_VERSION" \
    && pip3 install --no-cache-dir --upgrade "PyYAML==$PYYAML_VERSION" \
    && pip3 install --no-cache-dir --upgrade setuptools wheel aws-sam-cli boto3 pipenv virtualenv --use-feature=2020-resolver

VOLUME /var/lib/docker

#****************     GO     **********************************************************
ENV GOLANG_VERSION="1.23.11" \
    GOLANG_DOWNLOAD_SHA256="80899df77459e0b551d2eb8800ad6eb47023b99cccbf8129e7b5786770b948c5" \
    GOPATH="/go" \
    DEP_VERSION="0.5.4" \
    DEP_BINARY="dep-linux-amd64"

RUN set -ex \
    && mkdir -p "$GOPATH/src" "$GOPATH/bin" \
    && chmod -R 777 "$GOPATH" \
    && apt-get update && apt-get install -y --no-install-recommends \
        pkg-config \
    && apt-get clean \
    && wget "https://dl.google.com/go/go$GOLANG_VERSION.linux-amd64.tar.gz" -O /tmp/golang.tar.gz \
    && echo "$GOLANG_DOWNLOAD_SHA256 /tmp/golang.tar.gz" | sha256sum -c - \
    && tar -xzf /tmp/golang.tar.gz -C /usr/local \
    && rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && wget "https://github.com/golang/dep/releases/download/v$DEP_VERSION/$DEP_BINARY" -O "$GOPATH/bin/dep" \
    && chmod +x "$GOPATH/bin/dep"

ENV PATH="$GOPATH/bin:/usr/local/go/bin:$PATH"
#****************     END GO     **********************************************************

ENTRYPOINT ["dockerd-entrypoint.sh"]
