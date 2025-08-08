Lưu ý
- user full quyền : elastic
- authen kibana qua cấu hình elasticsearch.serviceAccountToken
- cách lấy elasticsearch.serviceAccountToken 
curl --location --request POST 'http://localhost:9200/_security/service/elastic/kibana/credential/token/token1' \
--header 'Authorization: Basic ZWxhc3RpYzphbmhudDkzQA=='
- thay token sau đó restart :  docker compose restart


- cấu hình logstash:
	- lấy log từ filebeat đẩy vào elasticsearch
	- lấy log từ http: gọi api
	- lấy log từ tcp: 
	- lấy trực tiếp từ file : mount thư mục chứa file log vào thư mục /usr/share/logstash/logs/logfile.log của logstash để đọc được dữ liệu log
- cấu hình filebeat
	- có thể lấy data từ nhiều nguồn xử lý tổng hợp trên logstash qua filter config của logstash
	- có thể đẩy trực tiếp vào elasticsearch không cần qua filebeat
	- cấu hình đọc log từ file, đẩy vào filebeat -> đẩy lên logstash -> đẩy lên elastic
		+ B1 : mount dữ liệu từ thư mục chứa log vào filebeat
			volumes:
				- ./log:/usr/share/filebeat/logs:ro : giải thích mount dữ liệu từ thư mục log vào thư mục filebeat trên filebeat
		+ B2 : cấu hình đọc dữ liệu trong file filebeat.yml
			chú ý phần đường dẫn 
			paths:
				- /usr/share/filebeat/logs/*.json : giải thích : thư mục chứa log vừa mount ở bước 1 vào
- cấu hình kafka
	- có thể đẩy dữ liệu từ kafka lên elasticsearch qua filebeat
	- hoặc đẩy dữ liệu từ kafka lên elasticsearch qua kafka connect
