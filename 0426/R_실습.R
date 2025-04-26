print("ADsP") #ctrl+enter 코드실행

# 데이터 타입
class('ADsP') # 문자형 타입
class(1) # 숫자형 타입
class(Inf) # 무한
class(NaN) # Not A Number
class(TRUE) # 논리형 타입
class(FALSE) 
class(NA) # 공간을 차지하는 결측값
class(NULL) # 공간을 차지하지 않는 결측값
# ctrl+ shift : 내가 사용하고 싶은 언어 추천

# 연산자
a='ADsP' # 대입 연산자
print(a)
b=1
c=2
d=TRUE
e=NA
f=NULL
a=='ADsP' #비교 연산자
is.na(e)
is.character(a)
is.logical(d)
is.null(f)
b+c # 산술 연산자
b/c # 몫
7/3
b%%c # 나머지
2^2 # 제곱
2**2 

TRUE&TRUE
TRUE&FALSE
FALSE&FALSE
TRUE|TRUE
TRUE|FALSE
FALSE|FALSE


# 벡터
v1=c(1,2,3,4)
print(v1[2]) # 인덱스 조회
v2=c(1, 'ADsP', TRUE)
print(v2)
print(class(v2[1]))
v3=c(1:6)
print(v3)

# 행렬
m1=matrix(v3, nrow=2, ncol=3) # nrow=행의 수, ncol=열의 수
print(m1)
m2=matrix(v3, nrow=2, ncol=3, byrow=TRUE) # byrow : 행을 기준으로 작성
print(m2)

# 배열 : 3차원 이상의 데이터 구분
a1=c(1:12)
print(a1)

a2=array(a1, dim=c(2,2,3))
a2

# 데이터프레임
d1=c(1,2,3,4,5)
d2=c('짱구', '철수', '유리', '맹구', '훈이')
d3=c('흰둥이', '학원', '토끼', '돌맹이', '주먹밥')
df1=data.frame(d1,d2,d3)
print(df1)

df1[1,] # 데이터 추출[행,열]
df1[1,2]
df1[,2]
df1[4,3]

v1=c(1,2,3)
v2=c(4,5,6)
v3=c(7,8,9,10)
rbind(v1, v2) # 데이터 결합 : 행을 기준으로 결합
cbind(v1, v2) # 열 기준으로 결합
cbind(v1, v3) # 재사용 규칙
rbind(v1, v3)


# 내장함수
help("data.frame")
history() # 내가 잡업한 내역 확인
paste('Pen Pineapple', 'Apple Pen', sep=' ')
paste('Pen Pineapple', 'Apple Pen')
seq(1,10, by=2) #1~10까지 2깐씩 뛰어서
rep(1,5) # 1만 5번

a=1
a
rm(a) # 변수 지우기, remove
a

ls() # 지금까지 만들어진 변수 출력, list

# 통계함수
v1=1:10
v1

sum(v1) # 합계 
var(v1) # 분산 variance
sd(v1)  # 표준편차
range(v1) # 가장 작은 값 & 가장 큰 값

install.packages('fBasics')
library(fBasics)
skewness(v1) # 왜도
kurtosis(v1) # 첨도
summary(v1)  # min, 1사분위수, 중앙값, 평균, 3사분위수, max

# 반복문
for(i in 1:3){
  print('oh')
}

cnt=0
while(cnt<4){
  print('oh')
  cnt=cnt+1
}

# 조건문
# if
# if / else
# if /else if / else

a=1
b=2

a<b

if(a>b){
  print('a가 b보다 크다')
}else if(a<b){
  print('a가 b보다 작다')
}else{
  print('a와 b가 같다')
}


# 함수
comp=function(a,b){ # a,b : 환경변수(parameter)
  if(a>b){
    print('a가 b보다 크다')
  }else if(a<b){
    print('a가 b보다 작다')
  }else{
    print('a와 b가 같다')
  }
}
comp(a,b)
comp(5,2)
comp(2,2)

# 숫자연산
sqrt(4) # 제곱근 square root
abs(-2) # 절대값 absolete value
exp(1) # e^1 : 자연상수 거듭제곱
log(exp(1)) # 자연상수 로그
log10(100) # 10 로그값
pi # 파이값(원주율)

iris # 기본적으로 내장된 데이터
summary(iris)

round(3.5) # 반올림
ceiling(3.2) # 올림
floor(3.7) # 내림

# 문자 연산
str='ADsP'
tolower(str) # 소문자로
toupper(str) # 대문자로
nchar(str) # 문자개수
substr(str, 2, 3) # 일부 추출
strsplit(str, 's') # 특정 문자로 구분
grepl('A', str) # 특정 문자 포함 여부
grepl('a', str)
gsub('s', '',str) # 특정 문자 바꾸기


# 벡터 연산
v1=c(1:10)
v2=c(11:20)
v1
v2

length(v1)
paste(v1,'번') # 문자로 변환시킴
cov(v1,v2) # 공분산
cor(v1,v2) # 상관계수 : -1 ~ 1(양의 상관관계 : 데이터 간의 비교를 통해 비례관계가 있음을 나타냄)
table(v1) # 각 데이터 별 갯수(그룹화하는 개념)
order(v1) # 순서(index 개념) : 그 데이터가 순서대로 나열했을 때 몇번째에 위치하는지
v3=c(1,3,2,4,6,7,9,10,8)
v3
order(v3)

rev(v1) # 거꾸로 : 데이터 자체의 순서를 뒤집은 나열
rev(v3)


# 핼렬 연산
v1=matrix(c(1:12), nrow=3, ncol=4, byrow=TRUE)
v1

t(v1) # 행->열, 열->행 서로 바꿈 Transposed Matrix
diag(v1) # [1,1][2,2][3,3]... 값 

v2=matrix(c(1:4), nrow=2, ncol=2, byrow=TRUE)
v3=matrix(c(1:4), nrow=2, ncol=2, byrow=TRUE)
v2
v3
v2%*%v3 # 행열의 곱 : 1행*1열, 1행*2열, 2행*2열, 2행*2열...


# 데이터 탐색
x=c(1:12)
x
head(x,3)
tail(x,3)
quantile(x) # 4분위 수 출력(summary에도 나옴)
summary(x)


# 데이터 전처리
df1
d4=rep('해바라기반')
df2=data.frame(d1, d4)
df2
merge(df1, df2) # 데이터프레임 병합 
apply(df2, 2, print) # 1:행, 2:열 별로 주어진 함수 수행
apply(df2, 1, print)
subset(df1, d2=='맹구') # 특정 데이터 포함 추출
subset(df1, d2!='맹구') # subset(데이터, 조건)


# 정규분포 : 개념정리(rnorm, dnorm, pnorm, qnorm)
x=rnorm(100,0,1) # 랜덤 100개 정규분포 생성 rnorm(개수, 평균, 분산)
x
hist(x) # histogram  막대그래프 생성

y=dnorm(x,0,1) # 확률밀도 함수(누적 정규분포 곡선을 따른다)
hist(y)

pnorm(-2,0,1) # 정규분포에서 -2보다 작을 확률
pnorm(1.96,0,1)
qnorm(0.975,0,1) # 정규분포에서 더 작은 분포의 넓이가 0.975인 값


# 표본추출
runif(10) # 0~1 사이의 랜덤 난수 10개 생성, 범위 지정 가능
runif(10,1,10) # runif( 개수, 처음수, 끝수) 범위 지정 가능
sample(x, 10) # 데이터에서 10개 추출


# 날짜
Sys.Date() # 현재 날짜
Sys.time() # 현재 시간(KST : Korea Standard Time)
date='2025-04-26'
class(date)
date=as.Date(date) # 날짜 형식으로 변환
class(date)
format(Sys.Date(), '%y, %m, %d')
# Y:4자리 년도, y:2자리 년도, m:월, d:일, b:축약월, B:전체월 문자형
format(Sys.Date(), '%Y년 %m월 %d일')

as.POSIXct(0) # 1970-01-01 9시
as.POSIXct(94608000) # 1970.01.01 기준으로 해당 초(sec)가 지난 시점(시점 설정 가능)
