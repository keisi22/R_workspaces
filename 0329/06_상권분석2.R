# 특정 지역의 상권 생존률과 폐업률 알아내기
# 가중치 없이

library(dplyr)
library(ggplot2)

# 2024년 통계를 가지고 2025년 생존률 폐업률 예상하기
# 분기로 되어있음

# 데이터 전처리
# substr 을 이용해서 2024년 1분기에서 4분기까지
# 운영_영업_개원_평균, 폐업_영업_개월_평균
# 총 2개의 컬럼 평균 구하기

seoul_comm_data=read.csv('seoul_commercial_analysis.csv',
                         fileEncoding = 'CP949',
                         encoding = 'UTF-8',
                         check.names = FALSE)

#seoul_comm_data=seoul_comm_data%>%
#  filter(substr(기준_년분기_코드, 1, 4)=='2024')%>%
#  group_by(자치구_코드_명)%>%
#  summarise(운영영업_평균=mean(운영_영업_개월_평균),
#        폐업영업_평균=mean(폐업_영업_개월_평균))


seoul_comm_data=seoul_comm_data%>%
  mutate(year=substr(기준_년분기_코드, 1, 4))

seoul_2024_data=seoul_comm_data%>%
  filter(year=='2024')%>%
  group_by(자치구_코드_명)%>%
  summarise(운영평균=mean(운영_영업_개월_평균),
            폐업평균=mean(폐업_영업_개월_평균),
            서울전체평균운영=mean(서울_운영_영업_개월_평균),
            서울전체평균폐업=mean(서울_폐업_영업_개월_평균))
#View(seoul_2024_data)


# 서초구 생존확률
# 2024년 데이터가 없어서, 2022년도 대체
seochogu_live_rate = 33 # 24년 서초구 생존률 -> 33% 가정
seochogu_close_rate = 32 # 24년 서초구 폐업율 -> 32% 가정

# 서초구 평균영업, 평균 폐업 조회
seochugu=seoul_2024_data %>%
  filter(자치구_코드_명=='서초구')%>%
  select(운영평균, 폐업평균)
#View(seochugu)

# 2025년 서초구 상권 생존율/폐업율 계산
생존확률_2025=seochogu_live_rate*(seochugu$운영평균/(seochugu$운영평균 + seochugu$폐업평균))

폐업확률_2025=seochogu_close_rate*(seochugu$폐업평균/(seochugu$운영평균 + seochugu$폐업평균))

# 결과 출력
cat(
  sprintf('2025년 서초구 상권 생존확률 예상 : %.2f%%\n', 생존확률_2025),
  sprintf('2025년 서초구 상권 폐업확률 예상 : %.2f%%', 폐업확률_2025)
)


# 종로구 생존확률, 폐업확률
# 25년 종로구 상권 생존율 20%
# 25년 종로구 상권 폐업율 35% 가정

jongrogu_live_rate = 20
jongrogu_close_rate = 35

jongrogu=seoul_2024_data %>%
  filter(자치구_코드_명=='종로구')%>%
  select(운영평균, 폐업평균)

생존확률_종로구_2025=jongrogu_live_rate*(jongrogu$운영평균/(jongrogu$운영평균 + jongrogu$폐업평균))
폐업확률_종로구_2505=jongrogu_close_rate*(jongrogu$운영평균/(jongrogu$운영평균 + jongrogu$폐업평균))

cat(
  sprintf('2025년 종로구 상권 생존확률 예상 : %.2f%%\n', 생존확률_종로구_2025),
  sprintf('2025년 종로구 상권 폐업확률 예상 : %.2f%%', 폐업확률_종로구_2025)
)

