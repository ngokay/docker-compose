- dùng debezium : link document https://debezium.io/documentation/reference/3.1/
lưu ý: dùng ETL db postgresql thì db phải có quyền wal_level là logical 
ALTER SYSTEM SET wal_level = 'logical';
ALTER SYSTEM SET max_replication_slots = 10;
ALTER SYSTEM SET max_wal_senders = 10;

config source connector
http://localhost:8083/connectors
{
  "name": "pg-connector",
  "config": {
    "connector.class": "io.debezium.connector.postgresql.PostgresConnector",
    "database.hostname": "postgres",
    "database.port": "5432",
    "database.user": "postgres",
    "database.password": "anhnt93",
    "database.dbname": "test_kafka_connect",
    "database.server.name": "demo_server",
    "plugin.name": "pgoutput",
    "slot.name": "debezium_slot",
    "publication.name": "debezium_pub",
    "table.include.list": "public.users", 
    "topic.prefix": "demo-source-topic",
    "key.converter": "org.apache.kafka.connect.json.JsonConverter",
    "key.converter.schemas.enable": true,
    "value.converter": "org.apache.kafka.connect.json.JsonConverter",
    "value.converter.schemas.enable": true
  }
}

config sink connector
http://localhost:8083/connectors
{
    "name": "sink-connector",  
    "config": {
        "connector.class": "io.debezium.connector.jdbc.JdbcSinkConnector",  
        "tasks.max": "1",  
        "connection.url": "jdbc:postgresql://postgres/test_sink_connect",  
        "connection.username": "postgres",  
        "connection.password": "anhnt93",  
        "insert.mode": "upsert",  
        "delete.enabled": "true",  
        "primary.key.mode": "record_key",
        "pk.fields": "id",  
        "schema.evolution": "basic",  
        "use.time.zone": "UTC",  
        "topics": "demo-source-topic.public.users",
        "key.converter": "org.apache.kafka.connect.json.JsonConverter",
        "key.converter.schemas.enable": true,
        "value.converter": "org.apache.kafka.connect.json.JsonConverter",
        "value.converter.schemas.enable": true,
        "transforms": "RenameTable",
        "transforms.RenameTable.type": "org.apache.kafka.connect.transforms.RegexRouter",
        "transforms.RenameTable.regex": ".*",
        "transforms.RenameTable.replacement": "users" 
    }
}

xóa connector
http://localhost:8083/connectors/sink-connector

tất cả connector
http://localhost:8083/connectors

kiểm tra trạng thái connector
http://localhost:8083/connectors/pg-connector/status