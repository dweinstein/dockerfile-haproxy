FROM haproxy:latest
ADD run.sh /run.sh
EXPOSE 8080
CMD ["bash", "/run.sh"]
