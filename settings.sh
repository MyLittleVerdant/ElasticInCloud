#!/bin/bash

# Обновить пакеты
sudo apt-get update

# Установить PHP и Apache
sudo apt-get install -y apache2 php libapache2-mod-php

# Установить Git
sudo apt-get install -y git

# Клонировать ваш проект из Git
git clone https://github.com/MyLittleVerdant/ElasticInCloud.git

# Установить Java (требуется для Elasticsearch)
sudo apt-get install -y openjdk-11-jdk

# Установить Elasticsearch
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.8.0-amd64.deb
sudo dpkg -i elasticsearch-8.8.0-amd64.deb
sudo systemctl start elasticsearch
sudo systemctl enable elasticsearch

# Установить Composer
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer

# Перейти в каталог вашего проекта и установить зависимости с помощью Composer
cd ElasticInCloud
composer install
