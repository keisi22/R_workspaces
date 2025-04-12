# 대응 표본 (동일 집단의 전후 비교)

# 교육 프로그램 효과 평가 
# 가상의 체중 데이터를 생성
before = c(75,68,80,72,85) #프로그램 참여 전 체중
after = c(72,65,77,70,80) #프로그램 참여 후 체중 

# 대응 표본 T검정 수행
# *paired : 짝을 이루는(동일 집단)
# 동일집단이라고 설정해야함.
t_test_result = t.test(before, after, paired = TRUE)

# 결론 출력
# p.value(P값)
# 0.05 (유의성의 임계값)
if(t_test_result$p.value < 0.05){
  print('결론 : 프로그램의 체중 감소가 통계적으로 유의한 효과가 있습니다.')
}else{
  print('결론 : 다이어트 프로그램의 효과가 통계적으로 유의하지 않습니다.')
}

setwd('D:/r-data')
exercise_data = read.csv('exercise_data.csv')
#View(exercise_data)
# *****str
print(str(exercise_data)) #데이터 구조 확인

# 20대 운동 전과 후 감소가 유의한 효과가 있는지 대응표본으로 검증
library(dplyr)

# 20대만 필터링해서 View 출력
# substr : 특정 문자 추출 
# !is.na : 결측값이 아닌
# is.na: 결측값이면
data = exercise_data %>%
  filter(substr(Age,1,1) == 2 & !is.na(Post_Weight))
# View(data) #결측값이 제거된 20대 데이터

t_test_result = t.test(data$Pre_Weight, data$Post_Weight, paired = TRUE)

if(t_test_result$p.value < 0.05){
  print('다이어트 프로그램 체중 감소가 있었습니다.')
}












