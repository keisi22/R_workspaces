library(dplyr)
library(ggplot2)
library(sf) # 지도 시각화
library(ggiraph) # 지도 시각화 이벤트

korea_map=st_read('sig.shp')

seoul_map=korea_map%>%
  filter(substr(SIG_CD, 1, 2)=='11') # 서울만 가져오기

# 미세먼지 데이터 불러오기
dust_data=read.csv('data.csv',
               fileEncoding = 'CP949',
               encoding = 'UTF-8',
               check.names = FALSE)
#View(dust_data)

# 미세먼지 station_code(지역코드)
# join을 이용해서 shp파일과 data.csv 병합하기

dust_data=dust_data%>%
  mutate(station_code=as.character(station_code))
# 데이터타입이 동일해야 병합 가능

merged_data=inner_join(seoul_map, dust_data, by=c('SIG_CD'='station_code'))
#View(merged_data)

# 심플지도
# 지도는 x축=경고, y축=위도 정해져 있음
p=ggplot(data=merged_data)+
  geom_sf(aes(fill=pm10_concentration_ug_m3), color='black')+ # 자치구 경계선 검정
  scale_fill_gradient(low='blue', high='red', name='미세먼지농도')+
  theme_minimal()+  # 회색배경 제거
  labs(title='서울시 미세먼지 농도',
       x='경도',
       y='위도')
#print(p)

# 숙제!!!
# 1. 24년도 총 직장 인구수가 가장 많은 자치구 5개만 지도로 표현
# 2. 24년도 서울 총 직장인 인구 수 대비 각 자치구 직장인 인구 수 비율 구하기

salaryman=read.csv('서울시 상권분석서비스(직장인구-자치구).csv',
                   fileEncoding = 'CP949',
                   encoding = 'UTF-8',
                   check.names = FALSE)
#View(salaryman)

salaryman=salaryman%>%
  mutate(자치구_코드=as.character(자치구_코드))
#print(str(salaryman$자치구_코드))

merged_salaryman=inner_join(seoul_map, salaryman, by=c('SIG_CD'='자치구_코드'))%>%
  mutate(year=substr(기준_년분기_코드, 1, 4))%>%
  filter(year=='2024')%>%
  group_by(자치구_코드_명)%>%
  summarise(total_직장인구수=sum(총_직장_인구_수))%>%
  arrange(desc(total_직장인구수))%>%
  slice_head(n=5)
#View(merged_salaryman)

p1=ggplot(data=merged_salaryman)+
  geom_sf(aes(fill=total_직장인구수), color='black')+
  scale_fill_gradient(low='#e9cde6', high='#015fb0', name='총직장인구수')+
#  geom_sf_interactive(aes(
#      fill = total_직장인구수,
#      tooltip = 자치구_코드_명,
#      data_id = SIG_CD))+
  theme_minimal()+
  labs(title='2024년 총 직장 인구수',
       x='경도',
       y='위도')

girafe_plot = girafe(ggobj = p1)
print(girafe_plot)




