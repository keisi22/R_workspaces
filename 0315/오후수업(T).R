library(dplyr)
#데이터셋 읽기
#fileEncoding = "CP949" : 한글 컬럼 읽기
health = read.csv('health.csv', fileEncoding = "CP949")

# 문제 2: 2022년에 건강검진을 받은 사람들만 필터링하세요.
result = health %>% filter(기준년도 == 2022)

# 문제 3: 키(height)와 몸무게(weight) 열을 사용하여 
# 새로운 열 BMI를 추가하세요.
# bmi = weight / (height/100)^2
health = health %>%
  mutate(BMI = 체중.5kg단위. / (신장.5cm단위. / 100)^2)
# 문제 5: 성별(성별)로 데이터를 그룹화하고, 
# 각 그룹별 평균 BMI를 계산하세요. 
# 결과는 성별과 `평균_BMI 열`로 구성되어야 합니다.
result = health %>%
  group_by(성별) %>%
  summarise(평균_BMI = mean(BMI, na.rm = TRUE))
# View(result)
# 문제 : 연령대별 평균 체중 계산
result = health %>%
  group_by(연령대코드.5세단위.) %>%
  summarise(평균체중 = mean(체중.5kg단위., na.rm = TRUE))

# 문제 : 시도코드별로 평균 신장(5Cm 단위)을 계산하고, 
# 가장 높은 신장을 가진 시도코드 추출.

# group_by + sumar.. 
# mean + na.rm
# arrnage -> slice_head
avg_by_region = health %>%
  group_by(시도코드) %>%
  summarise(평균신장 = mean(신장.5cm단위., na.rm= TRUE)) %>%
  arrange(desc(평균신장)) %>%
  slice_head(n = 1)
print(avg_by_region)

# 음주여부에 따라 체중과 허리둘레의 상관관계 알기
# cor : correlation(상관관계)
# use="complete.obs" : 상관계수를 계산할 때 
# 결측값이 포함된 데이터는 제외하고 계산한다.
drinking = health %>%
  group_by(음주여부) %>%
  summarise(상관계수 = cor(체중.5kg단위., 허리둘레, use="complete.obs"))
View(drinking)
# 1은 true => 술 o
# 0은 false => 술 x
# 상관관계는 두 변수 간의 관계를 수치적으로 나타내는 통계적 개념
# 상관계수는 보통 -1에서 1까지의 값을 가집니다.
# 1: 완벽한 선형관계를 가짐, 즉 한 변수가 증가하면 다른 변수도 증가함
# -1 : 한 변수가 증가할 때 다른 변수는 감소함
# 0 : 관계없음
