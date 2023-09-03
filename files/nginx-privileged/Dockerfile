FROM nginx:latest

RUN apt-get update && \
    apt-get install -y --no-install-recommends python3

## Copy the modified config where user is disabled
COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./default.conf /etc/nginx/conf.d/default.conf

WORKDIR /app

## add permissions
RUN mkdir -p /var/cache/nginx/client_temp && \
    mkdir -p /var/cache/nginx/proxy_temp
RUN chown -R nginx:nginx /app && chmod -R 755 /app && \
        chown -R nginx:nginx /var/cache/nginx && \
        chown -R nginx:nginx /var/log/nginx && \
        chown -R nginx:nginx /etc/nginx/conf.d && \
        chown -R nginx:nginx /var/cache/nginx/client_temp && \
        chown -R nginx:nginx /var/cache/nginx/proxy_temp
RUN touch /var/run/nginx.pid && \
        chown -R nginx:nginx /var/run/nginx.pid

## switch to non-root user
USER nginx

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]