# 대문자 소문자 구별!!

## CSV(Comma-Separated Values)
## CSV(데이터분석 데이터) -> 콤마로 구성된 데이터
## CSV파일은 데이터분석에서 매우 많이 사용됩니다.

# CSV파일 장점 : '광범위한 호환성(R, Python, C, C++)'
# CSV <-- 데이터프레임 < -- 분석하고 시각화

## R 저장,불러오는 파일 경로 수정하기
setwd('D:/r-data'); # D 드라이브에 r-data 폴더로 경로 수정
print(list.files()) #현재 경로에 있는 파일목록 출력

# 엑셀(csv)파일 불러오기
emp = read.csv('emp.csv') #엑셀 불러오기
# View(emp) 
# 퀴즈 -> 1~5행까지 출력, 아래 3행만 출력, 행/열 수 확인
print(head(emp,5))
print(tail(emp,3))
print(dim(emp))
print(str(emp)) #데이터프레임 열 데이터 타입 확인

# 데이터 형 변환

# 예제 문자 -> 숫자로 변환
num = c('100','200','300')
num = as.numeric(num) # 문자 -> 숫자
num = num * 2
print(num)

num2 = c(100,200,300)
# 숫자 -> 문자
num2 = as.character(num2)
print(num2)

# 날짜형으로 변환(why? 날짜관련 계산하기 위해서)
str(emp)
# 문자형 -> 날짜형
emp$HIREDATE = as.Date(emp$HIREDATE)
str(emp)

# 형변환 연습
data = data.frame(
  product_number = c('A001','A002','A003'), #제품 번호
  product_name = c('Skin', 'Suncreen', 'Lipstick'), # 제품
  price = c('15000$','22000$','18000$')
)
# 데이터프레임 엑셀로 저장
write.csv(data,file="화장품.csv",row.names = FALSE)

str(data)
# 1. '$' 기호 없애기
# gsub : 특정 문자 제거
data$price = gsub('\\$',"",data$price) # $ -> "" 변경
print(data)
# 2. 문자 -> 숫자로 변환
# price를 문자에서 숫자로 변환해서 str로 최종 확인
data$price = as.numeric(data$price)
str(data)
# 3. 계산(총합)
print('제품 총합 : ')
print(sum(data$price)) # sum : 총합구하기(엑셀 함수랑 같음)


# 총합, 평균, 최솟/최댓 값알아내기

# 사원 총 급여
result = sum(emp$SAL)
print(result)
# 사원 급여 평균
result = mean(emp$SAL)
print(result)
# 사원 중 가장 많은 급여 조회(최댓값)
result = max(emp$SAL)
cat("최댓값 : ",result,"\n")
# 사원 중 가장 적은 급여 조회(최솟값)
result = min(emp$SAL)
cat("최솟값 : ",result,"\n")
# 다중 컬럼의 합, 평균 구하기
# 급여(SAL)와 커미션(COMM) 합, 평균 구하기

# col(컬럼)Sums(여러 컬럼 더하기)
# na.rm(remove) =TRUE : 결측값을 제거하겠다.
total_sum = colSums(emp[,c("SAL","COMM")],na.rm =TRUE) 
print(total_sum)
# *****결측값 : 관측/측정에 실패한 값
# 즉, NA를 제거 후 총합을 구해야 함.
# 퀴즈. 사원의 급여, 커미션 평균 계산, 단 NA는 제외
total_mean = colMeans(emp[,c("SAL","COMM")],na.rm =TRUE)
print(total_mean)

# 단일 컬럼 COMM, 총합구하기 단, 결측값 제거
# *****na.omit() : 결측값 제거
comm = sum(na.omit(emp$COMM))
cat("COMM 총합 : ",comm,"\n")

# 중앙값 ,표준편차
# 표준편차 : 데이터가 평균으로부터 얼마나 퍼져 있는지를 
# 나타내는 통계적 지표.(흩허진 정도)
# 예) 한반 수학점수 평균이 78~82가 나왔어요.
# 평균점수가 80이라고 가정할 때 표준편차는 작습니다.
# 만약에 점수가 60~100까지 다양하다면 표준편차는 큽니다.

# 급여 ***표준편차 구하기
# R은 sd() => Standard Deviation
sal_sd = sd(emp$SAL) #급여 표준편차
cat('급여 표준편차 : ', sal_sd, '\n')
# 이는 급여 값들이 '평균'으로부터 약 +- 1267.568만큼 퍼져
# 있다는 것을 의미

# 중앙값
sal_median = median(emp$SAL)
cat('급여 중앙값 : ', sal_median, '\n')

# *****최빈값, 분위수
# 최빈값 : 데이터가 가장 많이 몰려있는 위치 값
# 분위수 : 데이터를 크기 순으로 정렬 후 특정 비율에 
# 해당하는 값을 보여줍니다.

# JOB 최빈값 구하기
# 1. table 
print(table(emp$JOB)) #JOB별 몇명인지
# 2. which.max
x = c(10,23,100,1,5) # 숫자형 벡터 생성
print(which.max(x)) #벡터에서 최댓값의 위치를 알려준다.
# 3. 최빈값 구하기
job = names(which.max(table(emp$JOB)))
# names : 열이름 출력
cat('job 최빈값은 :', job,'\n')

# 퀴즈) 부서번호의 최빈값 구하기
print(table(emp$DEPTNO))
deptno = names(which.max(table(emp$DEPTNO)))
cat('deptno 최빈값은 :', deptno,'\n')
# 값이 동일하면 which.max 때문에 30은 조회 불가능

# 분위수
# 급여 분위수 알아내기
sal = quantile(emp$SAL) #사분위수 : 데이터를 4등분해서 나온 기준 값
print(sal)
# 0% 최솟값
# 50% 중앙값 
# 100% 최댓값

# 특정 분위수 구하기 (하위10%, 상위 90%)
sal = quantile(emp$SAL, probs = c(0.1, 0.9))
print(sal)

# 결측치를 제거한 SAL(급여) 평균 구하기
sal = mean(na.omit(emp$SAL))
cat('결측치를 제거한 급여 평균 : ',sal,'\n')
# 결측치를 제거한 SAL(급여) 총합 구하기
sal = sum(na.omit(emp$SAL))
cat('결측치를 제거한 SAL(급여) 총합 : ',sal,'\n')
# 결측치를 제거한 COMM 표준편차 구하기
# comm은 결측치가 많은 컬럼이므로 na.rm =TRUE
comm = sd(emp$SAL, na.rm =TRUE)
cat('결측치를 제거한 COMM 표준편차 : ',comm,'\n')



