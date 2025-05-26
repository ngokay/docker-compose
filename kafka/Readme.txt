Lưu ý:
- dùng confluentinc/cp-kafka-connect muốn add các thư viện khác để tạo source, sink connector
thì khai báo enviroment : CONNECT_PLUGIN_PATH: "/usr/share/java,/etc/kafka-connect/jars"
tạo thư mục plugins -> mount từ thư mục plugins vào /etc/kafka-connect/jars của confluentinc/cp-kafka-connect
lưu ý khi thêm thư viện vào thư mục plugins thì thêm cả folder chứ không được thêm file .jar
ví dụ thêm thư viện debezium-connector-postgres thì thêm plugins/debezium-connector-postgres/...file .jar