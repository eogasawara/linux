WordPress (producao, Ubuntu 24.04 LTS).

Dependencias:
- Apache (ver `05-web-apache-https.md`)
- MySQL (instalado em `05-web-apache-https.md`)

Pacotes base (PHP 8.3 no Ubuntu 24):
```bash
apt-get update
apt-get upgrade
apt-get install apache2 mysql-server
apt-get install php libapache2-mod-php php-cli php-mysql
apt-get install php-curl php-gd php-intl php-mbstring php-xml php-zip php-soap
apt-get install unzip curl
```

Banco de dados:
```sql
CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'wordpress'@'localhost' IDENTIFIED BY '<PASSWORD>';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'localhost';
FLUSH PRIVILEGES;
```

Instalar WordPress (public_html do usuario):
```bash
cd /home
curl -O https://wordpress.org/latest.tar.gz
tar -xvzf latest.tar.gz
rm latest.tar.gz
cp -r /home/wordpress/* /home/foo/public_html/
chown -R www-data:www-data /home/foo/public_html
find /home/foo/public_html -type d -exec chmod 755 {} \;
find /home/foo/public_html -type f -exec chmod 644 {} \;
```

WP-CLI (opcional):
```bash
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp
wp --info
```

Atualizacoes (opcional):
```bash
sudo -u www-data wp core update
sudo -u www-data wp config set WP_AUTO_UPDATE_CORE true --raw
sudo -u www-data bash -c "wp theme list --status=inactive --field=name | xargs -n1 wp theme delete"
sudo -u www-data bash -c "wp plugin list --status=inactive --field=name | xargs -n1 wp plugin delete"
sudo -u www-data wp theme update --all
sudo -u www-data wp plugin update --all
sudo -u www-data bash -c "wp plugin list --field=name | xargs -n1 wp plugin auto-updates enable"
sudo -u www-data bash -c "wp theme list --field=name | xargs -n1 wp theme auto-updates enable"
```

Referencias:
- https://wordpress.org/support/article/how-to-install-wordpress/
