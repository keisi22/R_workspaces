# 산점도 그래프 -> 두 개의 변수 관계 확인
# 예) 키 vs 몸무게, 중간고사 vs 기말고사

# 막대 그래프 -> 그룹별 빈도나 크기를 비교할 때
# 예) 판매량 비교, 직업별 소득

# 박스 플롯 -> 데이터의 분포를 표현
# 예) 간 반 또는 학년 별 성적 분포, 주식 차트

# 오늘 배울 그래프
# 선 그래프
# 지도 시각화


# 산점도 그래프 복습
# 넷플릭스 데이터셋을 사용하여 
# 출신 연도 vs 영화 길이 관계 파악
library(ggplot2) #그래프 도구
library(dplyr) #전처리 도구

# 데이터 불러오기
setwd('D:/r-data')
netflix_data = read.csv('netflix.csv')

# 데이터 확인
# View(netflix_data)

# 데이터 전처리
# 영화의 상영시간을 알아내야 함.

# *****문자열 복습
# gsub: 다른 문자로 `대체`
# strsplit: 특정 문자를 기준으로 `나누다`
# substr: 특정 위치 문자만 `추출(오려내기)`
movie_data = netflix_data %>%
  filter(type == 'Movie') %>% #영화만 필터링
  mutate(gsub_duration =  as.numeric(gsub(' min',"", duration))) 
# duration 컬럼 데이터  min -> "" 로 대체
# 'min'를 제거한 새로운 컬럼 생성
# View(movie_data)

# 산점도 그래프 생성
# 1. data = movie_data : 그래프에 데이터 삽입
# 2. aes(aesthetics) 미학 : x축, y축 설정
# 3. 산점도 생성
p = ggplot(data = movie_data, aes(x = release_year,
                                  y = gsub_duration)) +
  geom_point() + #산점도 그래프 생성
  geom_smooth(method = "lm", color = "red") + #회귀선 추가, lm(linear model) 
  labs(title = "영화 길이 vs 출시연도",
       x = "출시연도",
       y = "영화길이(분)")

print(p)


# 선그래프 
# 순서가 있는 변수를 x 축에 배치, 이에 따른 y 축
# 값의 변화를 선으로 연결하여 시각화하는 그래프
# 시간의 흐름에 따른 데이터 표현할 때 많이 사용
library(ggplot2) #그래프 도구
library(dplyr) #전처리 도구

# 데이터 프레임생성
df = data.frame(
  Time = c("2025-03-01","2025-03-02","2025-03-03"), #시간
  Revenue = c(300,500,2500) #수익
)
# 컴퓨터는 문자 아니면 숫자만 알아요
# Time을 날짜 형변환
df$Time = as.Date(df$Time) #문자 -> 날짜

# 선 그래프 생성
p = ggplot(data = df, aes(x = Time, y = Revenue)) +
  geom_line(color = "blue") + # 선 그래프 설정
  labs(
    title = "시간에 따른 수익금",
    x = "날짜",
    y = "수익금"
  )
print(p)


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

# 사분위수를 이용해서 특정 구간 알고 싶을 때
# quantile: 사분위수 (데이터를 4등분 하는 기준 값)
# 25%, 50%, 75% 
quantiles = quantile(merged_data$영업평균)
merged_data = merged_data %>%
  filter(영업평균 >= quantiles["75%"])

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



# 종로구하고 중구,용산구가 현재 가장 폐업율이 높다.
# 왜 높을까? 
# 1. 물가 상승 2. 노인 수 급증

# 노인 수가 많을 것 이다.(추측)
# 종로구 노인 인구 비율을 조회해보자.

library(dplyr) # 전처리 도구
library(ggplot2) # 그래프 도구

elder = read.csv('고령인구현황.csv',
                 fileEncoding = 'CP949', 
                 encoding = 'UTF-8', 
                 check.names = FALSE)

# 전처리
# 종로구의 22년,23년,24년 65세이상전체 컬럼 조회
elder_group = elder %>%
  filter(행정구역 == '서울특별시 종로구 (1111000000)') %>%
  select(`2022년_65세이상전체`, 
         `2023년_65세이상전체`, 
         `2024년_65세이상전체`)
# View(elder_group)
# 변화된 데이터를 선 그래프로 표현

df = data.frame(
  #뒤에 월과 일은 꼭 입력해야합니다.
  time = c('2022-01-01','2023-01-01','2024-01-01'),
  elder_count = c(
    elder_group$`2022년_65세이상전체`,
    elder_group$`2023년_65세이상전체`,
    elder_group$`2024년_65세이상전체`))
# 형변환
df$time = as.Date(df$time)#문자 -> 날짜
df$elder_count = as.numeric(
  gsub(",","",df$elder_count) #콤마 제거 후 숫자로 변환
)
print(df) # 결과확인

p = ggplot(data = df, aes(x = time, y = elder_count)) +
  geom_line() +
  labs(title = "종로구 인구수 변화",
       x = "연도",
       y = "노인(65세 이상) 수")
print(p) # 그래프 확인

# 상승률 계산
# 상승률 : 최종 값 - 초기 값 / 초기 값 * 100
# 올해 - 작년 / 작년 * 100
# increase_rate 컬럼 생성
# diff: 연속된 값들 사이의 차이를 계산
df$increase_rate = 
  c(0, diff(df$elder_count) / 
      df$elder_count[-length(df$elder_count)] * 100 )

print(df) # 상승률 확인
