# 종로구, 중구, 용산구가 현재 가장 폐업율이 높음
# 왜 높을까?
# 1. 물가 상승 or 2. 노인 수 급증(추측)

# 노인 수 많을 것이라 추측
# 종로구 노인 인구 비율 조회 필요

library(dplyr)
library(ggplot2)

elder=read.csv('고령인구현황.csv',
               fileEncoding = 'CP949',
               encoding = 'UTF-8',
               check.names = FALSE)

# 전처리
# 종로구의 22년~24년 65세이상 전체 컬럼 조회
elder_data=elder%>%
  filter(행정구역=='서울특별시 종로구 (1111000000)')%>%
  select(`2022년_65세이상전체`, `2023년_65세이상전체`, `2024년_65세이상전체`)
#View(elder_data)

df=data.frame(
  time=c('2022-01-01', '2023-01-01','2024-01-01'),
  elder_count=c(elder_data$`2022년_65세이상전체`,
                elder_data$`2023년_65세이상전체`,
                elder_data$`2024년_65세이상전체`)
)

df$time=as.Date(df$time)
df$elder_count=as.numeric(gsub(',','',df$elder_count))
print(df)

p=ggplot(data=df, aes(x=time, y=elder_count))+
  geom_line()+
  labs(title='종로구 인구수 변화',
       x='연도',
       y='노인(65세 이상) 수')
print(p)

# 상승률 계산
# 상승률 = 최종값 - 초기값 / 초기값 *100
# 올해 - 작년 / 작년* 100
# increase_rate 컬럼 생성
# diff : 연속된 값들 사이의 차이를 계산

df$increase_rate = c(0, diff(df$elder_count)/ df$elder_count[-length(df$elder_count)]*100)
print(df) # 상승률 확인
