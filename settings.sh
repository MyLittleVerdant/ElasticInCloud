#!/bin/bash
sudo su
# Обновить пакеты
apt-get update && apt -y upgrade

#php репозиторий
apt update
apt install lsb-release ca-certificates apt-transport-https software-properties-common -y
add-apt-repository ppa:ondrej/php

# Установить PHP и Apache
apt-get install -y apache2 php8.1 libapache2-mod-php

# Установить Git
apt-get install -y git

#Opensearch
apt -y install curl lsb-release gnupg2 ca-certificates
curl -fsSL https://artifacts.opensearch.org/publickeys/opensearch.pgp|sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/opensearch.gpg
echo "deb https://artifacts.opensearch.org/releases/bundle/opensearch/2.x/apt stable main" | sudo tee /etc/apt/sources.list.d/opensearch-2.x.list
apt update
env OPENSEARCH_INITIAL_ADMIN_PASSWORD=pass1234
sudo apt list -a opensearch
sudo apt install opensearch

# Клонировать ваш проект из Git
git clone git@github.com:MyLittleVerdant/ElasticInCloud.git

# Переместить содержимое проекта в /var/www/html
mv ElasticInCloud/* /var/www/html/

# Удалить пустую директорию проекта
rm -rf ElasticInCloud


# Установить Composer
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer

# Перейти в каталог вашего проекта и установить зависимости с помощью Composer
cd /var/www/html/
composer install

#запуск Opensearch
cd /usr/share/opensearch/bin/
./opensearch
