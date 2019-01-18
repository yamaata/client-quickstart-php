#
# client-quickstart-php Server
#
FROM php:7.3.1
LABEL vendor="KDDI Web Communications inc." \
    maintainer="yuto.yamada@kddi-web.com"

# Required library
RUN apt-get update && apt-get install -y \
    git \
    zip \
    unzip \
    gnupg \
    --no-install-recommends

# Install nodejs
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && apt-get install -y \
    nodejs \
    --no-install-recommends

RUN rm -rf /var/lib/apt/lists/*

# Set workdir
ENV HOME=/var/www/html
WORKDIR $HOME

# Install composer
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && composer self-update

# Copy package manager setting
COPY composer.json composer.lock ./

# Create user
RUN useradd --user-group --create-home --shell /bin/false app
RUN chown -R app:app $HOME
USER app

# Resolve dependency
RUN composer install
RUN npm install

CMD ["php", "-S", "0.0.0.0:8000"]
