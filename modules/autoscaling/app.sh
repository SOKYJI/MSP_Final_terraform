#!/bin/bash

# Node.js 설치
curl -fsSL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt-get install -y nodejs

# 애플리케이션 코드 복사 또는 클론
# 예를 들어, GitHub 레포지터리에서 클론하는 경우:
git clone https://github.com/AnkitJodhani/2nd10WeeksofCloudOps.git
cd 2nd10WeeksofCloudOps/backend

# npm 패키지 설치
npm install

# 환경변수 파일 생성
# cat > .env <<EOF
# DB_HOST=<RDS_ENDPOINT>
# DB_USERNAME=song
# DB_PASSWORD=song1234
# PORT=3306
# EOF
echo "DB_HOST=${aws_rds_cluster.aurora_cluster.endpoint}" >> /etc/environment
echo "DB_USERNAME=song" >> /etc/environment
echo "DB_PASSWORD=song1234" >> /etc/environment
echo "DB_PORT=3306" >> /etc/environment
# PM2 설치
sudo npm install -g pm2

# MySQL 데이터베이스 및 테이블 생성
sudo apt-get install -y mysql-client
mysql -h <RDS_ENDPOINT> -u <DB_USERNAME> -p<DB_PASSWORD> -e "CREATE DATABASE IF NOT EXISTS test;"
mysql -h <RDS_ENDPOINT> -u <DB_USERNAME> -p<DB_PASSWORD> test < test.sql

# 애플리케이션 시작
pm2 start index.js --name "backendAPI"

# 서버가 재시작될 때 PM2 자동 실행 설정
pm2 startup systemd
sudo env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u ubuntu --hp /home/ubuntu
pm2 save
