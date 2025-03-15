#데이터프레임
# 1.경로확인
print(list.files()) #해당 경로에 있는 파일 목록
print(getwd()) # 해당 경로 조회
# getwd : Get Working Directory
# 프로그래밍에서  get 이라는 용어가 나오면 '불러온다'는 의미

# 2.경로수정
setwd('D:/r-data')
# Setting Working Directory
# set은 설정 의미

# 3.파일 불러오기
emp=read.csv('emp.csv')
#View(emp)

# 암기(시험단골!!!)
print(dim(emp)) # 행/열의 수 확인
print(head(emp, 4)) # 데이터 상위 1~4행까지
print(tail(emp, 4)) # 데이터 하위 1~4행까지
print(str(emp)) # 데이터프레임 '데이터 타입 확인'

# 특정 열 출력
print(emp$ENAME) # ENAME만 출력

# dplyr(data frame plier) : 데이터프레임을 다루는 '공구'
# install.packages('dplyr') # 처음에만 설치가 필요
library(dplyr) # 설치한 dplyr 로드

emp_ename= emp%>% select(ENAME) # ENAME만 선택 출력
print(emp_ename)

# 필터링 후 select
# & : AND 연산자
emp_data= emp%>% filter(SAL>=2000 & DEPTNO==20)%>%
  select(ENAME, JOB, DEPTNO)

# 필수 암기!!!
# filter : 행 필터링
# select : 특정 벡터(열) 선택
# mutate : 새로운 벡터(열) 추가
# arrange : 정렬(오름차순, 내림차순)
# group_by +summarise : 데이터 그룹 + 데이터 요약
# R은 group_by 단독 사용 불가능
# join : 데이터프레임 병합

# slice : 지정된 행 번호에 해당하는 행 선택
                                    