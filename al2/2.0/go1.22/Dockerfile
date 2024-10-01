# Copyright 2017-2017 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Amazon Software License (the "License"). You may not use this file except in compliance with the License.
# A copy of the License is located at
#
#    http://aws.amazon.com/asl/
#
# or in the "license" file accompanying this file.
# This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, express or implied.
# See the License for the specific language governing permissions and limitations under the License.

FROM public.ecr.aws/amazonlinux/amazonlinux:2

#****************        Utilities     ********************************************* 
ENV JQ_VERSION="1.6" \
    JQ_SHA256="af986793a515d500ab2d35f8d2aecd656e764504b789b66d7e1a0b727a124c44" \
    DOCKER_VERSION="19.03.3" \
    DOCKER_SHA256="c3c8833e227b61fe6ce0bc5c17f97fa547035bef4ef17cf6601f30b0f20f4ce5" \
    DOCKER_COMPOSE_VERSION="1.24.0" \
    DOCKER_BUCKET="download.docker.com" \
    DOCKER_CHANNEL="stable" \
    DIND_COMMIT="3b5fac462d21ca164b3778647420016315289034" \    
    GITVERSION_VERSION="4.0.0" \
    DEBIAN_FRONTEND="noninteractive" \
    SRC_DIR="/usr/src"

# Install git, SSH, and other utilities
RUN set -ex \
    && yum install -y openssh-clients \
    && mkdir ~/.ssh \
    && touch ~/.ssh/known_hosts \
    && ssh-keyscan -t rsa,dsa -H github.com >> ~/.ssh/known_hosts \
    && ssh-keyscan -t rsa,dsa -H bitbucket.org >> ~/.ssh/known_hosts \
    && chmod 600 ~/.ssh/known_hosts \
    && yum groupinstall -y "Development tools" \
    && yum install -y \
           GeoIP-devel ImageMagick asciidoc bzip2-devel bzr bzrtools cvs cvsps \
           docbook-dtds docbook-style-xsl dpkg-dev e2fsprogs expat-devel expect fakeroot \
           glib2-devel groff gzip icu iptables krb5-server libargon2-devel \
           libcurl-devel libdb-devel libedit-devel libevent-devel libffi-devel \
           libicu-devel libjpeg-devel libpng-devel libserf libsqlite3x-devel \
           libtidy-devel libunwind libwebp-devel libxml2-devel libxslt libxslt-devel \
           libyaml-devel libzip-devel mariadb-devel mercurial mlocate \
           ncurses-devel oniguruma-devel openssl openssl-devel perl-DBD-SQLite \
           perl-DBI perl-HTTP-Date perl-IO-Pty-Easy perl-TimeDate perl-YAML-LibYAML \
           postgresql-devel procps-ng python-configobj readline-devel rsync sgml-common \
           subversion-perl tar tcl tk vim wget which xfsprogs xmlto xorg-x11-server-Xvfb xz-devel \
    && rm -rf /var/cache/yum/* \
    && yum clean all \
    && wget https://github.com/jqlang/jq/releases/download/jq-${JQ_VERSION}/jq-linux64 -O /usr/local/bin/jq \
    && echo "$JQ_SHA256 /usr/local/bin/jq" | sha256sum -c - \
    && chmod +x /usr/local/bin/jq

# Install Git
RUN set -ex \
   && GIT_VERSION=2.26.2 \
   && GIT_TAR_FILE=git-$GIT_VERSION.tar.gz \
   && GIT_SRC=https://github.com/git/git/archive/v${GIT_VERSION}.tar.gz  \
   && curl -L -o $GIT_TAR_FILE $GIT_SRC \
   && tar zxvf $GIT_TAR_FILE \
   && cd git-$GIT_VERSION \
   && make -j4 prefix=/usr \
   && make install prefix=/usr \
   && cd .. ; rm -rf git-$GIT_VERSION \
   && rm -rf $GIT_TAR_FILE /tmp/*

# Install Docker
RUN set -ex \
    && curl -fSL "https://${DOCKER_BUCKET}/linux/static/${DOCKER_CHANNEL}/x86_64/docker-${DOCKER_VERSION}.tgz" -o docker.tgz \
    && echo "${DOCKER_SHA256} *docker.tgz" | sha256sum -c - \
    && tar --extract --file docker.tgz --strip-components 1  --directory /usr/local/bin/ \
    && rm docker.tgz \
    && docker -v \
# set up subuid/subgid so that "--userns-remap=default" works out-of-the-box
    && groupadd dockremap \
    && useradd -g dockremap dockremap \
    && echo 'dockremap:165536:65536' >> /etc/subuid \
    && echo 'dockremap:165536:65536' >> /etc/subgid \
    && wget "https://raw.githubusercontent.com/docker/docker/${DIND_COMMIT}/hack/dind" -O /usr/local/bin/dind \
    && curl -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-Linux-x86_64 > /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/dind /usr/local/bin/docker-compose \
# Ensure docker-compose works
    && docker-compose version

# https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ECS_CLI_installation.html
RUN curl -sS -o /usr/local/bin/aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/aws-iam-authenticator \
 && curl -sS -o /usr/local/bin/kubectl https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/kubectl \
 && curl -sS -o /usr/local/bin/ecs-cli https://amazon-ecs-cli.s3.amazonaws.com/ecs-cli-linux-amd64-latest \
 && chmod +x /usr/local/bin/kubectl /usr/local/bin/aws-iam-authenticator /usr/local/bin/ecs-cli

VOLUME /var/lib/docker

# Configure SSH
COPY ssh_config /root/.ssh/config

COPY runtimes.yml /codebuild/image/config/runtimes.yml

COPY dockerd-entrypoint.sh /usr/local/bin/

#**************** PYTHON *****************************************************
ENV PYTHON_38_VERSION="3.8.10" \
    PYTHON_PIP_VERSION="21.1.2" \
    PYYAML_VERSION="5.4.1"
RUN curl https://pyenv.run | bash
ENV PATH="/root/.pyenv/shims:/root/.pyenv/bin:$PATH"
COPY tools/runtime_configs/python/$PYTHON_38_VERSION /root/.pyenv/plugins/python-build/share/python-build/$PYTHON_38_VERSION
RUN set -ex \
    && env PYTHON_CONFIGURE_OPTS="--enable-shared" pyenv install $PYTHON_38_VERSION \
    && rm -rf /tmp/* \
    && pyenv global $PYTHON_38_VERSION \
    && pip3 install --no-cache-dir --upgrade --force-reinstall "pip==$PYTHON_PIP_VERSION" \
    && pip3 install --no-cache-dir --upgrade "PyYAML==$PYYAML_VERSION" \
    && pip3 install --no-cache-dir --upgrade setuptools wheel aws-sam-cli awscli boto3 pipenv virtualenv

#****************     GO     **********************************************************
ENV GOLANG_VERSION="1.22.8" \
    GOLANG_DOWNLOAD_SHA256="5f467d29fc67c7ae6468cb6ad5b047a274bae8180cac5e0b7ddbfeba3e47e18f" \
    GOPATH="/go" \
    DEP_VERSION="0.5.4" \
    DEP_BINARY="dep-linux-amd64"

RUN set -ex \
    && mkdir -p "$GOPATH/src" "$GOPATH/bin" \
    && chmod -R 777 "$GOPATH" \
    && wget "https://dl.google.com/go/go$GOLANG_VERSION.linux-amd64.tar.gz" -O /tmp/golang.tar.gz \
    && echo "$GOLANG_DOWNLOAD_SHA256 /tmp/golang.tar.gz" | sha256sum -c - \
    && tar -xzf /tmp/golang.tar.gz -C /usr/local \
    && rm -fr /tmp/* /var/tmp/* \
    && wget "https://github.com/golang/dep/releases/download/v$DEP_VERSION/$DEP_BINARY" -O "$GOPATH/bin/dep" \
    && chmod +x "$GOPATH/bin/dep"

ENV PATH="$GOPATH/bin:/usr/local/go/bin:$PATH"
#****************     END GO     **********************************************************

ENTRYPOINT ["dockerd-entrypoint.sh"]
