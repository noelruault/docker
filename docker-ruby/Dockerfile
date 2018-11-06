# Base image
## https://hub.docker.com/_/ruby/
FROM ruby:2.3.1
# ruby:2.3.1-alpine

MAINTAINER Noel Ruault <noel.ruault@qvantel.com>

# Configure the main working directory. This is the base
# directory used in any further RUN, COPY, and ENTRYPOINT
# commands.
WORKDIR /mnt

ADD . /mnt

# Install apt based dependencies required to run Rails as
# well as RubyGems. As the Ruby image itself is based on a
# Debian image, we use apt-get to install those.
RUN apt-get update && apt-get install -y \
    build-essential git nano less sed curl libcurl3 \
    gettext \
    nodejs \
    libpq-dev \
    redis-server \
    libxml2 libxml2-dev \
    libssl-dev \
    libreadline-dev \
    zlib1g zlib1g-dev \
    libmariadb-client-lgpl-dev libmariadb-client-lgpl-dev-compat

# Install RVM
RUN /mnt/docker/configure_rvm.sh

# Result of running $rvm use default (REMOVE LAST ":")
ENV PATH /usr/local/rvm/gems/ruby-2.3.1/bin:/usr/local/rvm/gems/ruby-2.3.1@global/bin:/usr/local/rvm/rubies/ruby-2.3.1/bin:/usr/local/rvm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
# Result of running $rvm gemset reset_env
ENV GEM_HOME /usr/local/rvm/gems/ruby-2.3.1

RUN /mnt/docker/bundle_ensure_local_resource.sh
