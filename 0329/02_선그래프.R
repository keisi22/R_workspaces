# 선그래프
# 순서가 있는 변수를 x축에 배치, 이에 따른 y축 값의 변화를
# 선으로 연결하여 시각화하는 그래프
# 시간의 흐름에 따른 데이터 표현시 많이 사용

library(dplyr) # 전처리 도구
library(ggplot2) # 그래프 도구

# 데이터 프레임 생성
df= data.frame(
   Time=c('2025-03-01', '2025-03-02', '2025-03-03'),
   Revenue=c(300,500,2500)
 )
 
# 컴퓨터는 문자 아니면 숫자만 인식
# Time을 날짜 형변환
 
df$Time=as.Date(df$Time) #문자-> 날짜
 
# 선그래프 생성
p=ggplot(data=df, aes(x=Time, y=Revenue))+
  geom_line(color='blue')+
  labs(title='시간에 따른 수익금',
       x='날짜',
       y='수익금')
print(p)


