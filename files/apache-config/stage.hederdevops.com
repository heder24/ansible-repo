<VirtualHost *:80>
    ServerName stage.hederdevops.com www.stage.hederdevops.com
    DocumentRoot /var/www/html/web-apps
    DirectoryIndex index.html
    CharsetDefault utf-8

    <Directory /var/www/html/web-apps>
        Options Indexes FollowSymLinks
        AllowOverride None
        Require all granted
    </Directory>

    # Always serve index.html for any request
    <FilesMatch "^index\.html$">
        ForceType 'text/html; charset=utf-8'
        SetHandler default-handler
    </FilesMatch>

    # Enable Gzip compression
    <IfModule mod_deflate.c>
        SetOutputFilter DEFLATE
        AddOutputFilterByType DEFLATE text/plain application/xml text/css application/javascript
        DeflateMinLength 1000
    </IfModule>

    # Custom configuration for web-app
    Alias /web-app /var/www/html/web-apps
    <Directory /var/www/html/web-apps>
        Options Indexes FollowSymLinks
        AllowOverride None
        Require all granted
    </Directory>

    # Error and access logs
    ErrorLog /var/log/apache2/vue-app-error.log
    CustomLog /var/log/apache2/vue-app-access.log combined
</VirtualHost>
