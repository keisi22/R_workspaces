# 일표본 T-TEST(귀무가설을 출발점으로 삼는다)
# 귀무가설 : A와 B를 비교했을 때 차이가 없다를 가정
# 단일집단의 표본 평균 vs 알려진 모집단 평균

# 제품 규격 준수 여부 확인
# 평균 18.5, 표준편차 2.3을 가진 50개 랜덤 데이터
protein_content = rnorm(50, mean=18.5, sd=2.3)
#print(protein_content)

# 실제 단백질 함량이 광고된 값과 일치하는가?
# T검정(일표본)

# 알려진 단백질 함량 = 20g (광고에 표기된 단백질 함량) <-알려진 모집단 평균

t_test_result= t.test(protein_content, mu = 20)
print(t_test_result)

# 0.05 <- T검정에서 귀무가설 기각여부 기준 값
if(t_test_result$p.value <0.05){
  print('실제 단백질 함량이 광고된 값과 다를 가능성이 높습니다.')
  print('귀무가설 기각')
}else{
  pirnt('실제 단백질 함량이 광고된 값과 일치해')
  print('귀무가설 채택')
}


# 한 제조업체에서 생산하는 금속 막대의 평균길이가 150cm라고 주장
# 품질 관리팀은 30개의 샘플을 무작위 추출하여
# 측정한 결과 검증

metal_bar_data=read.csv('One-sample.csv')
#View(metal_bar_data)

# T-검정 수행
# 평균 길이가 150cm 주장 -> 알려진 모집단 평균

t_test_result = t.test(metal_bar_data$metal_bars_cm, mu=150)

# p.value : p값, 귀무가설이 참이라는 가정에 따라 주어진
# 표본 데이터를 희소 또는 극한 값으로 얻을 확률
if(t_test_result$p.value <0.05){
  print('금속 막대의 평균길이가 150cm랑 다를 가능성이 높습니다.')
  print('귀무가설 기각') # 대립가설 채택
}else{
  pirnt('금속 막대의 평균길이는 알려진 것과 차이가 없음')
  print('귀무가설 채택')
}

