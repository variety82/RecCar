# 포팅 메뉴얼



## 목차

1. 환경설정 및 빌드 & 배포
2. 외부 서비스 문서
3. 시연시나리오



## 1. 환경설정 및 빌드&배포



### 개발환경

![개발환경](../assets/stack.png)

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
- Flutter: ./env



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

### 프론트엔드 배포
1. 구글 개발자 계정 생성
    - 구글 플레이 콘솔 접속 및 개발자 계정 생성($25)

2. 앱 제작
    - 우측 상단 "앱 만들기" 버튼 클릭
    - 세부 정보 입력
        - 이름, 언어(KR), 앱, 무료, 동의

3. 앱 설정
    - 개인정보처리방침 설정
        - 개인정보 포털의 개인정보 처리방침 만들기 기능 사용
        - https://www.privacy.go.kr/front/per/inf/perInfStep01.do
    - 액 액세스 권한
    - 광고
    - 콘텐츠 등급
    - 타겟층
    - 뉴스 앱
    - 코로나19 접촉자 추적 앱 및 이력 앱
    - 데이터 보안
    - 정부 앱

4. 스토어 설정
    - 앱 카테고리 선택 및 연락처 세부정보 제공
    - 스토어 등록정보 설정

5. 버전 생성 및 게시
    - 국가 및 지역 선택: KR
    - 새 버전 만들기
        - 빌드 한 AppBundle 업로드


### 백엔드 빌드

```jsx
# 스프링 빌드
Mac => ./gradlew clean build 후 ./gradlew build 진행
Windows => ./gradlew.bat clean build 후 ./gradlew.bat build 진행

build -t DockerHubID/DockerHubRepo:be-latest .

# 파이썬 빌드
build -t DockerHubID/DockerHubRepo:fastapi-latest .
```

### 백엔드 배포

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

### Oauth2.0
1. Oauth 프로젝트 생성
   
    - 상단 메뉴바에서 프로젝트 이름 클릭
    - 모달에서 "새 프로젝트 생성" 버튼 클릭1

2. Oauth 동의 화면 생성

    - 생성한 프로젝트의 우측 메뉴 콘솔에서 "Oauth 동의 화면" 클릭
    - UserType : 외부 -> 필수 항목 입력
    - 범위: 기본, 개인정보, openId
    - 생성

3. Oauth 클라이언트 ID 생성 
    - 우측 메뉴바 "사용자 인증 정보" 클릭
    - 상단 "사용자 인증 정보 만들기" => "Oauth 클라이언트 ID" 클릭
    - 애플리케이션 유형: "Android"
    - 필수 항목 입력: 이름, 패키지 이름, SHA-1 인증서
    - 만들기

### FireBase

1. FireBase 프로젝트 생성

   - firebase 로그인 후 Firebase 콘솔에서 “프로젝트 추가” 버튼 클릭
   - 프로젝트 이름 입력 → 계속 → (애널리틱스 화면) 계속 → 계정 선택 후 프로젝트 만들기

2. SDK 설정

   - 해당 프로젝트 콘솔로 접속
   - Flutter 아이콘 클릭
   - Firebase CLI 설치 및 로그인 flutter sdk 설치(안되어 있을 경우)
   - flutter 프로젝트의 루트 디렉토리에서 다음 명령어 실행
    ```jsx
     - dart pub global activate flutterfire_cli
     - flutterfire configure {firebase 프로젝트 id}
    ```
   - flutter 프로젝트 main.dart에서 import하여 호출

3. 사용자 및 권한 설정

   - 우측 메뉴바 프로젝트 개요 옆 톱니바퀴 클릭 => "사용자 및 권한" 클릭
   - "일반" 탭 에서 지원 이메일 입력
   - 하단 SHA-1 서명키에서 .jks로 발급받은 debug / release SHA-1 키 입력
   - google-services.json => android/app 으로 copy

4. Authentication 설정

   - Authentication 탭 이동
   - sign-in method 탭 이동
   - 이메일/비밀번호 및 Google 추가


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

   

### 소셜 로그인(로그인 & 로그아웃(구글OAuth))

- RecCar의 경우, 로그인을 한 사용자만 서비스를 이용하는 것이 가능합니다.
- 로그인 버튼을 누른 후 소셜 로그인을 진행할 수 있습니다.
- 현재 소셜 로그인은 구글 계정으로만 가능합니다.
- 로그인 완료 시, 자동으로 홈 화면으로 이동합니다.

<div align="center">
​	![로그인](../assets/login.gif)
</div>


### 근처 렌트카존 찾기

- 화면 하단의 Footer에서 지도 아이콘을 클릭할 시, 렌트카존 찾기 화면으로 이동합니다.
- 위치 정보 권한 허가 시 현재 자신의 위치를 파란 점 형태로 확인이 가능합니다.
- 하단의 ‘쏘카존 보기’, ‘그린존 보기’를 클릭할 시 해당 렌트카 존이 어디에 있는지를 시각적으로 확인할 수 있습니다.
- 상단의 검색 바에 검색어를 입력할 경우, 해당 검색어와 관련된 지점의 정보를 하단의 모달에서 확인할 수 있습니다.
  - 각 항목을 클릭할 시 현재 위치에서 해당 지점까지 도보로 얼마나 걸리는지도 확인이 가능합니다.

<div align="center">
    ![지도](../assets/map.gif)
</div>
### 일정관리(차량 대여 및 반납 일자)

- 화면 하단의 Footer에서 캘린더 아이콘을 선택할 시, 일정 관리 화면으로 이동합니다.
- 일정 관리 화면에서는 현재 날짜에 맞춘 달력과, 각 일자에 따른 일정 목록을 확인할 수 있습니다.
- 화면 하단 우측의 플로팅 버튼(+)을 클릭할 시, 새롭게 일정을 추가할 수 있습니다.
  - 일정 추가 시, 제목(TITLE)과 해당되는 날짜, 그리고 메모(MEMO)를 입력하게 됩니다.
- 차량 대여 시, 대여 일정과 반납 일정이 해당 일자에 맞춰 자동으로 추가됩니다.
- 한 번 등록한 일정은 수정과 삭제가 가능합니다.
  - 단, 차량 대여 시 자동으로 생성된 일정의 경우 삭제가 불가능합니다.

<div align="center">
![일정관리](../assets/calander.gif)
</div>
### 차량 영상 등록

- 홈 화면, 또는 화면 하단 Footer의 카메라 아이콘 버튼을 클릭할 시, 아직 대여 직후, 반납 직전 손상을 기록하지 않았을 시, 차량 손상을 등록하는 것이 가능합니다.
- AI로 분석할 차량 영상의 경우 직접 촬영하거나, 이미 촬영한 영상을 갤러리에서 선택하여 업로드하는 방법 총 두 가지가 존재합니다.
  - 영상 촬영을 선택했을 경우, 촬영 후 영상 확인이 가능합니다.
- 영상 촬영 또는 선택 후, 일정 시간 동안 AI를 통한 분석이 진행되며, 분석이 완료되었을 시 차량 손상 확인 페이지로 이동합니다.

<div align="center">
![차량등록](../assets/regist.gif)
</div>
