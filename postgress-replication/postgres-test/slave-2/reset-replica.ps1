# ================================
# Reset và chuẩn bị Replica PostgreSQL trên Docker
# ================================

# Cấu hình
$ReplicaContainer = "postgres-replica-2"
$ReplicaVolume    = "postgres-test_replica_data-2"
$PGUser           = "replicator"
$PGPass           = "Ngotheanh93@"
$PrimaryHost      = "postgres-primary"
$PGPort           = 5432
$Network          = "postgres-test_pg-net"

Write-Host "Chuan bi Replica PostgreSQL..."

# 1. Stop + remove container replica
if (docker ps -a --format '{{.Names}}' | Select-String -Pattern "^$ReplicaContainer$") {
    Write-Host "Dung va xoa container replica: $ReplicaContainer"
    docker stop $ReplicaContainer | Out-Null
    docker rm $ReplicaContainer   | Out-Null
} else {
    Write-Host "Container $ReplicaContainer chua ton tai."
}

# 2. Remove replica volume
if (docker volume ls --format '{{.Name}}' | Select-String -Pattern "^$ReplicaVolume$") {
    Write-Host "Xoa volume replica: $ReplicaVolume"
    docker volume rm $ReplicaVolume | Out-Null
} else {
    Write-Host "Volume $ReplicaVolume chua ton tai."
}

# 3. Tạo volume mới
Write-Host "Tao volume moi: $ReplicaVolume"
docker volume create $ReplicaVolume | Out-Null

# 4. Thực hiện pg_basebackup trong container tạm
Write-Host "Thuc hien pg_basebackup tu primary ($PrimaryHost)..."
$MountPath = docker volume inspect --format '{{ .Mountpoint }}' $ReplicaVolume
docker run -i --rm `
    --network $Network `
    -e "PGPASSWORD=$PGPass" `
    -v "${MountPath}:/var/lib/postgresql/data" `
    postgres:15 `
    bash -c "pg_basebackup -h $PrimaryHost -p $PGPort -U $PGUser -D /var/lib/postgresql/data -W -P -R"

# 5. Cấu hình standby
Write-Host "Cau hinh standby..."
docker run -i --rm `
    -v "${MountPath}:/var/lib/postgresql/data" `
    postgres:15 `
    bash -c "touch /var/lib/postgresql/data/standby.signal && echo \"primary_conninfo = 'host=$PrimaryHost port=$PGPort user=$PGUser password=$PGPass'\" >> /var/lib/postgresql/data/postgresql.conf"

# 6. Start lại replica
Write-Host "Start lai container replica..."
docker start $ReplicaContainer 2>$null
if ($LASTEXITCODE -ne 0) {
    docker compose up -d $ReplicaContainer
}

Write-Host "Replica da san sang. Xem log voi:"
Write-Host "docker logs -f $ReplicaContainer"
docker logs -f $ReplicaContainer
