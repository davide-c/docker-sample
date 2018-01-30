FROM centos/systemd

RUN mkdir temp

RUN yum install wget git -y

# htop
RUN wget dl.fedoraproject.org/pub/epel/7/x86_64/Packages/e/epel-release-7-11.noarch.rpm
RUN rpm -ihv epel-release-7-11.noarch.rpm

# varoius
RUN yum install htop vim nano curl wget git -y

####### vim #######
RUN yum install vim -y
RUN git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

RUN git clone https://davidecutrino@bitbucket.org/davidecutrino/dotfiles.git
RUN cp ./dotfiles/.vimrc ~/

# solarized
RUN git clone https://github.com/altercation/vim-colors-solarized

RUN mkdir ~/.vim/colors
RUN cp vim-colors-solarized/colors/solarized.vim ~/.vim/colors/
RUN vim +PluginInstall +qall

####### pure-ftpd #######
#RUN yum install pure-ftpd -y
#RUN systemctl enable pure-ftpd
#RUN systemctl start pure-ftpd

#RUN pure-pw useradd $USERNAME -u $USER -g $GROUP -d /var/www/html/config
#RUN pure-pw mkdb
#RUN systemctl reload pure-ftpd

####### php7.2 #######
#wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
#wget http://rpms.remirepo.net/enterprise/remi-release-7.rpm
#rpm -Uvh remi-release-7.rpm epel-release-latest-7.noarch.rpm
#yum install yum-utils
#yum-config-manager --enable remi-php72

####### php7.1 #######
#RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
RUN yum install php71w php71w-fpm  php71w-pdo_dblib php71w-odbc php71w-pdo php71w-mysql php71w-cli php71w-opcache php71w-pecl-apcu -y

####### mysql #######
RUN wget http://repo.mysql.com/mysql57-community-release-el7-8.noarch.rpm
RUN rpm -ivh mysql57-community-release-el7-8.noarch.rpm
RUN yum update -y
RUN yum install mysql-server -y

RUN systemctl enable mysqld
#RUN grep "temporary password" /var/log/mysqld.log
#mysql_pwd=$(grep 'temporary password' /var/log/mysqld.log | grep -Eo 'localhost: ([^\\S]*show tables)' | cut -d: -f2)
#mysql -uroot --password=$(echo $mysql_pwd) < /vagrant/mysql_secure_install.sql --connect-expired-password

################# composer ################
#RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
#RUN php -r "if (hash_file('SHA384', 'composer-setup.php') === 'e115a8dc7871f15d853148a7fbac7da27d6c0030b848d9b3dc09e2a0388afed865e6a3d6b3c0fad45c48e2b5fc1196ae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"

RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

####### apache #######
RUN yum install httpd -y
RUN systemctl enable httpd

#RUN mkdir temp

COPY . /var/www/html

WORKDIR /root/temp