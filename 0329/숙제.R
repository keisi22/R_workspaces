library(dplyr)
library(ggplot2)
library(sf)
library(ggiraph)

korea_map=st_read('sig.shp')
seoul_map=korea_map%>%
  filter(substr(SIG_CD, 1, 2)=='11')

# 1. 24년도 총 직장 인구수가 가장 많은 자치구 5개만 지도로 표현
salaryman=read.csv('서울시 상권분석서비스(직장인구-자치구).csv',
                   fileEncoding = 'CP949',
                   encoding = 'UTF-8',
                   check.names = FALSE)
#View(salaryman)

salaryman=salaryman%>%
  mutate(자치구_코드=as.character(자치구_코드))
print(str(salaryman$자치구_코드))

merged_salaryman=inner_join(seoul_map, salaryman, by=c('SIG_CD'='자치구_코드'))%>%
  mutate(year=substr(기준_년분기_코드, 1, 4))%>%
  filter(year=='2024')%>%
  group_by(자치구_코드_명)%>%
  summarise(total_직장인구수=sum(총_직장_인구_수))%>%
  arrange(desc(total_직장인구수))%>%
  slice_head(n=5)
#View(merged_salaryman) 

p=ggplot(data=merged_salaryman)+
  geom_sf(fill='white', color='black')+
  scale_fill_gradient(low='yellow', high='blue', name='총직장인구수')+
  geom_sf_interactive(aes(fill=total_직장인구수,
                          tooltip=자치구_코드_명))+
  theme_minimal()+
  labs(title='2024년 총 직장 인구수',
       x='경도',
       y='위도')
p=girafe(ggobj=p)
#print(p)




# 2. 24년도 서울 총 직장인 인구 수 대비 각 자치구 직장인 인구 수 비율 구하기
# 2024년만 추출
salaryman_2024=salaryman%>%
  mutate(year=substr(기준_년분기_코드, 1, 4))%>%
  filter(year=='2024')

# 2024년 서울 총_직장_인구_수
total_seoul=sum(salaryman_2024$총_직장_인구_수)
print(total_seoul)

# 2024년 총 직장_인구_수 대비 각 자치구 직장_인구_수 비율
salaryman_rate=inner_join(seoul_map, salaryman_2024, by=c('SIG_CD'='자치구_코드'))%>%
  group_by(자치구_코드_명)%>%
  summarise(자치구_직장인_rate=(sum(총_직장_인구_수) / total_seoul)*100)
#View(salaryman_rate)

# 지도 시각화
p2=ggplot(data=salaryman_rate)+
  geom_sf(fill='white', color='black')+
  scale_fill_gradient(low='#ececec', high='blue', name='직장인구수 비율')+
  geom_sf_interactive(aes(fill=자치구_직장인_rate,
                          tooltip=자치구_코드_명))+
  theme_minimal()+
  labs(title='2024년 서울시 각 자치구별 직장인구수',
       x='경도',
       y='위도')
p2=girafe(ggobj = p2)
print(p2)

