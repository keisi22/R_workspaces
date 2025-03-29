library(dplyr)
library(ggplot2)
library(sf) # 지도 시각화
library(ggiraph) # 지도 시각화 이벤트

# 1. 지도 시각화를 구현하기 위해서는 '지도데이터'
# 지도 데이터? ShapeFile이 필요
# shp 파일은 지리정보시스템에서 사용되는 벡터 데이터 형식으로
# 공간데이터 저장, 표현하는데 사용

korea_map=st_read('sig.shp')
View(korea_map)

# 서울만 가져오기
seoul_map=korea_map%>%
  filter(substr(SIG_CD, 1, 2)=='11') # 서울만 가져오기

# 2.지도 시각화
p=ggplot(data=seoul_map)+
  geom_sf(fill='white', color='black')+ # 흰색 채우고, 경계선 검은색
  theme_minimal()+ # 배경 제거
  labs(title='서울특별시 행정구역',
       x='경도',
       y='위도')+
  coord_sf() #지도 비율 유지
 print(p)
 
 