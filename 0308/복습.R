setwd('D:/r-data') # 작업 시작할 때 디렉토리 변경
print(list.files()) # r 경로확인

# 데이터프레임 (행과 열(벡터))

df=data.frame(
  ID= c(1,2,3),
  Name=c('Brian', 'Bob', 'Jose')
)
#View(df)
print(df$Name) # 특정 열 출력

df$ID2=df$ID + 1 # 특정 열을 가져와서 값을 더한 후 새로운 열에 추가
print(df$ID2)

# 결측치(Missing Value) 'NA'로 표기
# 예제 데이터 생성
data=c(1,2,NA, 4, NA, 6)

# 결측치 확인
print(is.na(data)) # is ->?, is.na=>na가 있니?
# na가 있으면 true, 없으면 false

print(!is.na(data)) # !(부정) 반대

# csv(콤마로 구성된 파일)파일 가져오기
emp=read.csv('emp.csv')
#View(emp)
emp_clean=na.omit(emp) # omit :na가 있는 행을 제거
#View(emp_clean)

emp_comm=sum(emp$COMM, na.rm=TRUE) # rm :제거하다(통계값을 구할 때 주로 사용)
print(emp_comm)


# 데이터 전처리->80~90%
# dplyr :데이터 프레임을 다루는 공구
library(dplyr) # 로드

#문제1. 직원 이름(ENAME), 직업(JOB), 그리고 부서 번호(DEPTNO) 열만 선택하세요.
# select(선택하다) 사용
emp1=emp %>% select(ENAME, JOB, DEPTNO)
print(emp1)

#문제2. 급여(SAL)가 2000 이상인 직원만 필터링하세요.
# filter 사용 : where(sql 조건)
sal_2000= emp%>% filter(SAL>=2000)
print(sal_2000)

#문제3. 급여(SAL)를 기준으로 내림차순으로 정렬하세요.
# arrange : 정렬
# desc :내림차순
arr_sal=emp%>% arrange(desc(SAL))
print(arr_sal)

#문제4. 부서 번호(DEPTNO)가 30인 직원 중 => filter
#이름(ENAME)과 급여(SAL)만 선택하고 => select
#급여 순으로 내림차순 정렬하세요. => arrange
deptno_30=emp%>% filter(DEPTNO==30)%>% select(ENAME, SAL) %>% arrange(desc(SAL))
print(deptno_30)

#문제5. 직업(JOB)이 "MANAGER"인 직원 중, 
#부서 번호(DEPTNO)와 급여(SAL)를 선택하고
#급여 순으로 오름차순 정렬하세요. asc : 오름차순
emp_job=emp%>% filter(JOB=='MANAGER') %>% select(DEPTNO, SAL) %>% arrange(SAL)
print(emp_job)

#문제6. 급여(SAL)가 1500 이상이고 부서 번호(DEPTNO)가 20인 직원의 이름(ENAME), 직업(JOB), 그리고 급여(SAL)를
#선택한 뒤 이름 순으로 정렬(오름차순)하세요.
result=emp%>% filter(SAL>=1500 & DEPTNO==20)%>%select(ENAME, JOB, SAL) %>% arrange(ENAME)
print(result)

#문제7.  직업(JOB)이 "SALESMAN"인 직원 중, 급여(SAL)가 1500 이상인 직원의 이름(ENAME), 급여(SAL), 부서 번호(DEPTNO)를
#선택하고 급여 순으로 내림차순 정렬하세요.
job_sales=emp%>% filter(JOB=='SALESMAN' & SAL>=1500) %>%select(ENAME, SAL, DEPTNO)%>% arrange(desc(SAL))
print(job_sales)

#문제 8. 부서 번호(DEPTNO)가 10 또는 30인 직원 중, 이름(ENAME), 직업(JOB), 급여(SAL)을 선택하고 이름 순으로 정렬하세요.
result= emp%>% filter(DEPTNO==10 | DEPTNO==30)%>% select(ENAME, JOB, SAL) %>% arrange(ENAME)
result= emp%>% filter(DEPTNO %in% c(10,30))%>% select(ENAME, JOB, SAL) %>% arrange(ENAME)
# %in% (or)

#문제 9. mutate()를 사용하여 급여(SAL)에 보너스(COMM, NA는 0으로 간주)를 더한 총 급여(Total_Salary) 열을 추가하세요.
# mutate : 컬럼(열) 추가
result = emp %>% 
  mutate(COMM = ifelse(is.na(COMM), 0 , COMM),
         Total_Salary = SAL + COMM)
print(result)

result1=emp%>% mutate(Total_Salray1=SAL+ifelse(is.na(COMM), 0, COMM))
print(result1)


num= c(10,10,NA, 5, NA)
result=ifelse(is.na(num), 1, num) # 결측값이 있으면(true) 1로 대체 
print(result) # 10 10 1 5 1





