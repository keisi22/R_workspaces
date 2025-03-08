# install.packages('dplyr') 설치 필요
library(dplyr) # 로드
emp=read.csv('emp.csv')
dept=read.csv('dept.csv')
print(emp)
print(dept)

#문제 1: 급여(SAL)가 3000 이상인 직원들의 
# 이름(ENAME)과 직업(JOB)을 출력하세요.
# 힌트 : filter(), select()
result=emp%>% filter(SAL>=3000)%>% select(ENAME, JOB)
print(result)

#문제 2: "RESEARCH" 부서에 근무하는 직원들의 
# 이름(ENAME)과 급여(SAL)를 출력하세요.
# 힌트 :  inner_join(), filter(), select()
result=emp%>% inner_join(dept, by='DEPTNO')%>%
  filter(DNAME=='RESEARCH')%>%
  select(ENAME, SAL)
print(result)

#문제 3: 직업(JOB)별 평균 급여(SAL)를 계산하고 출력하세요.
# 힌트 : group_by(), summarize()
result=emp%>% group_by(JOB)%>%
  summarise(AVG_SAL=mean(SAL, na.rm=TRUE))
print(result)

#문제 4: 각 부서(DNAME)별 직원 수를 계산하고 출력하세요.
# 힌트 : group_by(), summarize(), n()
result=emp%>% inner_join(dept, by='DEPTNO')%>%
  group_by(DNAME)%>%
  summarise(emp_COUNT=n())
print(result)

#문제 5: 고용일(HIREDATE)이 "1981-01-01" 이후인 직원들의
#이름(ENAME), 직업(JOB), 고용일(HIREDATE)을 출력하세요.
# 힌트 : filter(), select()
result=emp%>% filter(HIREDATE> as.Date('1981-01-01'))%>% 
  select(ENAME, JOB, HIREDATE)
print(result)

#문제 6: 부서별(DEPTNO)로 그룹화하여 
#총 급여(SAL)의 합계를 계산하고 출력하세요.
# 힌트 : group_by(), summarize()
result=emp%>% group_by(DEPTNO)%>%
  summarise(Total_sal=sum(SAL))
print(result)

#문제 7: 커미션(COMM)이 결측치가 아닌 
#직원들의 이름(ENAME), 커미션(COMM)을 출력하세요.(시험 단골 출제!!!)
# 힌트 : filter(!is.na()), select()
result=emp%>% filter(!is.na(COMM))%>% select(ENAME, COMM)
print(result)

#문제 8: "SALES" 부서에서 근무하는 
#직원들의 이름(ENAME), 급여(SAL), 커미션(COMM)을 출력하세요.
# 힌트 : inner_join(), filter(), select() 
result=emp%>% inner_join(dept, by='DEPTNO')%>%
  filter(DNAME=='SALES')%>%
  select(ENAME, SAL, COMM)
print(result)

#문제 9: 각 부서(DNAME)별로 가장 높은 급여를 받는 
#직원의 이름(ENAME)과 급여(SAL)를 출력하세요.
# 병합(join) 1순위, arrange 제일 마지막!
# 힌트 : group_by(), slice_max(), select()
result= emp%>% inner_join(dept, by='DEPTNO')%>%
  group_by(DNAME)%>%
  slice_max(SAL, n=1)%>%
  select(ENAME, SAL)
print(result)

#문제 10: 직업(JOB)이 "MANAGER"인 직원들의 
#이름(ENAME), 부서명(DNAME), 급여(SAL)을 출력하세요.
# 힌트 :  inner_join(), filter(), select()
result=emp%>% inner_join(dept, by='DEPTNO')%>%
  filter(JOB=='MANAGER')%>%
  select(ENAME, DNAME, SAL)
print(result)
