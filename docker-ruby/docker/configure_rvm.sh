gpg --keyserver hkp://keys.gnupg.net --recv-keys \
    409B6B1796C275462A1703113804BB82D39DC0E3 \
    7D2BAF1CF37B13E2069D6956105BD0E739499BDB;
\curl -sSL https://get.rvm.io | bash -s stable --ruby=2.3.1;
/usr/local/rvm/scripts/rvm install 2.3.1;
/usr/local/rvm/scripts/rvm use 2.3.1 --default;
gem install bundler;
/usr/local/rvm/scripts/rvm reinstall 2.3.1;
#RUN unset GEM_HOME

# RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
# RUN \curl -sSL https://get.rvm.io | bash -s stable --ruby=2.3.1
# # # RUN source /usr/local/rvm/scripts/rvm
# RUN /usr/local/rvm/scripts/rvm install 2.3.1
# RUN /usr/local/rvm/scripts/rvm use 2.3.1 --default
# RUN gem install bundler
# RUN /usr/local/rvm/scripts/rvm reinstall 2.3.1