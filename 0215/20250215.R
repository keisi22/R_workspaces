# 주석
# 주석은 '메모' 목적

# 단일 라인 주석 <- '#'
print('안녕하세요. 데이터 분석 첫 수업입니다')


# 다중라인 주석 <-  '#' 여러번 사용
# '메모'  <-  작성자, 코드작성날짜, 수정이력, 코드목적등
# 다양한 정보 포함

# Author : 홍길동 <- 코드 작성자
# Date : 2025. 02. 15 <- 코드 작성날짜
# Comment : 코드 출력하기 <- 코드 목적

print('출력하기') #여기서도 할수 있음

# ctrl + shift + c : 다중 주석처리 가능

# 주석은 코드를 이해하는데 도움되지만
# 너무 많으면 오히려 '코드를 복잡'하게 만들 수 있음

### 자료형
# 우리가 사용하는 데이터는 문자, 숫자
print(35) # 숫자 출력
# 실행하기 ctrl + shift + s
print('홍길동') # 문자 출력, 따옴표 사용 필요

# 컴퓨터는 '논리형' 자료형도 필요
# 논리형은 true, false만 나타냄
print(TRUE) # 논리형 true 출력
print(FALSE) # 논리형 false 출력


# R은 특수한 형태값 존재
# '팩터(factor)' 범주형 데이터
# 범주형 데이터는 수치로 측정 불가(계산적 의미 없음)
# 예) 성별(남/여), 혈액형(A/B/O/AB), 고객만족도..
# 막대그래프, 도수분포표 같은 시각화에 사용

# 혈액형 데이터로 팩터 생성
blood =factor(c('A', 'B', 'O','AB'))
print(blood) #팩터 출력

# 특수 데이터형
# 1. NULL : 데이터가 없다
# 2. NaN : 수학적으로 정의가 불가능
# 3. InF : 무한값
# 4. *****NA: 결측값 : 과측/ 측정에 실패한 값

### 빅데이터 분석기 <- 시험
#### R에서 자료형 확인하는 방법
# 'typeof'를 이용해 자료형 확인
a=3
print(typeof(a)) # 'a' 대입된 자료형 검색하라는 뜻
# 'double'은 실수

a=3L
print(typeof(a)) # integer는 정수형

a=TRUE
print(typeof(a)) # logical 논리형

a=NULL
print(typeof(a)) # NULL '값없음'

a='apple'
print(typeof(a)) # 'character 문자형

#### 변수****
# 변수는 프로그래밍에서 중요한 개념
# 변수는 ' 값에 이름을 붙여 이름만 가지고 값에 접근'

print(100)

num = 100
print(num)
num=num+1
print(num)

# 변수 이름의 규칙
# 1. 언더바, 숫자, 점 사용가능
# 2. 점으로 시작하면 뒤에 숫자 올 수 없음
# 규칙에 맞게 변수 이름 생성
A1 = 100
A_ = 200
.B = 300
# 동일한이름을 사용하면 맨 마지막에 작성한 값이 나옴
a='apple'
a='banana'
print(a) #banana 출력

a='apple'
b='banana'
print(a)
print(b)

# R에서 출력하는 방법
print('기본 출력 방법')
x=100;
print('x의 값은 :')
print(x)

# cat을 이용해서 변수와 텍스트 결합
cat('x의 값은 :', x, '\n') #cat 자주 사용!!!

### 연산자
# 연산은 둘 이상의 대상을 조작하여 새로운 값 생성
# +, -, *, /, %%
print('사칙연산')
print(1+2) # 더하기
print(1-2)
print(1*2)
print(1/2)
print(2**3) # 2의 3제곱

print('비교연산') # 비교연산 결과는 '논리형'
print(2==3)
print(2<=3)
print(2!=3)

print('논리 연산자')
print(TRUE & TRUE) #피연산자가 둘다 true면 true
print(TRUE | FALSE) #피연산자가 하나만 true여도 true
print(!TRUE) # 피연산자가 TRUE면 false 출력
print(!FALSE) # 피연산자가 false면 true 출력

# 연산자 기본문제
a=20
b=5

#곱셈
mul =a*b
cat('곱셈 결과 : ', mul, '\n')

# 나누기
div=a/b
cat('나누기 결과 : ', div, '\n')

# (50+30)÷(10−2)×3 R 코드로 구현
a=50
b=30
c=10
d=2
e=3
plus=a+b
min=c-d
result=plus/min*e
print(result)

# 수식 계산
result = (50 + 30) / (10 - 2) * 3
# 결과 출력
print(paste("수식의 결과는:", result))

a=3
c=5
b_square=(c**2)-(a**2);
print(b_square)

b_square=(c*c)-(a*a);
print(b_square)


#### 벡터(**)!!!!!
# 동일한 '데이터 타입'을 저장하는 1차원 배열
# 벡터의 문법은 'C()' combind의 약자

# 벡터의 특징
# 1. 항상 '동일한 데이터' 타입을 가져야 한다
# 2. 만약, 서로 다른 타입의 데이터를 포함하면 자동으로
# 타입이 변환됨

# 벡터 생성
vc = c(1,2,3,4) #숫자형 데이터 벡터 생성
print(vc)

vc =c(1,2,3,'4') # 마지막 숫자'4'를 문자로 표기
print(vc) #전체 값이 문자 형태로 자동변경
# 숫자형(하위) < 문자형(상위) : 자동으로 상위 타입으로 변환

# 벡터의 결과는 세로로 저장
# c()는 들어오는 값들을 묶어 하나의 벡터로 만드는 기능
age =c(29,30,31,33)
print(age)
name=c('홍길동', '김길동', '박길동', '현길동')
print(name)

vec1=c(10,20,30,40,50)
print(vec1) #벡터 전체 출력
print(vec1[1]) # 첫번째 값만 조회
# 50을 출력하세요
print(vec1[5])

# 규칙적인 벡터 생성
# 1~5 연속된 숫자 벡터로 표현
vec2=1:5 #1~5를 의미
cat('규칙적인 벡터: ', vec2,'\n')

# 1~10 연속된 숫자중 2씩 간격으로 벡터 생성
vec3=seq(1,10, by=2) # 시작값 : 1, 끝:10, 간격:2
print(vec3)

# 벡터 연산
x=c(1,2,3)
y=c(2,4,6)

# 벡터 덧셈
z=x+y
print(z)

# *****벡터 필터링!!!!
# 벡터에서 20보다 큰 숫자만 출력
num=c(10,15,20,25,6,9)
than_20=num[num >= 20]
print(than_20)

# 10보다 큰 숫자만 나오게 출력
than_10=num[num>=10]
print(than_10)

# [], () 조심!
# [] : 특정 값 조회 , 필터링 할 수 있음

## 조건문, 반복문 : 문법만 알면 가능
# R로는 깊게 코딩 하지 않음

# 조건문 : 조건이 들어간 문장
# 반복문 : 반복이 들어간 문장

if(5<0){ #만약에 5가 0보다 크다면?
  print('맞습니다.')
}else{
  print('틀렸습니다')
}

# ifelse
x=c(1,-2,3,-5,7) # 벡터 생성
# 조건문을 이용해서 벡터안에 있는 숫자가 
# 양수인지 음수인지 판단

result =ifelse(x>0, '양수', '음수')
# 조건, 참값, 거짓값
print(result)

score=c(10,90,100,40,60)
# 80점 이상은 'A', 80미만 'B'
result2=ifelse(score >=80, 'A', 'B')
print(result2)
# 벡터안에 있는 값(요소)을 전부 if/else로 필터링

### 반복문
# 특정 작업을 반복적으로 수행할 때 사용
for(i in 1:10){  # 1부터 10까지 총 10회 반복
  print(i)
}

# 벡터랑 for문 사용방법
numbers =c(3,8,12,5,7,10,15)
even_numbers=c() #빈 벡터 생성
for(i in numbers){ # numbers에 있는 수만큼 반복
  if(i%%2 ==0){
    even_numbers=c(even_numbers, i)
  }}
print(even_numbers)





