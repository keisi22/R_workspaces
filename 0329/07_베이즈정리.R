# 베이즈 정리
# 조건부 확률을 계산하는 수학적 공식으로
# 특정 사건의 발생 확률을 증거를 반영하여 계산
# 이정리는 18세기 영국 수학자 '토마스베이즈'의 이름을 따서 명명

# 실생활 예시
# 금융 : 대출 위험 평가, 투자 성공 확률
# 의료 : 질병의 정확한 진단 확률 계산

# 제조업에서
# 두개의 생산라인을 가진 공장에서 생산된 2000대의 자전거릴
# 창고에 적재(각, 라인별 1000대씩 생산했다고 가정)
# 조사 해보니 1번 라인의 경우 8% 불량
# 2번 라인은 15.7%가 불량임을 확인
# 창고에 적재한 자전거 하나를 선택하여 조사한 결과
# 이 자전거가 1번 라인의 생산품일 확률을 구해보자

bike_data=read.csv('bike_data.csv')
#View(bike_data)

# 생산된 자전거 총수
# nrow(): 행 수
bike_total= bike_data%>% nrow()
print(bike_total)

bike_count=bike_data%>%
  group_by(production_line)%>%
  summarise(count=n())

# 샹산 라인 별 결함 비율
# defect가 1이면 결함을 의미, 0 정상
bike_defect=bike_data%>%
  group_by(production_line)%>%
  summarise(percentage=mean(defect==1)*100)
#View(bike_defect)

# 각 라인별 생산된 자전거 수와 결함 수 변수로 만들기
bike_1_count=bike_data%>% # 1번 라인 자전거 수
  filter(production_line==1)

bike_2_count=bike_data%>%  # 2번 라인 자전거 수
  filter(production_line==2)

bike_1_defect=bike_defect%>% # 1번 라인 결함
  filter(production_line==1)

bike_2_defect=bike_defect%>%  # 2번 라인 결함
  filter(production_line==2)

# 확률 초기화
p_L1 = bike_1_count$count / bike_total
p_L2 = bike_2_count$count / bike_total

p_D_L1 = bike_1_defect$percentage # 1번 라인 결함
p_D_L2 = bike_2_defect$percentage # 2번 라인 결함

# 전체 불량 확률 계산
p_D = (p_D_L1 * p_L1) + (p_D_L2 * p_L2)

# 베이즈 정리 적용
bayes=(p_D_L1 * p_L1) / p_D
print(bayes*100) # 33% 출력

# 베이즈 정리 공식

# P(A|B) = (P(B|A) ' P(A)) /P(B)
# P(A|B) : 사후 확률, 사건 B가 발생했을 때 사건 A가 발생할 확률
# P(B|A) : 사건 A가 발생했을 때 사건 B가 발생할 확률
# P(A) : 사건 A의 사전 확률
# P(B) : 사건 B의 주변 확률(사건 B가 발생할 확률)