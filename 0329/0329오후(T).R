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
# 예, (올해 - 작년 / 작년) * 100
# increase_rate 컬럼 생성
# diff: 연속된 값들 사이의 차이를 계산
df$increase_rate = 
  c(0, diff(df$elder_count) / 
      df$elder_count[-length(df$elder_count)] * 100 )

print(df)

# diff: 연속된 값들 사이의 `차이`를 계산
x = c(10,20,30,40)
print(diff(x)) # 20 - 10 /  30 - 20 / 40 - 30

# length : 길이
print(length(df$elder_count)) #데이터 수(길이) == count
print(df$elder_count[-3]) # 3번째 데이터 빼고 출력

# View(df)

# 폐업 확률 구해보자
# 폐점 확률(가중평균) 
# 노인율 = 초기노인율 + 노인증가율(v)
# 폐업율 = 초기폐점율 + 폐업증가율

# 가중치는 우리가 정하는 것
# 전체 가중치 합 1
# 노인 가중치 0.6(유동인구 증가, 노인 소비패턴...)
# 폐업 가중치 0.4(임대료상승, 경기침체...)

# 폐점 확률 = (노인율 * 노인 가중치) + (폐점율 * 폐점 가중치)


# 노인율
elder2 = read.csv('2022_2024_주민등록인구기타현황(고령 인구현황)_연간.csv',
                  fileEncoding = 'CP949', 
                  encoding = 'UTF-8', 
                  check.names = FALSE)

# 콤마 제거하기
# 2024년_전체, 2024년_65세이상전체 컬럼들 콤마 제거하기(디플리알)
elder2 = elder2 %>%
  mutate(
    인구수_2024 = as.numeric(gsub(",","",`2024년_전체`)),
    노인수_2024 = as.numeric(gsub(",","",`2024년_65세이상전체`)),
    인구수대비노인율 = (노인수_2024 / 인구수_2024) * 100
  )
# View(elder2)

# 초기노인율(2024년 가정)
jongno_init_elder_rate = elder2 %>%
  filter(행정구역 == '서울특별시 종로구 (1111000000)') %>%
  select(인구수대비노인율)

# print(jongno_init_elder_rate) # 결과 확인

# 노인율 = 초기노인율 + 노인증가율
jongno = jongno_init_elder_rate + 3.7
# 폐업율 = 초기폐점율 + 폐업증가율 
close = 13 #가정

# 가중치 설정
# 가중치 0.6과 0.4 설정 이유
# 두 요인의 상대적 기여도 비율 6:4 라고 가정
elder_w = 0.6 #노인 가중치(노인인구수 증가, 유동인구 감소 등...)
close_w = 0.4 #폐점 가중치(임대료 상승, 경기침체 등...)

# 최종 폐점 확률(종로구)
close_rate = (jongno * elder_w) + (close * close_w)
print('종로구 신규오픈 시 예상 폐점 확률 : ')
print(close_rate$인구수대비노인율) # 최종 폐점확률 20%


# 특정 지역의 상권 생존률과 폐업률 알아내기
# 가중치 없이
library(dplyr) # 전처리 도구
library(ggplot2) # 그래프 도구

# 2024년 통계를 가지고 2025년도 생존률, 폐업률 예상하기.
# 분기로 되어있음.

# 데이터 전처리
# substr 을 이용해서 2024 1분기 부터 4분기까지
# 운영_영업_개월_평균, 폐업_영업_개월_평균
# 총 2개의 컬럼 평균 구하기.

seoul_commercial_data = read.csv('seoul_commercial_analysis.csv', 
                                 fileEncoding = 'CP949', 
                                 encoding = 'UTF-8', 
                                 check.names = FALSE)


# 분기로 되어있는 데이터를 년도로 바꾸자

seoul_commercial_data = seoul_commercial_data %>%
  mutate(year = substr(기준_년분기_코드,1,4))

# View(seoul_commercial_data)

seoul_2024_data = seoul_commercial_data %>%
  filter(year == 2024) %>%
  group_by(자치구_코드_명) %>%
  summarise(
    평균폐업 = mean(폐업_영업_개월_평균),
    평균운영 = mean(운영_영업_개월_평균),
    서울전체평균운영 = mean(서울_운영_영업_개월_평균),
    서울전체평균폐업 = mean(서울_폐업_영업_개월_평균)
  )
#View(seoul_2024_data)

# 서초구 생존확률
# 2024년도 데이터가 없어서, 2022년도 대체 (구했다고 가정)
seochogu_live_rate = 33 # 24년 서초구 생존율 -> 33% 가정
seochogu_close_rate = 32 # 24년 서초구 폐업율 -> 32% 가정


# 서초구 평균영업,평균 폐업 조회
seochogu = seoul_2024_data %>%
  filter(자치구_코드_명 == '서초구') %>%
  select(평균운영, 평균폐업)

# View(seochogu)

# 2025년 서초구 상권 생존율/폐업률 계산
생존확률_2025 = seochogu_live_rate * 
  (seochogu$평균운영 / (seochogu$평균운영 + seochogu$평균폐업))

폐업확률_2025 = seochogu_close_rate * 
  (seochogu$평균폐업 / (seochogu$평균운영 + seochogu$평균폐업))

# 결과 출력
# %.2f%% -> 소수점 2자리 까지만 출력하겠다.
cat(
  sprintf('2025년 서초구 상권 생존확률 예상 : %.2f%%\n',생존확률_2025),
  sprintf('2025년 서초구 상권 폐업확률 예상 : %.2f%%\n',폐업확률_2025)
)

# 종로구 생존확률, 폐업확률 구해보기
# 24년 종로구 상권 생존율 20%
# 24년 종로구 상권 폐업율 35% 라고 가정.
jongnogu = seoul_2024_data %>%
  filter(자치구_코드_명 == '종로구') %>%
  select(평균운영, 평균폐업)

jongnogu_live_rate = 20 # 24년 종로구 생존율
jongnogu_close_rate = 25 # 24년 종로구 폐업율

# 2025년 종로구 상권 생존율/폐업률 계산
종로구_생존확률_2025 = jongnogu_live_rate * 
  (jongnogu$평균운영 / (jongnogu$평균운영 + jongnogu$평균폐업))

종로구_폐업확률_2025 = jongnogu_close_rate * 
  (jongnogu$평균폐업 / (jongnogu$평균운영 + jongnogu$평균폐업))

# 결과 출력
# %.2f%% -> 소수점 2자리 까지만 출력하겠다.
cat(
  sprintf('2025년 종로구 상권 생존확률 예상 : %.2f%%\n',종로구_생존확률_2025),
  sprintf('2025년 종로구 상권 폐업확률 예상 : %.2f%%',종로구_폐업확률_2025)
)
# 영업/폐업 지속 개월수를 고려한 비율 계산




