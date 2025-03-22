# 산점도 그래프 만들기
# 산점도(Scatter) 두 개의 변수 간의 관계를 시각적으로 나타냄
# 예) 키와 몸무게 관계, 온도와 에너지 소비량 관계

# 그래프 기본 만들기

#install.packages('ggplot2') # 그래프 설치
library(ggplot2)

# 데이터 생성
# 중간고사 점수와 기말고사 점수 산점도 그래프로 표현

students =data.frame(
  ID=1:10, #1~10 생성(학생(ID))
  Midterm=c(87, 59, 68, 97, 84, 76, 65, 90, 72, 88),
  Final=c(85, 62, 70, 95, 89, 80, 67, 98, 75, 200)
)
#View(students)

# 산점도 그래프 그리기
# data = students : 그래프에 추가할 데이터 프레임
# aes : Aesthetics(미학)
# x축 : 중간고사 점수, y축 : 기말고사 점수
# labs : Laboratory(연구소, 실험실)
# lm : Linear Motion(선형)
#install.packages('plotly') # 그래프 이벤트 설치
library(plotly) # 그래프 이벤트 로드

p=ggplot(data= students, aes(x=Midterm, y=Final)) +
  geom_point(aes(text = paste('ID:', ID)), size=5) + # 산점도 점 크기 조절
  geom_smooth(method = 'lm', se = FALSE, color= 'blue') + # 회귀선 추가
  labs(title = '중간고사 vs 기말고사 성적 분포도',
       x = '중간고사 점수',
       y = '기말고사 점수')

p = ggplotly(p) # 인터랙티브 그래프 변환

print(p)

# 작성한 그래프 pdf 파일로 만들기
# ggsave('산점도그래프.pdf')




