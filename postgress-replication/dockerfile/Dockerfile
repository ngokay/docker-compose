FROM python:3.11-slim

# Cài dependency
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    lsb-release \
    ca-certificates \
    dumb-init \
    gcc \
    libpq-dev \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Thêm PostgreSQL repo
RUN echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
    && curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor -o /etc/apt/trusted.gpg.d/pgdg.gpg

# Cài Postgres 15 (server + client)
RUN apt-get update && apt-get install -y \
    postgresql-15 \
    postgresql-client-15 \
    && rm -rf /var/lib/apt/lists/*

# Tạo thư mục dữ liệu cho postgres
RUN mkdir -p /var/lib/postgresql/data && chown -R postgres:postgres /var/lib/postgresql

# Tải Patroni từ repo Zalando
WORKDIR /app
RUN curl -L https://github.com/zalando/patroni/archive/refs/heads/master.tar.gz | tar zx --strip-components=1

# Cài Patroni + etcd driver + PostgreSQL driver
RUN pip install --no-cache-dir ".[etcd]" psycopg2-binary .

# Chạy bằng user postgres
USER postgres

RUN mkdir -p /var/lib/postgresql/data \
    && chown -R postgres:postgres /var/lib/postgresql/data \
    && chmod 700 /var/lib/postgresql/data

# Patroni binary nằm trong /usr/local/bin/patroni
ENTRYPOINT ["dumb-init", "--", "/usr/local/bin/patroni"]
