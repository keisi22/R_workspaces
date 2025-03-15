library(dplyr)
netflix = read.csv('netflix.csv') #데이터셋 읽기
# 3번 데이터셋에서 title, type, release_year 열만 선택하세요.
result = netflix %>% select('title','type', 'release_year')
# 6번 'TV-MA 등급'의 'TV 프로그램'만 필터링하세요.
result = netflix %>% 
  filter(type == 'TV Show' & rating == 'TV-MA')
# 7번 director가 "Mike Flanagan"인 영화의 
# title, director, country 열을 선택하세요.
result = netflix %>% 
  filter(type == 'Movie' & director == 'Mike Flanagan') %>%
  select(title, director, country)
# 문제 10: TV 프로그램(type == "TV Show") 중 
# 시즌 수(duration)를 기준으로 오름차순으로 정렬하세요.
# 문제발생: 'duration' 컬럼에 숫자와 문자가 존재함.
# 문자열을 제거(특정 문자로 대체) -> gsub
# *텍스트 데이터에서 숫자만 추출 뒤 정렬하는게 포인트
result = netflix %>% 
  filter(type == "TV Show") %>%
  mutate(seansons = as.numeric(gsub(' Season[s]?',"",duration))) %>%
  arrange(seansons)

library(dplyr)
netflix = read.csv('netflix.csv') #데이터셋 읽기

# 퀴즈) 2021년에 제작된 영화의 평균 길이를 구하세요.
# filter
# 평균 : mean
# summarise
# 문자 제거 -> gsub(문자제거) -> as.numeric (형변환) 
result = netflix %>% 
  filter(type == 'Movie' & release_year == 2021) %>% 
  summarise(avg_duraion = mean(as.numeric(gsub(" min","",duration
  ))))
# View(result)

# 퀴즈) 년도별 제작된 영화의 평균 길이를 구하세요.
# group_by + summarise
# filter
# mean
# gsub
result = netflix %>% 
  filter(type == 'Movie') %>% 
  group_by(release_year) %>% 
  summarise(avg_duraion = mean(as.numeric(gsub(" min","",duration
  )),na.rm = TRUE)) 
# View(result)

# 장르가 Comedies인 `영화`의 제목
# listed_in %in% c('Comedies') : listed_in에 Comedies가
# 포함되었는지 체크해줌.
result = netflix %>%
  filter(type == 'Movie' & listed_in %in% c('Comedies')) %>%
  select(title)
# View(result)

# `International TV Shows` 장르에 속하고, TV-MA 등급인 
#  TV Show의 title과 제작 국가 추출하시오.

result = netflix %>%
  filter(type == 'TV Show' & 
           listed_in %in% c('International TV Shows') &
           rating == 'TV-MA') %>%
  nrow()
# nrow() : 행 개수, number of rows
# View(result)

# United States에서 제작된 `영화`의 개수 추출

result = netflix %>% 
  filter(type == 'Movie' & country == 'United States') %>% 
  nrow()
print(result)

# 국가별 영화 수
# country != '' (빈값 체크하는 방법)
result = netflix %>%
  filter(type == 'Movie' & country != '') %>%
  group_by(country) %>%
  summarise(count = n())
# View(result)

# 국가별 영화 수 -> 가장 영화가 많은 국가(상위 5개만 추출)
# 등수 구하는 분석할 때 `정렬`
result = netflix %>%
  filter(type == 'Movie' & country != '') %>%
  group_by(country) %>%
  summarise(count = n()) %>%
  arrange(desc(count)) %>%
  slice_head(n = 5) #상위 5개

#View(result)

# 감독별 가장 많이 넷플릭스에 등록한 감독 상위 1명 조회
# ~별 : group_by + summarise
# 등수 -> 정렬 (arrange)
top_director = netflix %>%
  filter(director != '') %>%
  group_by(director) %>%
  summarise(count = n()) %>%
  arrange(desc(count)) %>%
  slice_head(n = 1)
print(top_director)

# 넷플릭스 가장 많이 등장하는 장르 상위 5개
# group_by

# install.packages("tidyr")
library(tidyr) # <- separate_rows(사용가능)
# separate_rows : 디플리알 문법 x
# 콤마로 구분된 문자열 처리할 때
# separate: 분리하다
# ***separate_rows(listed_in, sep = ", ")
# => listed_in 분리할꺼야! sep = ", " <- 요기준으로 
# 분리 부탁해~!
# sep: separate
top_genre = netflix %>%
  separate_rows(listed_in, sep = ", ") %>%
  group_by(listed_in) %>%
  summarise(count = n()) %>%
  arrange(desc(count)) %>%
  slice_head(n = 5)

View(top_genre)



