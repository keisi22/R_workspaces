# emp 데이터프레임 생성
# empNO : 사원번호
# ENAME : 사원이름
# JOB : 직책
# MGR : 사수번호
# HIREDATE : 입사날짜
# SAL : 급여
# COMM : 보너스
# DEPTNO : 부서번호
emp = data.frame(
  empNO = c(7369, 7499, 7521, 7566, 7698, 7782, 7788, 7839, 7844, 7900),
  ENAME = c("SMITH", "ALLEN", "WARD", "JONES", "BLAKE", "CLARK", "SCOTT", "KING", "TURNER", "ADAMS"),
  JOB = c("CLERK", "SALESMAN", "SALESMAN", "MANAGER", "MANAGER", "MANAGER", "ANALYST", "PRESIDENT", "SALESMAN", "CLERK"),
  MGR = c(7902, 7698, 7698, 7839, 7839, 7839, 7566, NA, 7698, 7788),
  HIREDATE = as.Date(c("1980-12-17", "1981-02-20", "1981-02-22", 
                       "1981-04-02", "1981-05-01", "1981-06-09",
                       "1982-12-09", "1981-11-17", "1981-09-08",
                       "1983-01-12")),
  SAL = c(800, 1600, 1250, 2975, 2850, 2450, 3000, 5000, 1500, 1100),
  COMM = c(NA, 300, 500, NA, NA, NA, NA, NA, NA, NA),
  DEPTNO = c(20, 30, 30, 20, 30, 10, 20, 10, 30, 20)
)
# 데이터 확인
print(emp)

# 특정 열 출력 '사원이름'만 출력
names = emp$ENAME
print(names)

# 1행~6행까지 출력
print(head(emp))

# 행하고 열 개수 출력하기
print(dim(emp))

# sal급여 2000이상 받는 사원 조회
high_salary=emp[emp$SAL >=2000,]
print(high_salary)


# sal급여 2000이상 받는 사원이름, 직책
# , 왼 행 필터링
# , 오른 열 필터링
high_salary=emp[emp$SAL>=2000, c('ENAME', 'JOB')]
# View(high_salary)

# 부서번호가 20번인 사원이름, 입사날짜, 직책조회
deptno_20=emp[emp$DEPTNO==20, c('ENAME', 'HIREDATE', 'JOB')]
print(deptno_20)
# View(deptno_20)

# '&'연산자 활용한 데이터프레임 필터링
# 직업이 salesman, 급여 1500 이상 사원이름, 월급
result=emp[emp$JOB=="SALESMAN" & emp$SAL >=1500, c('ENAME', 'SAL')]
# View(result)

### 결측값 필터링하기(*****)
# is.na :결측값이 존재하는지 판단
# COMM 열에 NA가 있으면 0으로 대체

#emp$COMM[is.na(emp$COMM)]=0
# COMM에 NA가 있으면 0으로 대입
#result=emp$COMM
#print(result)


# 부서번호가 20번, 커미션이 NA 가 아닌 사원
# 이름, 커미션, 입사날짜
deptno_20=emp[emp$DEPTNO==20 & !is.na(emp$COMM), c('ENAME', 'COMM','HIREDATE')]
print(deptno_20)


