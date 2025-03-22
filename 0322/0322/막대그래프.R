library(ggplot2)

netflix_data=data.frame(
  Show =c('나의 완벽한 비서',
          '중증외산센터',
          '말할 수 없는 비밀',
          '체크 인 한양',
          '별들에게 물어봐'), # 제목
  Viewship=c(90,98,93,66,39)  # 시청률
)
 # 바 그래프 생성
p= ggplot(data=netflix_data, aes(x=Show, y=Viewship)) +
  geom_col(fill = 'steelblue') + 
  labs(title= '넷플릭스 인기 프로그램 시청률',
       x = '프로그램 명',
       y='시청률(백만)')
#print(p)

library(dplyr)
health_data=read.csv('health.csv',
                fileEncoding ='CP949',
                encoding= 'UTF-8',
                check.names=FALSE)

# 막대그래프
# 범주형 데이터의 빈도나 크기를 비교할 때
# 예) 제품 별 판매량 비교, 직업 별 평균소득

#연령대별 허리둘레 그래프 구현

graph_data= health_data%>%
  filter(성별==1)%>%
  group_by(`연령대코드(5세단위)`)%>%
  summarise(평균허리둘레 =mean(허리둘레, na.rm=TRUE))
#View(graph_data)
p=ggplot(data=graph_data, aes(x=`연령대코드(5세단위)`, y=평균허리둘레))+
  geom_col(fill='steelblue')+
  labs(title='연령대코드 별 허리둘레',
       x='연령대코드',
       y='허리둘레')
#print(p)

# 퀴즈
# 성별로 혈청지피티(ATL) 평균을 그래프로 표현
# 단, 연령대코드가 3~6 사이
# Gender 컬럼 추가, 남자 'Male', 여자 'Female'
graph_data=health_data%>%
  filter(`연령대코드(5세단위)`>=3 & `연령대코드(5세단위)`<=6)%>%
  group_by(성별)%>%
  summarise(MEAN_ALT=mean(`혈청지피티(ALT)`, na.rm=TRUE))%>%
  mutate(Gender=ifelse(성별==1, 'Male', 'Female'))
# View(graph_data)

p=ggplot(data=graph_data, aes(x=`성별`, y=MEAN_ALT, fill=Gender))+
  geom_col()+
  scale_fill_manual(values=c('Male'='blue', 'Female'='red'))
  labs(title='성별 평균 혈청지피티',
       x='성별',
       y='평균 ALT')
print(p)

