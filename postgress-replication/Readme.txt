


docker exec -it etcd3 etcdctl --endpoints=http://127.0.0.1:2379 del --prefix /service/demo
docker exec -it etcd1 etcdctl --endpoints=http://127.0.0.1:2379 del --prefix /service/demo
docker exec -it etcd2 etcdctl --endpoints=http://127.0.0.1:2379 del --prefix /service/demo


--------------------------- Lưu ý----------------------------
1. thư mục bitnami
- tạo db replication db mater, replica 
- chỉ mater mới có quyền insert,update dữ liệu
- slave chỉ có quyền select dữ liệu

2. thư mục dockerfile
- tự tạo image patroni để tạo db theo mô hình database mater,slave, HAproxy

3. thư mục ha-patroni-docker-file
- tạo db theo mô hình mater,slave, HAproxy theo image build từ thư mục dockerfile
- khi mater off thì tự bầu mater từ slave
- replication(sao chép) dữ liệu từ mater -> slave
- chỉ mater mới có quyền insert,update dữ liệu
- slave chỉ có quyền select dữ liệu

4. thư mục HA-PostgreSQL-Patroni
- tạo db theo mô hình mater,slave, HAproxy theo image ghcr.io/zalando/spilo-15:3.1-p1 có sẵn
- khi mater off thì tự bầu mater từ slave
- replication(sao chép) dữ liệu từ mater -> slave
- chỉ mater mới có quyền insert,update dữ liệu
- slave chỉ có quyền select dữ liệu

5. thu mục postgres-test
- tạo db replication db mater, replica 
- chỉ mater mới có quyền insert,update dữ liệu
- slave chỉ có quyền select dữ liệu



------------------------ check cluster lead -------------------------------------- 
docker exec -it patroni1 patronictl -c /đường dẫn đến file mount vào/patroni.yml list
docker exec -it patroni1 patronictl -c /etc/patroni.yml list

------------------------- Tạo db -------------------------------------------------
B1: Vào container leader(cluster lead)
docker exec -it patroni1 psql -U postgres
B2: Tạo database
CREATE DATABASE mydb;
B3: Tạo bảng dữ liệu 
CREATE TABLE users (id SERIAL PRIMARY KEY,name TEXT);
B4: Insert dữ liệu test 
INSERT INTO users(name) VALUES ('Alice'), ('Bob');

------------------------ Kiem tra HAproxy --------------------------------------------
ubuntu: docker ps | grep haproxy
windown: docker ps | findstr haproxy

------------------------- Test HAproxy ----------------------------------------------
B1:
docker exec -it container_name psql -h container_name_haproxy -p cong_mount_ra_cua_HA -U postgres -d mydb
docker exec -it patroni3 psql -h haproxy -p 5000 -U postgres -d mydb
B2:
SELECT pg_is_in_recovery(); => true la replication, => false la leader

-------------------------- cmd ------------------------------------------------------
các lệnh tương đương trong ubuntu -> windown
grep → findstr
cat → Get-Content hoặc type