# 독립표본
# 서로 다른 두 집단 비교
# ex) 남녀 소비패턴 차이 분석, 교육 방법에 따른 사원 실적 분석

data=read.csv('korean_scores.csv')
#View(data)

# 남녀 국어 점수 비교
# 성별로 국어점수 평균과 표준편차, 학생수를 필터링
library(dplyr)

filtered_data =data%>%
  group_by(gender)%>%
  summarise(Mean=mean(korean_score),
            SD=sd(korean_score),
            N=n())
#View(filtered_data)

# ~ : 왼쪽 변수를 오른쪽 변수 기준으로 분석
# korean_score(국어점수)를 gender(성별) 기준으로 그룹을 나누어 T검정 수행
# 왼쪽(종속 변수), 오른쪽(독립 변수) 
# 종속변수는 독립변수의 변화에 따라 값이 변하는 변수
# 독립변수는 결과에 영향을 미치는 변수
# 예) 광고비 100만원을 늘렸을 때 구독자가 천명 증가했다
# 100만원이 독립변수(원인), 구독자 증가 종속변수(결과)
t_test_result=t.test(gender ~ Mean, data=filtered_data)

# 길동학교 남녀 국어 평균은 차이가 없을꺼야(귀무가설 시작)
# P값 0.05보다 작으면 귀무가설 기각 -> 대립가설 채택
#if(t_test_result$p.value <0.05){
#  print('귀무가설 기각')}