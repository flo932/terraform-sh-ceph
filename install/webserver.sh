apt update ; apt upgrade -y


apt install -y lighttpd
apt install -y php-cgi
apt install -y php7.4-xml

cd /etc/lighttpd/conf-enabled
ln -s ../conf-available/10-cgi.conf .


systemctl restart lighttpd


cd /etc/lighttpd/conf-enabled
ln -s ../conf-available/10-ssl.conf .

mkdir -p /etc/lighttpd/ssl
cd /etc/lighttpd/ssl

apt install -y lighttpd-mod-openssl/stable
openssl req -new -newkey rsa:2048 -nodes -keyout server.key -out server.csr  -subj '/CN=dokuwiki.local/O=My >Company Name LTD./C=US'
openssl x509 -req -days 3650 -in server.csr -signkey server.key -out server.crt
cat server.key server.crt > server.pem
chmod 0600 /etc/lighttpd/ssl/server.*
wwwuser=lighttpd
wwwuser=www-data
chown $wwwuser:$wwwuser /etc/lighttpd/ssl/server.* -R
cp server.pem /etc/lighttpd/server.pem
cd 
systemctl restart lighttpd




fname='/etc/php8/php.ini'
fname='/etc/php/7.4/cgi/php.ini'
sed -i 's/display_errors = Off/display_errors = On/' $fname
sed -i 's/short_open_tag = Off/short_open_tag = On/' $fname
#display_errors = On


