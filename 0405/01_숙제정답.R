library(sf)
library(dplyr)
library(ggplot2)
library(ggiraph)

setwd('D:/r-data')
# 서울시 행정구역 Shapefile 불러오기
korea_map = st_read('sig.shp')
# 서울만 가져오기
seoul_map = korea_map %>%
  filter(substr(SIG_CD, 1, 2) == '11') #substr로 데이터 필터링

seoul_worker_data = read.csv('서울시 상권분석서비스(직장인구-자치구).csv',
                             fileEncoding = 'CP949', 
                             encoding = 'UTF-8', 
                             check.names = FALSE)

#print(str(seoul_worker_data)) #데이터구조 확인하기
#View(seoul_worker_data) #데이터 확인하기

# 1. 24년도 총 직장 인구수 가 가장많은 자치구 5개만 지도로 표현
# 형변환 하기 why? 직장인구 데이터 자치구 코드가 int형입니다. shp파일과 병합하기 위해 문자형으로 변경합니다.
seoul_worker_data = seoul_worker_data %>%
  mutate(자치구_코드 = as.character(자치구_코드))

# shp파일과 병합
# 병합하고자 하는 컬럼 데어터타입이 같아야 함
merged_data = inner_join(seoul_map, seoul_worker_data, by = c( 'SIG_CD' = '자치구_코드')) %>%
  filter(substr(기준_년분기_코드, 1, 4) == 2024) %>%
  group_by(자치구_코드_명) %>%
  summarise(총직장인수 = sum(총_직장_인구_수)) %>%
  arrange(desc(총직장인수)) %>%
  slice_head(n = 5)

#View(merged_data)

# 지도 시각화
result = ggplot(data = merged_data) +
  scale_fill_gradient(low = "#ececec", high = "blue", name = "총직장인수") + # 농도에 따라 색상 조절
  geom_sf_interactive(aes(
    fill = 총직장인수,
    tooltip = 자치구_코드_명,  # 마우스 호버 시 표시될 정보
    data_id = 자치구_코드_명   # 각 영역을 고유하게 식별하기 위한 ID
  )) +
  theme_minimal() +
  labs(title = "서울시 직장인구수 TOP 5", x = "경도", y = "위도")

# 인터랙티브 그래프 생성
girafe_plot =  girafe(ggobj = result)

# 결과 출력
print(girafe_plot)

# 2. 24년도 서울 총 직장인 인구 수 대비 각 자치구 직장인 인구 수 비율 구하기
# merged_data2 데이터프레임 생성
merged_data2 = inner_join(seoul_map, seoul_worker_data, by = c( 'SIG_CD' = '자치구_코드')) %>%
  filter(substr(기준_년분기_코드, 1, 4) == 2024) %>%
  mutate(서울_2024_직장인수 = sum(총_직장_인구_수))


merged_data2 = merged_data2 %>%
  filter(substr(기준_년분기_코드, 1, 4) == 2024) %>%
  group_by(자치구_코드_명, 서울_2024_직장인수) %>%
  summarise(총직장인수 = sum(총_직장_인구_수)) %>%
  mutate(직장인비율 =  round((총직장인수 / 서울_2024_직장인수) * 100, 1)) %>% #round(,1)은 소수점 1자리 까지 출력
  arrange(desc(직장인비율))

View(merged_data2)