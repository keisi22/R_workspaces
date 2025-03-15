#fileEncoding ='CP949' : 한글 칼럼 읽기
health =read.csv('health.csv', fileEncoding ='CP949')
#View(health)
library(dplyr)

#문제 1: 데이터프레임의 앞부분 출력 단, 2행만
head(health, 2)

#문제 2: 데이터프레임의 뒷부분 출력 단, 5행만
tail(health, 5)

#문제 3: 데이터프레임의 구조 확인
str(health)

#문제 1: 데이터셋에서 성별, 연령대, 그리고 지역 열만 선택하세요.
result= health%>% select(성별, 연령대코드.5세단위., 시도코드)

#문제 2: 2022년에 건강검진을 받은 사람들만 필터링하세요.
result=health%>% filter(기준년도==2022)

#문제 3: 키(height)와 몸무게(weight) 열을 사용하여 새로운 열 BMI를 추가하세요.
#BMI공식은 아래와 같습니다.
health=health%>%
  mutate(BMI=체중.5kg단위./((신장.5cm단위./100)**2))

health=health%>%
  mutate(BMI=체중.5kg단위./((신장.5cm단위./100)^2))
#View(health)

#문제 4: 건강검진 결과를 기준으로 혈압 값을 내림차순으로 정렬하세요.
result=health%>%
  arrange(desc(수축기혈압))

#문제 5: 성별(성별)로 데이터를 그룹화하고, 각 그룹별 평균 BMI를 계산하세요.
#결과는 성별과 평균_BMI 열로 구성되어야 합니다.
result=health%>%
  group_by(성별)%>%
  summarise(평균_BMI=mean(BMI, na.rm=TRUE))%>%
  select(성별, 평균_BMI)
#View(result)

# 문제 :연령대별 평균 체중 계산
result=health%>%
  group_by(연령대코드.5세단위.)%>%
  summarise(평균체중=mean(체중.5kg단위., na.rm=TRUE))
#View(result)

# 문제: 시도코드별로 평균신장을 계산하고
# 가장 높은 신장을 가진 시도코드 추출
result=health%>%
  group_by(시도코드)%>%
  summarise(평균신장=mean(신장.5cm단위., na.rm=TRUE))%>%
  arrange(desc(평균신장)) %>%
  slice_head(n=1)
print(result)

# 음주여부에 따라 체중과 허리둘레의 상관관계 알기
# cor : cirrelation(상관관계)
# use='complete.obs' : 상관계수를 계산할 때 결측값이 포함된 데이터는 제회하고 계산한다
drinking=health%>%
  group_by(음주여부)%>%
  summarise(상관계수 = cor(체중.5kg단위., 허리둘레, use='complete.obs'))
#View(drinking)
# 1=TRUE : 음주O
# 0=FALSE : 음주X
# 상관계수는 보토 -1~1 값을 가진다
# 1 : 완벽한 선형관계를 가짐, 즉 한 변수가 증가하면 다른 변수도 증가함
# -1 : 한 변수가 증가할 때 다른 변수는 감소함
# 0 : 관계없음

# 연렫대 코드가 10이하, 행 개수 추출
# nrow : number of rows
result=health%>%
  filter(연령대코드.5세단위.<=10)%>%
  nrow()
print(result) 