# ***가장 중요한 부분!!!***
# 데이터 분석 80~90%가 필터링(전처리)
# 필터링-> 쓸모없는 데이터 거르기
# 1. subset
# 2. dplyr(디플라이어) -> 완전 중요!!!
# 디플라이어 장점
# 문제를 더빨리 풀 수 있고
# 실무에서 많이 사용함

# subset(부분집합)
# 특정 조건에 맞는 데이터를 추출하여
# 새로운 부분집합을 만드는 기능
# subset 설치할 필요없음. R에서 기본으로 제공해줌
# 디플라이어는 설치해야함

emp=read.csv('emp.csv')
print(emp)

# 급여가 3000 이상 받는 사원만 조회
high_sal =subset(emp,SAL>=3000)
print(high_sal) # SCOTT, KING

# AND 연산자, OR 연산자를 이용해서 여러조건을 결합
# 급여 3000이상, 부서번호 20번인 직원만
emp_deptno20=subset(emp, SAL>=3000 & DEPTNO==20)
print(emp_deptno20)

# 급여가 2000 이상인 직원의 이름, 입사날짜, 직책 조회
emp_sal2000=subset(emp, SAL>=2000, select=c(ENAME, JOB, SAL))
print(emp_sal2000)

# 설치, 설치 후 주석처리!
# install.packages('dplyr') ctrl+엔터

# 설치한 디플라이어를 스크립트창에 가져와야 함
# 로드(임포트)
library(dplyr) # 디플라이어 로드
# ****디플라이어 핵심문법
# 1. filter : 조건에 맞는 행 조회
# 2. select : 특정 컬럼(열) 선택
# 3. mutate : 새로운 컬럼 추가
# 4. arrange : 행 정렬
# 5. group by : 데이터 그룹화
# 6. summarise : 통계 계산
# 7. join : 여러 데이터프레임 병합
# 8. slice : 특정 행 선택

# 디플라이어(dplyr) : data frame plier(공구)
# 데이터프레임을 다루는 '공구'
# 대규모 데이터 처리할 때 배우 빠른 속도제공
# 실무에서 전처리 작업 시 자주 사용

# filter
# 행을 조건에 따라 필터링
# 급여가 3000 이상인 직원조회
high_salary = emp %>% filter(SAL >=3000)
print(high_salary)

# 급여가 3000이상 부서번호가 20번인 사원 조회
sal_dept20= emp %>% filter(SAL >=3000 & DEPTNO==20)
print(sal_dept20)

# 부서번호 20, 직책(JOB) 'MANAGER'인 사원
dept20_job=emp %>% filter(DEPTNO==20 & JOB=='MANAGER')
print(dept20_job)

# 급여가 2000미만, 부서번호가 20번인 사원 조회
low_sal=emp %>% filter(SAL<2000 & DEPTNO==20)
print(low_sal)

# 위 문제에서 사원이름 , 부서번호만 조회
low_sal=emp %>% filter(SAL<2000 & DEPTNO==20) %>% select(ENAME, DEPTNO)
print(low_sal)

# 직책이 SALESMAN인 사원의 이름, 직책, 입사날짜 조회
salesman=emp %>% filter(JOB=='SALESMAN') %>% select(ENAME, JOB,HIREDATE)
print(salesman)

# mutate()
# 새로운 컬럼(열) 추가
# 급여, COMM 의 합계를 새로운 열을 만들어 추가
# TOTAL_COMM : 새로운 열 이름
# is.na : is(?), na값이야?
emp_comm=emp %>% mutate(TOTAL_COMM = SAL + ifelse(is.na(COMM),0,COMM))
# ifelse(is.na(COMM),0,COMM)) :
# comm이 na면 0을 아니라면 comm을
# View(emp_comm)

# arrange()
# 정렬
# 급여기준으로 오름차순
sorted_by_sal=emp%>% arrange(SAL)
print(sorted_by_sal)

# 급여기준으로 내림차순
# desc(Descending): 내림차순
sorted_by_sal=emp%>% arrange(desc(SAL))
print(sorted_by_sal)

#문제1. 직원 이름(ENAME), 직업(JOB), 그리고 부서 번호(DEPTNO) 열만 선택하세요.
emp1= emp %>% select(ENAME, JOB, DEPTNO)
print(emp1)

#문제2. 급여(SAL)가 2000 이상인 직원만 필터링하세요.
sal2000= emp %>% filter(SAL>=2000)
print(sal2000)

#문제3. 급여(SAL)를 기준으로 내림차순으로 정렬하세요.
arr_sal=emp %>% arrange(desc(SAL))
print(arr_sal)

#문제4. 부서 번호(DEPTNO)가 30인 직원 중, 이름(ENAME)과 급여(SAL)만 선택하고 급여 순으로 내림차순 정렬하세요.
deptno30= emp %>% filter(DEPTNO==30) %>% select(ENAME, SAL) %>% arrange(desc(SAL))
print(deptno30)

#문제5. 직업(JOB)이 "MANAGER"인 직원 중, 부서 번호(DEPTNO)와 급여(SAL)를 선택하고 급여 순으로 오름차순 정렬하세요.
job_manager=emp %>% filter(JOB=='MANAGER') %>% select(DEPTNO, SAL) %>% arrange(SAL)
print(job_manager)

#문제6. 급여(SAL)가 1500 이상이고 부서 번호(DEPTNO)가 20인 직원의 이름(ENAME), 직업(JOB), 그리고 급여(SAL)를 선택한 뒤 
#이름 순으로 정렬(오름차순)하세요.
sal1500=emp %>% filter(sal>=1500 & DEPTNO==20) %>% select(ENAME, JOB, SAL) %>% arrange(ENAME)
print(sal1500)

#문제7.직업(JOB)이 "SALESMAN"인 직원 중, 급여(SAL)가 1500 이상인 직원의 이름(ENAME), 급여(SAL), 부서 번호(DEPTNO)를 선택하고
#급여 순으로 내림차순 정렬하세요.
job_sales=emp %>% filter(JOB=='SALESMAN' & SAL>=1500) %>% select(ENAME, SAL, DEPTNO) %>% arrange(desc(SAL))
print(job_sales)

#문제 8. 부서 번호(DEPTNO)가 10 또는 30인 직원 중, 이름(ENAME), 직업(JOB), 급여(SAL)을 선택하고 이름 순으로 정렬하세요.
deptno10_30=emp %>% filter(DEPTNO==10 | DEPTNO==30) %>% select(ENAME, JOB, SAL) %>% arrange(ENAME)
print(deptno10_30)

#문제 9. mutate()를 사용하여 급여(SAL)에 보너스(COMM, NA는 0으로 간주)를 더한 총 급여(Total_Salary) 열을 추가하세요.
emp_sal=emp %>% mutate(Total_Salary= SAL + ifelse(is.na(COMM), 0, (COMM)))
print(emp_sal)
#View(emp_sal)



