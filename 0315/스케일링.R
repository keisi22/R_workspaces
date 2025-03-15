# 데이터스케일링!!!!!
# '데이터 분석' 및 '머신러닝'에서 중요한 전처리 과정
# 변수의 크기를 조정하여 (머신러닝)성능을 향상시키거나 결과를 해석하기 쉽게 만든다.

# Min-Max 정규화
# 데이터스케일링 방법 중 하나(대표적인)
# Min-Max는 데이터를 0에서 1사이로 변환하는 데이터 전처리 기법

# 에제 데이터프레임
data=data.frame(
  height=c(150,160,170,180,190),
  weight=c(50,60,70,80,90)
)
#View(data)
# 키와 몸무게는 단위와 범위가 다르기 때문에
# 두 데이터를 그대로 비교하거나 분석하기 어렵다.
# 이를 해결하기 위해 키와 몸무게를 0~1 사이로 스케일링하면
# 두 변수는 동일한 기준에서 비교할 수 있다.

# 스케일링 값 = (원래값-최소값) / (최대값-최소값)

# 키 스케일링
height_min=min(data$height) # 키 최소값
height_max=max(data$height) # 키 최대값
data$scaled_height=(data$height-height_min) / (height_max-height_min)

# 몸무게 스케일링
weight_min=min(data$weight) # 몸무게 최소값
weight_max=max(data$weight) # 몸무게 최대값
data$scaled_weight=(data$weight-weight_min) / (weight_max-weight_min)

#View(data)

# emp 데이터에서 급여(SAL)열에 대해 Min-Max
# 정규와 수행(SAL_MimMax 컬럼 추가)
emp=read.csv('emp.csv')
library(dplyr)
#View(emp)

SAL_min=min(emp$SAL, na.rm=TRUE)
SAL_max=max(emp$SAL, na.rm=TRUE)
emp$SAL_MinMax=(emp$SAL-SAL_min)/(SAL_max-SAL_min)
#View(emp)

# 0.5보다 큰 값을 가지는 데이터 추출
result=emp%>% filter(SAL_MinMax >= 0.5)%>%
  select(ENAME, SAL, SAL_MinMax)%>%
  arrange(desc(SAL_MinMax))
View(result)

