# 3. 폐점확률
#가중평균=∑(값×가중치)

#직장인인구율 = 24년도_직장인인구율 + 24년도_직장인증가율
#폐점율 = 24년도_폐점율 + 24년도_폐점증가율

#직장인_가중치  = 0.6 (직장인 수, 소비 패턴, 직장인 월급)
#폐점_가중치 = 0.4 (임대료 상승, 경기 침체)

#폐점_확률 = (직장인인구율 * 직장인_가중치) + (폐점율 * 폐점_가중치)

library(dplyr)
library(ggplot2)
library(sf)
library(ggiraph)

salaryman=read.csv('서울시 상권분석서비스(직장인구-자치구).csv',
                   fileEncoding = 'CP949',
                   encoding = 'UTF-8',
                   check.names = FALSE)

# 연도별 직장인_인구수
salaryman_count=salaryman%>%
  mutate(year=substr(기준_년분기_코드, 1, 4))%>%
  group_by(자치구_코드_명, year)%>%
  summarise(총직장인구=sum(총_직장_인구_수))
#View(salaryman_count)

# 24년도 직장인 증가율
# 올해 - 작년 / 작년* 100
# increase_rate 컬럼 생성

# 2023년 총직장인구
salaryman_2023=salaryman_count%>%
  filter(year=='2023')%>%
  mutate(총인구_2023=총직장인구)
#View(salaryman_2023)

# 2024년 총직장인구
salaryman_2024=salaryman_count%>%
  filter(year=='2024')%>%
  mutate(총인구_2024=총직장인구)

# 2024년 직장인 증가율
salaryman_increase_rate=inner_join(salaryman_2023, salaryman_2024, by='자치구_코드_명')%>%
  mutate(증가율=(총인구_2024-총인구_2023)/총인구_2023*100)
#View(salaryman_increase_rate)


#폐점율 = 24년도_폐점율 + 24년도_폐점증가율
seoul_comm_data=read.csv('seoul_commercial_analysis.csv',
                         fileEncoding = 'CP949',
                         encoding = 'UTF-8',
                         check.names = FALSE)
