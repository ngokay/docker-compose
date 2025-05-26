```bash
docker build -t sftp .
docker run -d -p 2222:22 -v $(pwd)/users.conf:/etc/sftp/users.conf:ro sftp
-- window
docker run -d --name sftp -p 2222:22 -v %cd%/users.conf:/etc/sftp/users.conf sftp
```