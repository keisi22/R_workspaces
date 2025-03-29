# 산점도 그래프 : 두개으 변수 관계 확인
# 예) 키 vs 몸무게, 중간고사 vs 기말고사

# 막대 그래프 : 그룹별 빈도나 크기를 비료할 때
# 예) 판매량 비교, 직업별 소득

# 박스플롯 : 데이터의 분포를 표현
# 예) 각 반 또는 학년 별 성적 분포, 주식차트

# 오늘 배울 그래프
# 선 그래프
# 지도 시각화


# 산점도 그래프 복습
# 넷플릭스 데이터셋을 사용하여
# 출신연도 vs 영화 길이 관계 파악

library(dplyr) # 전처리 도구
library(ggplot2) # 그래프 도구

# 데이터 불러오기
setwd('D:/r-data')
netflix_data=read.csv('netflix.csv')

# 데이터 확인
#View(netflix_data)

# 데이터 전처리
# 영화의 상영시간을 알아내야 함

# 문자열 복습!!!
# gsub : 다른 문자로 '대체'
# strsplit : 특정 문자를 기준으로 '나누다'
# substr : 특정 위치 문자만 '추출'(오려내기)

movie_data=netflix_data%>%
  filter(type=='Movie')%>%
  mutate(gsub_duration=as.numeric(gsub(' min', '', duration)))

# 산점도 그래프 생성
p=ggplot(data=movie_data, aes(x=release_year, y=gsub_duration))+
  geom_point(size=1)+
  geom_smooth(method='lm', se=FALSE, color='red')+ # 회귀선 추가
  labs(title='영화 길이 vs 출시연도',
       x='출시연도',
       y='영화길이(분)')
print(p)

