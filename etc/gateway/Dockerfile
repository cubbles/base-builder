FROM nginx:1.7.9
#MAINTAINER Hd Böhlau "hans-dieter.boehlau@incowia.com"

COPY ./docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]