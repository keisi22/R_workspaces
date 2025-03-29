library(sf)
library(dplyr)
library(ggplot2)
library(ggiraph)

korea_map = st_read('sig.shp')

# 2. 서울만 가져오기
seoul_map = korea_map %>%
  filter(substr(SIG_CD, 1, 2) == '11')

# 3. 상권분석 csv 파일 불러오기
seoul_comm_data = read.csv('seoul_commercial_analysis.csv',
                           fileEncoding = 'CP949',
                           encoding = 'UTF-8',
                           check.names = FALSE)

# 퀴즈
# seoul_commercial_analysis.csv 확인 후
# 컬럼 `자치구_코드` 생성 후 기존 `자치구_코드`를 
# 문자로 형변환 해서 대입하기.

# 형변환? 자치구 코드가 뭐길래? 왜 문자로 변환?
# 1. 데이터프레임의 구조를 확인하자
# print(str(seoul_comm_data)) # 구조 확인 ***str

# 형변환
seoul_comm_data = seoul_comm_data %>%
  mutate(자치구_코드 = as.character(자치구_코드))

# 자치구 코드를 문자로 바꾼 이유?
# shp(지도)파일에 자치구 코드가 있는데 
# 지도파일에 자치구 코드가 문자형이여서

# 왜? 병합(join)하기 위해서
# 지도데이터(shp)와 상권데이터(csv) 병합하기

# seoul_map에 있는 SIG_CD와
# seoul_comm_data에 있는 자치구_코드를 `기준`으로 
# 두 파일 병합하기
merged_data = inner_join(seoul_map, seoul_comm_data,
                         by = c("SIG_CD" = "자치구_코드"))

# View(merged_data) #병합 확인

# 퀴즈. SIG_CD, 자치구 코드 명, geometry(위,경도)를 
# 그룹핑 해서 전체 `폐업 영업 개월 평균` 의 평균 구하기
# 폐업영업평균이 60이하면 High, 아니면 Normal을 나타내는
# 위험도 컬럼 추가할 것

merged_data = merged_data %>%
  group_by(SIG_CD, 자치구_코드_명, geometry) %>%
  summarise(영업평균 = mean(폐업_영업_개월_평균)) %>%
  mutate(위험도 = ifelse(영업평균 <= 60, 'High', 'Normal'))

# 사분위수를 이용해서 특정구간 알고 싶을 때
# quantile : 사분위수 (데이터를 4등분 하는 기준값)
# 25%. 50%, 75%

quantiles=quantile(merged_data$영업평균)
merged_data = merged_data %>%
  filter(영업평균 >= quantiles['75%'])

# View(merged_data) # 결과 확인

# 지도 시각화
p = ggplot(data = merged_data) + 
  scale_fill_gradient(low = "#ececec"
                      , high = "blue"
                      , name = "영업평균") +
  geom_sf_interactive(
    aes(
      fill = 영업평균, # 영업 평균 데이터를 지도에 채우기
      tooltip = 자치구_코드_명,
      data_id = SIG_CD
    )
  ) + # 마우스 호버 이벤트
  theme_minimal() + 
  labs(title = "서울시 폐업 평균 개월",
       x = "경도",
       y = "위도")

girafe_plot = girafe(ggobj = p) #인터랙티브 지도 생성

print(girafe_plot) #지도 출력

