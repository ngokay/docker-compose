# Sử dụng hình ảnh base atmoz/sftp
FROM atmoz/sftp

RUN mkdir -p /home/sftpuser/upload
RUN mkdir -p /home/sftpuser/outbox
RUN chmod -R 777 /home/sftpuser
# Expose cổng 22 để kết nối SFTP
EXPOSE 22