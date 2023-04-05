# 포팅 메뉴얼



## 목차

1. 환경설정 및 빌드 & 배포
2. 외부 서비스 문서
3. 시연시나리오



## 1. 환경설정 및 빌드&배포



### 개발환경



### Docker 설치

### Set up the repository

1. Update the `apt` package index and install packages to allow `apt` to use a repository over HTTPS:

```
 $ sudo apt-get update
 $ sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
```

1. Add Docker's official GPG key

```
 $ sudo mkdir -m 0755 -p /etc/apt/keyrings
 $ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o
 /etc/apt/keyrings/docker.gpg
```

1. Use the following command to set up the repository

```
$ echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

### Install Docker Engine

1. Update the apt package index

```
$ sudo apt-get update
```

1. Install Docker Engine, containerd, and Docker Compose

```
$ sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```



### MySQL 설치

### Install MySQL

```
$ sudo apt install mysql-server
$ sudo mysql -u root -p
$ CREATE USER '아이디'@‘%' identified with mysql_native_password by '비밀번호';
$ FLUSH PRIVILEGES;
$ create database etjude;
$ use hero_db;
GRANT ALL PRIVILEGES ON etjude.* to ‘아이디'@‘%';
```



### 외부 접속 허용

```
$ sudo vi /etc/mysql/mysql.conf.d/mysqld.cnf
bind-address값을 0.0.0.0 으로 수정
$ sudo servie mysql restart
```



### Nginx 설치

```jsx
$ sudo apt-get install nginx
```



### **Encrypt(SSL 발급)**

```jsx
$ sudo apt-get install letsencrypt
$ sudo letsencrypt certonly --standalone -d [도메인]
```



### Nginx 설정

```jsx
$ cd /etc/nginx/sites-enabled
내부의 default 설정

server{
   location / {
            proxy_pass <http://localhost:3000/>;
            proxy_hide_header Access-Control-Allow-Origin;
            add_header 'Access-Control-Allow-Origin' '*';
            add_header 'Access-Control-Allow-Methods' 'GET, POST, DELETE, PUT, PATCH, OPTIONS';
            add_header 'Access-Control-Allow-Headers' 'Content-Type, Authorization';

    }
    location /api {
            proxy_pass <http://localhost:8080/api>;
    }
    location /ai-api{
            proxy_pass http://localhost:8081/ai-api/v1;
    }

    listen 443 ssl;
    ssl_certificate /etc/letsencrypt/live/도메인/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/도메인/privkey.pem;
    }
server {

    if ($host = 도메인) {
        return 301 https://$host$request_uri;
    }
        listen 80;
        server_name 도메인;
    return 404;
}
```

### 환경변수 형태

```jsx
---------Spring------------
application.yml 내 환경변수 설정

src/main/resources내의 application.yml파일과 같은 위치에 아래 파일을 생성

# MySQL(application-db.yml으로 생성)
spring:
  datasource: 
    url: jdbc:mysql://{도메인주소}:3306/{db_name}?useUnicode=true&serverTimezone=Asia/Seoul
    username: {user_name}
    password: {user_pw}
    driver-class-name: com.mysql.cj.jdbc.Driver


----------Python-------------
.env 내 환경변수 설정
region_name=설정한 지역명,
bucket_name=설정한 버킷명,
aws_access_key_id = 엑세스 키 ID,
aws_secret_access_key = 비밀 엑세스 키

-------Front-End------------
# android/app/key.properties
storePassword={발급받은 서명키 비밀번호}
keyPassword={발급받은 서명키 비밀번호}
keyAlias={서명키 aliase 이름}
storeFile={.jks 파일 저장 위치}

# android/local.properties
sdk.dir={안드로이드 sdk 경로}
flutter.sdk={플러터 sdk 경로}
flutter.buildMode={빌드 모드 debug 또는 release}
flutter.versionName={버전 이름}
flutter.versionCode={버전 코드}

#.env
TMAP_API_KEY={key}
```



### Ignore 파일 및 생성파일 위치

- Spring : application-db.yml (main/resources/applicaion-db.yml)
- FastAPI: .env (최상단 디렉토리)
- Flutter: 



## 빌드 및 배포

### 프론트엔드 빌드

```jsx
# appbundle
배포용 => flutter build appbundle --release
개발용 => flutter build appbundle --debug

# apk
배포용 => flutter build apk --release
개발용 => flutter build apk --debug
```



### 백엔드 빌드

```jsx
# 스프링 빌드
Mac => ./gradlew clean build 후 ./gradlew build 진행
Windows => ./gradlew.bat clean build 후 ./gradlew.bat build 진행

build -t DockerHubID/DockerHubRepo:be-latest .

# 파이썬 빌드
build -t DockerHubID/DockerHubRepo:fastapi-latest .
```

### 배포

```jsx
백엔드의 이미지를 풀 받은 후 컨테이너 실행
docker pull DockerHubID/DockerHubRepo:해당tag

# 백엔드(스프링)
docekr run --rm -d -p 8080:8080 --name be-latest 이미지ID
# 백엔드(FastAPI)
docekr run --rm -d -p 8081:8081 --name fastapi-latest 이미지ID


컨테이너 확인 : docker ps
```



## 2. 외부 서비스 문서

### FireBase

1. FireBase 프로젝트 생성

   - firebase 로그인 후 Firebase 콘솔에서 “프로젝트 추가” 버튼 클릭
   - 프로젝트 이름 입력 → 계속 → (애널리틱스 화면) 계속 → 계정 선택 후 프로젝트 만들기

2. SDK 설정

   - 해당 프로젝트 콘솔로 접속
   - 웹 아이콘 (</>) 클릭
     - 앱 닉네임 등록, firebase sdk 추가 (npm 사용 체크)
     - 콘솔로 이동

3. Authentication 설정

   - 콘솔에서 Authentication 클릭 → 로그인 방법 설정 클릭
   - 추가 제공업체 클릭 (구글)
   - 사용설정 토글 on
   - 프로젝트의 공개용 이름 설정(default 사용), 이메일 입력 ⇒ 저장

4. 도메인 연결

   - Authentication 탭이동
   - 승인된 도메인 탭 클릭
   - 도메인 추가

5. Firebase package 설치

   ```jsx
   npm install firebase
   ```

### S3

1. https://www.aws.amazon.com/ 에 가입 후 S3로 이동
2. 프로젝트에 사용할 버킷을 생성
3. 버킷 이름, 리전, 퍼블릭 액세스 설정
4. IAM 에서 사용자 생성 후 AmazonS3FullAccess 권한 부여
5. 생성한 사용자의 AccessKey와 SecretKey를 발급 받고 프로젝트에 적용

### AWS S3 Bucket 설정

1. 버킷 정책

   ```json
   {
       "Version": "2012-10-17",
       "Statement": [
           {
               "Sid": "PublicReadGetObject",
               "Effect": "Allow",
               "Principal": "*",
               "Action": "s3:GetObject",
               "Resource": "arn:aws:s3:::s3ffmpegtest/*"
           }
       ]
   }
   ```

2. ACL

   - 버킷 소유자
     - 객체 : 나열, 쓰기, 읽기
     - 버킷 ACL : 읽기, 쓰기
   - 버킷 소유자
     - 객체 : 읽기
     - 버킷 ACL : 읽기

3. CORS

   ```json
   [
       {
           "AllowedHeaders": [
               "*"
           ],
           "AllowedMethods": [
               "HEAD",
               "GET",
               "PUT",
               "POST",
               "DELETE"
           ],
           "AllowedOrigins": [
               "*"
           ],
           "ExposeHeaders": [
               "ETag",
               "x-amz-meta-custom-header"
           ]
       }
   ]
   ```

   

   ## 3. 시연 시나리오

   

   #### 로그인 & 로그아웃(구글OAuth)

   - 로그인 버튼을 누른 후 소셜 로그인을 진행할 수 있습니다
   

![로그인.gif](./assets/로그인.gif)



