# 🚗RecCar 자동차 손상 관리 서비스

### 프로젝트 진행 기간

2023.02.27(월) ~ 2023.04.07(금)

## Team Members

<div align="left">
  <table>
    <tr>
        <td align="center">
        <a href="">
          <img src="./assets/ch.PNG" alt="김창현 프로필" width=120 height=120 />
        </a>
      </td>
      <td align="center">
        <a href="">
          <img src="./assets/hero.jpg" alt="김영웅 프로필" width=120 height=120 />
        </a>
      </td>
      <td align="center">
        <a href="">
          <img src="./assets/tk.jpg" alt="김태균 프로필" width=120 height=120 />
        </a>
      </td>
      <td align="center">
        <a href="">
          <img src="./assets/sh.PNG" alt="원송희 프로필" width=120 height=120 />
        </a>
      </td>
      <td align="center">
        <a href="">
          <img src="./assets/dh.jpg" alt="임두현 프로필" width=120 height=120 />
        </a>
      </td>
      <td align="center">
        <a href="">
          <img src="./assets/jy.jpg" alt="임주연 프로필" width=120 height=120 />
        </a>
      </td>
    </tr>
    <tr>
      <td align="center">
        <a href="https://github.com/variety82/">
          김창현
        </a>
      </td>
      <td align="center">
        <a href="https://github.com/Woong1201">
          김영웅
        </a>
      </td>
      <td align="center">
        <a href="https://github.com/TannyKim">
          김태균
        </a>
      </td>
      <td align="center">
        <a href="https://github.com/songheewon">
          원송희
        </a>
      </td>
      <td align="center">
        <a href="https://github.com/ldhldh07">
          임두현
        </a>
      </td>
        <td align="center">
        <a href="">
          임주연
        </a>
      </td>
    </tr>
  </table>
</div>



## 🚦등장 배경



## 개요

## Usage

```
git clone https://lab.ssafy.com/s08-ai-image-sub2/S08P22A102.git
이후 exec폴더의 포팅메뉴얼을 따라 진행
```

### 개발환경



## Service Architecture

![Architecture](./assets/Architecture.png)



### 📂디렉토리 구조

```html
<details>
    <summary>
    백엔드 디렉토리 구조
    </summary>
    ├─main
    │  ├─java
    │  │  └─com
    │  │      └─heros
    │  │          ├─api
    │  │          │  ├─calendar
    │  │          │  │  ├─controller
    │  │          │  │  ├─dto
    │  │          │  │  │  ├─request
    │  │          │  │  │  └─response
    │  │          │  │  ├─entity
    │  │          │  │  ├─repository
    │  │          │  │  └─service
    │  │          │  ├─car
    │  │          │  │  ├─controller
    │  │          │  │  ├─dto
    │  │          │  │  │  ├─request
    │  │          │  │  │  └─response
    │  │          │  │  ├─entity
    │  │          │  │  ├─repository
    │  │          │  │  └─service
    │  │          │  ├─detectionInfo
    │  │          │  │  ├─controller
    │  │          │  │  ├─dto
    │  │          │  │  │  ├─request
    │  │          │  │  │  └─response
    │  │          │  │  ├─entity
    │  │          │  │  ├─repository
    │  │          │  │  └─service
    │  │          │  ├─example
    │  │          │  │  ├─controller
    │  │          │  │  └─model
    │  │          │  └─user
    │  │          │      ├─controller
    │  │          │      ├─dto
    │  │          │      │  ├─request
    │  │          │      │  └─response
    │  │          │      ├─entity
    │  │          │      ├─repository
    │  │          │      └─service
    │  │          ├─common
    │  │          ├─config
    │  │          └─exception
    │  │              └─customException
    │  └─resources
</details>
```





<details>
  <summary>
  프론트엔드 디렉토리 구조
  </summary>
 </details>





## Dataset

- AIHub 개방 데이터셋

![Architecture](./assets/dataset.png)

전체 이미지 개수 : 504,450 장 중 50,000장 사용(Train : 35,000장, Validation : 15,000장)

3 class : 스크래치(Scratch), 찌그러짐(Crushed), 파손(Breakage)

## Model Pipeline

## 주요기능 및 화면