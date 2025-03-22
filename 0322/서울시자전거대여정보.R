library(dplyr)
library(ggplot2)
setwd('D:/r-data')
bicycle_data=read.csv('seoul_public_bicycle_data.csv',
                fileEncoding ='CP949',
                encoding= 'UTF-8',
                check.names=FALSE)
#View(bicycle_data)

#1. 대여소번호별 이용건 수 막대그래프 표현.
#(x축 : 대여소번호 , y축: 이용건 수)
bicycle2=bicycle_data%>%
  group_by(대여소번호)%>%
  summarise(count=n())

p=ggplot(data=bicycle2, aes(x=대여소번호, y=count))+
  geom_col(fill='blue')+
  labs(title='대여소번호별 이용건 수',
       x='대여소번호',
       y='이용건수')
#print(p)
pdf.options(family = 'Korea1deb')
ggsave('자전거1.pdf')

#2. 정기권을 구매한 이용자 중 연령대 별 평균 운동량 막대그래프로 표현.
#단, 이용시간(분) 5분 이하는 평균에서 제외
#(x축 : 연령대 , y축: 평균 운동량)
bicycl3=bicycle_data%>%
  filter(대여구분코드=='정기권' & `이용시간(분)`>5)%>%
  group_by(연령대코드)%>%
  summarise(평균_운동량=mean(운동량))

p2=ggplot(data=bicycl3, aes(x=연령대코드, y=평균_운동량))+
  geom_col(fill='purple')+
  labs(title='정기권 구매 이용자 중 연령대별 평균 운동량',
       x='연령대',
       y='평균 운동량')
#print(p2)
ggsave('자전거2.pdf')

#3. 연령대코드 별 이용시간과 운동량을 비교하는 산점도 그래프 표현.
#(x축 : 이용시간, y축: 운동량 )
#조건 1. 연령대 별 색깔 (10대 : 노랑(yellow), 20대 : 블루(blue), 30대 : 퍼플(purple), 40대: 초록(green), 50대 : 블랙(black))
## 난이도 업(할 수 있는사람만)
#조건 2. 연령대 별 중 운동량을 스케일(minmax) 후 0.5 이상인 회원은 세모표시(17)
bicycl4=bicycle_data%>%
  mutate(minmax=(운동량-min(운동량))/(max(운동량)-min(운동량)),
         Grade= ifelse(minmax>=0.5, 'High', 'Normal'))%>%
  group_by(연령대코드)
#View(bicycl4)

p3=ggplot(data=bicycl4, aes(x=`이용시간(분)`, y=운동량))+
  geom_point(aes(shape=Grade, color=연령대코드), size=1.5)+
  scale_color_manual(values = c('10대'='yellow', '20대'='blue', '30대'='purple', '40대'='green', '50대'='black'))+
  scale_shape_manual(values = c('High'=17, 'Normal'=16))+
  geom_smooth(method='lm', se=FALSE, color='red')+
  labs(title='연령대별 이용시간과 운동량 비교',
       x='이용시간',
       y='운동량',
       color='연령대코드',
       shape='Grade')+
  theme_minimal()
print(p3)

ggsave('자전거3.pdf')
  

# 그래프 3개 저장할 것!