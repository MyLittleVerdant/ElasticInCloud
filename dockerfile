# Используем образ PHP с Apache
FROM php:8.1-apache

# Обновляем пакеты и устанавливаем необходимые инструменты
RUN apt-get update && apt-get upgrade -y && apt-get install -y git unzip

# Устанавливаем Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

COPY . /var/www/html/

# Открываем порт 80
EXPOSE 80

# Копируем файлы приложения в контейнер
#COPY ./app /var/www/html/app
#
## Копируем файлы composer и устанавливаем зависимости
#COPY ./composer.json /var/www/html/app/composer.json
#COPY ./composer.lock /var/www/html/app/composer.lock
#COPY ./vendor /var/www/html/app/vendor

# Изменяем корневую директорию документов на /var/www/html/app
#RUN sed -i 's!/var/www/html!/var/www/html/app!g' /etc/apache2/sites-available/000-default.conf

