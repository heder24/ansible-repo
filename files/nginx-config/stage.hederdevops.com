server {
    listen      80;
    server_name stage.hederdevops.com www.stage.hederdevops.com;
    charset utf-8;
    root    /var/www/html/web-apps;
    index   index.html;
    #Always serve index.html for any request
    gzip            on;
    gzip_types      text/plain application/xml text/css application/javascript;
    gzip_min_length 1000;
    location / {
        root /var/www/html/web-apps;
        try_files $uri  /index.html;
    }
    error_log  /var/log/nginx/vue-app-error.log;
    access_log /var/log/nginx/vue-app-access.log;
}