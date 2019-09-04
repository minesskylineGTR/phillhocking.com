server {
    listen 80 default_server;
    listen [::]:80 default_server ipv6only=on;
    server_name _;
    root /usr/share/nginx/html;
    index index.html index.htm;
    client_max_body_size 1G;

    location / {
        proxy_pass http://localhost:2368;
        proxy_set_header X-Forwarded-For $${replace("%proxy_add_x_forwarded_for", "%", "\\$")};
        proxy_set_header Host $${replace("%http_host", "%", "\\$")};
        proxy_set_header X-Forwarded-Proto https;
        proxy_buffering off;
    }

    location ~ ^/img_responsive/([0-9]+)(?:/(.*))?$${replace("%", "%", "\\$")} {
      proxy_pass http://localhost:2368/$${replace("%2", "%", "\\$")};
      proxy_set_header X-Forwarded-For $${replace("%proxy_add_x_forwarded_for", "%", "\\$")};
      proxy_set_header Host $${replace("%http_host", "%", "\\$")};
      proxy_set_header X-Forwarded-Proto https;
      proxy_buffering off;
      image_filter_buffer 10M;
      image_filter_jpeg_quality 80;
      image_filter resize $${replace("%1", "%", "\\$")} -;
    }

    location ~ ^/t/(.*)?$${replace("%", "%", "\\$")} {
      proxy_pass http://localhost:2368/tag/$${replace("%1", "%", "\\$")};
      proxy_set_header X-Forwarded-For $${replace("%proxy_add_x_forwarded_for", "%", "\\$")};
      proxy_set_header Host $${replace("%http_host", "%", "\\$")};
      proxy_set_header X-Forwarded-Proto https;
      proxy_buffering off;
    }

    location /subscribe/?(.*)$${replace("%", "%", "\\$")} {
    }

    location = /health {
      return 200;
      #access_log off;
    }
}
