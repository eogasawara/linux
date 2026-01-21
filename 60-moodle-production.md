Moodle (producao, Ubuntu 24.04 LTS).

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
apt-get install graphviz aspell ghostscript
apt-get install git certbot python3-certbot-apache ufw nano
```

Diretorios:
```bash
mkdir -p /var/www/moodle
mkdir -p /var/moodledata
chown -R www-data:www-data /var/www/moodle /var/moodledata
chmod -R 0755 /var/www/moodle
chmod -R 0770 /var/moodledata
```

Instalar Moodle 4.4 LTS (git):
```bash
cd /opt
git clone https://github.com/moodle/moodle.git
cd moodle
git checkout MOODLE_404_STABLE
rsync -av --delete /opt/moodle/ /var/www/moodle/
```

MySQL:
```sql
CREATE DATABASE moodle DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'moodle'@'localhost' IDENTIFIED BY '<PASSWORD>';
GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,CREATE TEMPORARY TABLES,DROP,INDEX,ALTER ON moodle.* TO moodle@localhost;
FLUSH PRIVILEGES;
```

Instalacao inicial (CLI):
```bash
sudo -u www-data /usr/bin/php /var/www/moodle/admin/cli/install.php
```

Upgrade (CLI):
```bash
sudo -u www-data /usr/bin/php /var/www/moodle/admin/cli/upgrade.php
```

Restore de backup (opcional):
```bash
rsync -av /backup/www/html/moodle/ /var/www/moodle/
mysql -u root moodle < /backup/mysql/moodle
rsync -av /backup/www/moodledata/ /var/moodledata/
chown -R www-data:www-data /var/www/moodle /var/moodledata
```

Referencias:
- https://docs.moodle.org/
