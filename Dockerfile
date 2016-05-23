FROM centos:6
MAINTAINER Takayuki Miwa <i@tkyk.name>

ENV code_root /code
ENV httpd_conf ${code_root}/httpd.conf

RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm
RUN rpm -Uvh https://mirror.webtatic.com/yum/el6/latest.rpm
RUN yum install -y httpd
RUN yum install --enablerepo=epel,remi-php56,remi -y \
                              php \
                              php-cli \
                              php-gd \
                              php-mbstring \
                              php-mcrypt \
                              php-mysqlnd \
                              php-pdo \
                              php-xml \
                              php-xdebug
RUN sed -i -e "s|^;date.timezone =.*$|date.timezone = Asia/Tokyo|" /etc/php.ini

ADD . $code_root
RUN test -e $httpd_conf && echo "Include $httpd_conf" >> /etc/httpd/conf/httpd.conf

EXPOSE 80
CMD ["/usr/sbin/apachectl", "-D", "FOREGROUND"]

