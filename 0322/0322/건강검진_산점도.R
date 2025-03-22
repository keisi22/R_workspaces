# 건강검진 csv 파일을 사용해서
# 신장과 몸무게 관계를 산점도 그래프로 표현
# x축은 신장, y축은 체중
# 회귀선 추가

#install.packages('ggplot2')
library(dplyr)
library(ggplot2)
library(plotly)
health=read.csv('health.csv',
                fileEncoding ='CP949',
                encoding= 'UTF-8',
                check.names=FALSE)
#View(health)

p=ggplot(data=health, aes(x=`신장(5cm단위)`, y=`체중(5kg단위)`)) +
  geom_point(size=3) +
  geom_smooth(method = 'lm', se = FALSE, color= '#3fe3cd') + # 구글에 색상코드 참고
  labs(title = '신장과 체중 관계',
       x = '신장(cm)',
       y = '체중(kg)')
#print(p)

# 혈색소 vs BMI 관계를 파악
# 혈색소가 높은 사람은 세모표시, 그외 공그라미 표시
# 남자와 여자 구분
# 혈색소가 높으면 심장미비, 뇌졸중 발생 가능성 높음
# BMI = 체중/(신장/100)^2

health2= health%>%
  mutate(BMI=`체중(5kg단위)`/((`신장(5cm단위)`/100)^2),
         Grade= ifelse(혈색소 >= 16, 'High', 'Normal'),
         Gender= ifelse(성별 == 1, 'Male', 'Female')
         )
#View(health2)

# 전처리 끝났으면 그래프로 표현하기
# 17번 세모, 16번 동그라미
p = ggplot(data= health2, aes(x=혈색소, y=BMI))+
  geom_point(aes(color = Gender, shape = Grade),  size=1.5) +
  scale_color_manual(values = c('Male'= 'blue', 'Female'='red')) +
  scale_shape_manual(values = c('High' = 17, 'Normal'= 16)) +
  geom_smooth(method = 'lm', color='orange') +
  labs(title = 'BMI와 혈색소 관계',
       x = '혈색소',
       y = 'BMI',
       color= 'Gender',
       shape= 'Grade') +
  theme_minimal() # 뒤에 회색 배경 지우기
#print(p)

# 퀴즈
# 연령코드가 5~8번이고 , 지역코드가 41번인 사람의
# 허리둘레와 식전혈당(공복혈당) 관계를 그래프로 표현하기
# 단, 남성은 파랑색, 여성은 빨강색 표기
# 식전혈당(공복혈당) 100이상은 별모양(11번) 그외 동그라미 표기
# pdf로 저장까지

health3=health%>%
  filter(`연령대코드(5세단위)`>=5 & `연령대코드(5세단위)`<=8 & 시도코드==41)%>%
  mutate(Grade= ifelse(`식전혈당(공복혈당)` >= 100, 'High', 'Normal'),
         Gender= ifelse(성별 == 1, 'Male', 'Female'))%>%
  select(허리둘레, `식전혈당(공복혈당)`, Gender, Grade)
View(health3)

p= ggplot(data=health3, aes(x=`식전혈당(공복혈당)`, y=허리둘레)) +
  geom_point(aes(color=Gender, shape=Grade), size=1.5) +
  scale_color_manual(values = c('Male'='blue', 'Female'='red')) +
  scale_shape_manual(values = c('High'= 11, 'Normal'= 16)) +
  geom_smooth(method ='lm', se = FALSE, color='#9dfd4e') +
  labs(title ='허리둘레와 식전혈당(공복혈당) 관계', 
       x = '식전혈당(공복혈당)',
       y= '허리둘레',
       color = 'Gender',
       shape = 'Grade') +
  theme_minimal()
print(p)

pdf.options(family = 'Korea1deb')
ggsave('plot.pdf')

 
