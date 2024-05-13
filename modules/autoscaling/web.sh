#!/bin/bash

# 필요한 도구들을 설치합니다: git, Node.js
sudo apt-get update
sudo apt-get install -y git
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt-get install -y nodejs

# GitHub에서 프론트엔드 소스 코드를 클론합니다.
git clone https://github.com/AnkitJodhani/2nd10WeeksofCloudOps.git
cd 2nd10WeeksofCloudOps/client

# npm을 사용하여 필요한 패키지들을 설치합니다.
npm install
npm install dotenv --save

# .env 파일을 생성하고 API_BASE_URL을 설정합니다.
echo "API_BASE_URL=http://kyeongjin.store:80" > .env

# 빌드를 실행합니다.
npm run build