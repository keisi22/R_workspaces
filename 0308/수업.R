library(dplyr) # 로드

emp =read.csv('emp.csv')

# group by + summarise
# group by(~로) 
# 특정 열(컬럼) 묶어 그룹화
group_job =emp%>% group_by(JOB)
print(group_job)

# R에 group by는 summarise, mutate, filter 등의 기능과 함께 사용
# 그룹별로 계산 진행

# 부서별 평균(mean) 급여 계산
# summarise : 요약하다
dept_avg_sal=emp %>% group_by(DEPTNO) %>% summarise(AVG_SAL=mean(SAL, na.rm=TRUE))
print(dept_avg_sal)

# 직업별 평균 계산
# 평균 급여 내림차순
job_avg_sal=emp%>% group_by(JOB) %>% summarise(AVG_SAL=mean(SAL)) %>% arrange(desc(AVG_SAL))
print(job_avg_sal)

# 직업별 직원 수 계산, 단 직원수 내림차순 정렬
job_count=emp%>% group_by(JOB) %>% summarise(EMP_COUNT= n()) %>% arrange(desc(EMP_COUNT))
# n(): 행 개수
print(job_count)


# csv 파일 2개 이용하기
emp =read.csv('emp.csv')
dept=read.csv('dept.csv')
# 두데이터 병합
# 교집합 컬럼을 이용한 데이터 병합(JOIN)
# inner join : 내부조인

emp_with_dept=emp %>% inner_join(dept, by ='DEPTNO')
#View(emp_with_dept)

# 40번 부서인 운영팀도 출력하기
# left_join : 왼쪽에 있는 데이터프레임 데이터를 모두 병합(중요!!!)
emp_with_dept=dept %>% left_join(emp, by='DEPTNO')
#View(emp_with_dept)

# full_join(합집합) : 모두 다 병합
emp_full_joined= full_join(emp, dept, by='DEPTNO')
#View(emp_full_joined)

# 근무지가 'DALLAS'인 직원들의 이름 출력
result1=emp %>% inner_join(dept, by ='DEPTNO')%>% filter(LOC=='DALLAS') %>% select(ENAME,LOC)
print(result1)

result2=dept %>% left_join(emp, by='DEPTNO') %>% filter(LOC=='DALLAS') %>% select(ENAME, LOC)
print(result2)


# slice: 특정 위치 조회
result=emp %>% slice(2,4) # 2행과 4행 출력
print(result)

result=emp %>% slice(1:5) # 1행~5행까지
print(result)

#부서별 최대연봉 사원 조회
# n:행, n=1 : 행 1개만
result= emp%>% group_by(DEPTNO) %>% slice_max(SAL, n=1)
print(result)

# 날짜/시간 데이터 처리
# as.Date : 문자열을 날짜형으로 변화
# difftime : 두 날짜 간의 차이 계산
# format (중요!!) : 특정 형식으로 변환

dates = c('2025-03-08', '2025-03-01', '2025-01-01')
# 컴퓨터는 위의 벡터를 문자로 인식
dates = as.Date(dates)
str(dates) #데이터 타입 확인

# 오늘 날짜 조회
today =Sys.Date() # Sys :시스템
print(today)

# 오늘 날짜와 각 날짜의 차이 계산
result= today - dates
print(result)

# 각 날짜에 일수 더하기
result =dates +7
print(result) # 각 날짜에 7일을 더한 결과

# 날짜 포맷 변경
formatted_dates= format(dates, '%Y년 %m월 %d일')
print(formatted_dates)

# 두날짜 간의 차이 계산
hire_date=as.Date('2025-01-02') #입사 날짜
current_date = as.Date('2025-02-13') #특정 날짜
# 근속일 계산
# units = 'mins' : 두 날짜 간의 분
# units = 'hours' : 두 날짜 간의 시간
# units = 'week' :  두 날짜 간의 주
days= difftime(current_date, hire_date, units='mins')
print(days)

# 특정 기간에 고용된 직원 조회
# 81년 01월 01일 ~ 81년 12월 31인 사이에 입사인 직원
result=emp%>% filter(HIREDATE >= as.Date('1981-01-01') & HIREDATE <= as.Date('1981-12-31'))
print(result)

# 월별 고용된 사원 수 집계
# 월 추출
emp$HIRE_MONTH = format(as.Date(emp$HIREDATE),'%Y-%m')
month_hire = emp %>% 
  group_by(HIRE_MONTH) %>%
  summarise(EMP_COUNT = n()) # n() : 행 수
print(month_hire)

# 문자열 데이터 처리
# substr() : 특정 위치의 문자열 조회
# strsplit() : 특정 구분자를 기준으로 나눔
# gsub() : 다른 문자로 대체

text = '안녕하세요, 곧 점심시간 입니다.'
result=substr(text, 1, 5) #text를 1번째부터 5번째까지만 추출
print(result)

text= '오늘 점심은 라볶이, 돈까스, 햄버거 입니다.'
# str(string, 문자) split(나누다)
result=strsplit(text, split=',')
print(result)

phone= '010-5555-3333' #문자에 기호 붙어있으면 분석하기
result=strsplit(phone, split='-')
print(result)

# 단어 대체
text= '고양이가 방에서 놀고 있어요.'
result= gsub('고양이', '강아지', text)
print(result)

# 실무예제
text= '사과 12312312'
# 숫자 제거
# [0-9]+ : 정규표현식
result= gsub('[0-9]+', '', text)
print(result)

# emp에서 사원이름 첫두글자만 추출
emp=emp %>% mutate(ENAME_SHORT=substr(ENAME, 1,2))
#View(emp)

# mutate 입사년도만 컬럼추가
emp=emp%>% mutate(HIREDATE_YEAR=substr(HIREDATE, 1,4))
#View(emp)

# 데이터 스케일링, 데이터 이상치 제거 <- 5회차 수업에~

# 커미션(COMM)이 결측치가 아닌 직원 중
# 부서별 평균 커미션과 최대 커미션 알아내기
# filter
# !is.na
# group_by
# summarise
# mean
# max
result= emp %>%
  filter(!is.na(COMM))%>% 
  group_by(DEPTNO)%>% 
  summarise(AVG_COMM=mean(COMM), MAX_COMM=max(COMM))
print(result)

# 직업(JOB)이 MANAGER인 사원 필터링 후,
# 부서번호 별 총급여 합계 조회
# filter
# group_by + summarise
# sum
result= emp%>% 
  filter(JOB=='MANAGER')%>%
  group_by(DEPTNO)%>%
  summarise(SUM_SAL=sum(SAL, na.rm=TRUE))
print(result)

