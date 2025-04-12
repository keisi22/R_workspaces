# 독립표본(서로 다른 두 집단 비교)
library(dplyr)
library(ggplot2)

# 남 vs 여 국어점수 비교
score_data = read.csv('korean_scores.csv')
# View(score_data)

# 성별에따른 국어점수 비교
# ~ : 왼쪽 변수를 오른쪽 변수 기준으로 분석.
# korea_score ~ gender : 국어(korea_score)를 성별(gender) 기준으로 
# T검정을 수행한다
t_test_result = t.test(korean_score ~ gender, data = score_data)

print(t_test_result$p.value) # 0.293..
if(t_test_result$p.value < 0.05){
  print('성별에 따른 국어점수 차이가 있을 가능성이 있어!')
}else{
  print('성별에 따른 국어점수 차이는 없어!')
}

# 박스플롯 생성
p = ggplot(score_data, aes(x = gender, y = korean_score, fill = gender)) +
  geom_boxplot() + 
  scale_fill_manual(values = c('Male' = 'lightblue', 'Female' = 'pink')) +
  labs(title = '성별에 따른 국어점수', x = '성별' , y = '국어점수') +
  theme_minimal() #회색배경 제거

print(p)